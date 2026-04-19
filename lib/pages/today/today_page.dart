import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/constants.dart';
import '../../constants/style.dart';
import '../../model/weekly_goal.dart';
import '../../model/yearly_goal.dart';
import '../../providers/goals_provider.dart';
import '../../providers/habits_provider.dart';
import '../../services/test_data_seeder.dart';
import '../../services/database/repositories/weekly_goal_repository.dart';
import '../../services/database/repositories/yearly_goal_repository.dart';
import '../../services/database/repositories/habit_repository.dart';
import '../../services/database/repositories/reflection_repository.dart';
import '../../services/database/goal_getters_database.dart';
import 'widgets/swipeable_week_selector.dart';
import 'widgets/goal_tile.dart';
import 'widgets/habits_checkin_section.dart';
import 'widgets/weekly_goal_detail_sheet.dart';

class TodayPage extends ConsumerStatefulWidget {
  const TodayPage({super.key});

  @override
  ConsumerState<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends ConsumerState<TodayPage> {
  late DateTime _selectedDate;
  int _titleTapCount = 0;
  DateTime? _lastTitleTap;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  void _onDaySelected(DateTime date) {
    setState(() => _selectedDate = date);
  }

  void _onTitleTap() {
    final now = DateTime.now();
    if (_lastTitleTap != null && now.difference(_lastTitleTap!).inMilliseconds > 800) {
      _titleTapCount = 0;
    }
    _lastTitleTap = now;
    _titleTapCount++;

    if (_titleTapCount >= 4) {
      _titleTapCount = 0;
      _showSeedDialog();
    }
  }

  Future<void> _showSeedDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Load test data?'),
        content: const Text(
          'This will replace all existing data with sample goals, habits, and completions.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Fill data')),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final seeder = TestDataSeeder(
        weeklyRepo: ref.read(weeklyGoalRepositoryProvider),
        yearlyRepo: ref.read(yearlyGoalRepositoryProvider),
        habitRepo: ref.read(habitRepositoryProvider),
        reflectionRepo: ref.read(reflectionRepositoryProvider),
        database: ref.read(databaseProvider),
      );
      await seeder.seed();
      // Refresh providers so UI picks up new data
      if (mounted) {
        ref.invalidate(weeklyGoalsProvider);
        ref.invalidate(habitsProvider);
        ref.invalidate(habitCompletionsForWeekProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Test data loaded!')),
        );
      }
    }
  }

  Future<void> _openGoalDetail(WeeklyGoal goal) async {
    // Fetch the related yearly goal if present
    YearlyGoal? relatedYearly;
    if (goal.relatedYearlyGoalId != null) {
      final yearlyGoals =
          await ref.read(yearlyGoalsByYearProvider(goal.year).future);
      relatedYearly = yearlyGoals
          .where((y) => y.id == goal.relatedYearlyGoalId)
          .firstOrNull;
    }
    if (!mounted) return;

    WeeklyGoalDetailSheet.show(
      context,
      goal: goal,
      relatedYearlyGoal: relatedYearly,
      onEdit: (g) async {
        final yearlyGoals =
            await ref.read(yearlyGoalsByYearProvider(g.year).future);
        if (!mounted) return;
        final result = await Navigator.pushNamed(
          context,
          '/add-goal',
          arguments: {
            'weeklyGoal': g,
            'yearlyGoals': yearlyGoals,
          },
        );
        if (result is WeeklyGoal && mounted) {
          await ref.read(weeklyGoalsProvider.notifier).updateGoal(result);
        }
      },
      onDelete: (g) async {
        if (g.id != null) {
          await ref.read(weeklyGoalsProvider.notifier).removeGoal(g.id!);
        }
      },
      onUpdateStatus: (g, status) async {
        await ref
            .read(weeklyGoalsProvider.notifier)
            .updateGoalStatus(g, status);
      },
      onGoalUpdated: (g) async {
        await ref.read(weeklyGoalsProvider.notifier).updateGoal(g);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentWeek = getWeekOfYear(_selectedDate);
    final currentYear = _selectedDate.year;
    final weeklyGoalsAsync = ref.watch(weeklyGoalsByWeekProvider(currentYear, currentWeek));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: App icon + name + progress pill
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/settings'),
                child: ClipOval(
                  child: Container(
                    width: 44,
                    height: 44,
                    color: lavender.withValues(alpha: 0.2),
                    child: Transform.scale(
                      scale: 2.0,
                      child: Image.asset(
                        'assets/icon.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: _onTitleTap,
                  child: const Text('Goal Getters', style: headingLarge),
                ),
              ),
              // Progress pill
              weeklyGoalsAsync.when(
                data: (goals) {
                  final done = goals.where((g) => g.status == 'Done').length;
                  final total = goals.length;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(radiusRound),
                      border: Border.all(color: borderSoft, width: 2),
                    ),
                    child: Text(
                      '$done/$total',
                      style: headingSmall.copyWith(
                        color: textSecondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Month & week label
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '${getMonthName(_selectedDate.month)} – Week ${getWeekOfYear(_selectedDate)}',
            style: caption.copyWith(color: textMuted),
          ),
        ),

        const SizedBox(height: 8),

        // Swipeable week day selector
        SwipeableWeekSelector(
          selectedDate: _selectedDate,
          onDaySelected: _onDaySelected,
        ),

        const SizedBox(height: 16),

        // Habits check-in
        HabitsCheckinSection(selectedDate: _selectedDate),

        const SizedBox(height: 16),

        // Goal list
        Expanded(
          child: weeklyGoalsAsync.when(
            data: (goals) => _GoalListForDay(
              goals: goals,
              selectedDate: _selectedDate,
              onToggle: (goal) async {
                final newStatus = goal.status == 'Done' ? 'Todo' : 'Done';
                await ref.read(weeklyGoalsProvider.notifier).updateGoalStatus(goal, newStatus);
              },
              onTap: (goal) => _openGoalDetail(goal),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }
}

class _GoalListForDay extends ConsumerWidget {
  final List<WeeklyGoal> goals;
  final DateTime selectedDate;
  final void Function(WeeklyGoal) onToggle;
  final void Function(WeeklyGoal) onTap;

  const _GoalListForDay({
    required this.goals,
    required this.selectedDate,
    required this.onToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedWeekday = selectedDate.weekday; // 1=Mon..7=Sun

    // Split into "today" goals (assigned to this day) and "coming up" (no day or different day)
    final todayGoals = goals
        .where((g) => g.dayOfWeek == selectedWeekday)
        .toList()
      ..sort(_sortByCompletion);
    final comingUpGoals = goals
        .where((g) => g.dayOfWeek == null || g.dayOfWeek != selectedWeekday)
        .toList()
      ..sort(_sortByCompletion);

    // Build a flat list of items: section headers, tiles, and add card
    final items = <_ListItem>[];

    if (todayGoals.isNotEmpty) {
      items.add(const _ListItem.header('To do today'));
      for (final g in todayGoals) {
        items.add(_ListItem.goal(g));
      }
    }

    if (comingUpGoals.isNotEmpty) {
      items.add(const _ListItem.header('Coming up'));
      for (final g in comingUpGoals) {
        items.add(_ListItem.goal(g));
      }
    }

    items.add(const _ListItem.addCard());

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
      itemCount: items.length,
      separatorBuilder: (_, index) {
        final item = items[index];
        // No separator after section headers (the header has its own bottom padding)
        if (item.type == _ListItemType.header) {
          return const SizedBox.shrink();
        }
        return const SizedBox(height: 12);
      },
      itemBuilder: (context, index) {
        final item = items[index];

        if (item.type == _ListItemType.header) {
          return Padding(
            padding: EdgeInsets.only(
              top: index == 0 ? 0 : 20,
              bottom: 10,
            ),
            child: Text(
              item.title!,
              style: labelMedium.copyWith(color: textSecondary),
            ),
          );
        }

        if (item.type == _ListItemType.goal) {
          return GoalTile(
            goal: item.goal!,
            onToggle: () => onToggle(item.goal!),
            onTap: () => onTap(item.goal!),
          );
        }

        // Add card
        return _AddFocusCard(
          onTap: () async {
            final currentWeek = getWeekOfYear(selectedDate);
            final currentYear = selectedDate.year;
            final yearlyGoals = await ref
                .read(yearlyGoalsByYearProvider(currentYear).future);
            if (!context.mounted) return;
            final result = await Navigator.pushNamed(
              context,
              '/add-goal',
              arguments: {
                'initialType': 'Weekly',
                'yearlyGoals': yearlyGoals,
              },
            );
            if (result is WeeklyGoal) {
              if (!context.mounted) return;
              final goalWithWeek = result.copy(
                week: currentWeek,
                year: currentYear,
              );
              await ref
                  .read(weeklyGoalsProvider.notifier)
                  .addGoal(goalWithWeek);
            }
          },
        );
      },
    );
  }

  static int _sortByCompletion(WeeklyGoal a, WeeklyGoal b) {
    final aDone = a.status == 'Done' ? 1 : 0;
    final bDone = b.status == 'Done' ? 1 : 0;
    return aDone.compareTo(bDone);
  }
}

enum _ListItemType { header, goal, addCard }

class _ListItem {
  final _ListItemType type;
  final String? title;
  final WeeklyGoal? goal;

  const _ListItem.header(this.title)
      : type = _ListItemType.header,
        goal = null;

  const _ListItem.goal(this.goal)
      : type = _ListItemType.goal,
        title = null;

  const _ListItem.addCard()
      : type = _ListItemType.addCard,
        title = null,
        goal = null;
}

class _AddFocusCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddFocusCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(radiusLarge),
          border: Border.all(
            color: borderSoft,
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, color: textMuted, size: 20),
            const SizedBox(width: 8),
            Text(
              'Add a focus',
              style: bodyLarge.copyWith(color: textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
