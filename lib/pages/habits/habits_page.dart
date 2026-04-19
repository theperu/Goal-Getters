import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/style.dart';
import '../../model/habit.dart';
import '../../model/habit_completion.dart';
import '../../providers/habits_provider.dart';
import '../../services/database/repositories/habit_repository.dart';
import 'habit_form.dart';
import 'widgets/habit_widgets.dart';

class HabitsPage extends ConsumerStatefulWidget {
  const HabitsPage({super.key});

  @override
  ConsumerState<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends ConsumerState<HabitsPage> {
  late PageController _pageController;
  late DateTime _selectedWeekMonday;

  @override
  void initState() {
    super.initState();
    _selectedWeekMonday = mondayOfWeek(DateTime.now());
    _pageController = PageController(initialPage: 500);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DateTime _mondayForPage(int page) {
    final offset = page - 500;
    return _initialMonday().add(Duration(days: offset * 7));
  }

  DateTime _initialMonday() => mondayOfWeek(DateTime.now());

  void _onPageChanged(int page) {
    setState(() => _selectedWeekMonday = _mondayForPage(page));
  }

  Future<void> _openAddHabitForm() async {
    final result = await Navigator.push<Habit>(
      context,
      MaterialPageRoute(builder: (_) => const HabitForm()),
    );
    if (result != null) {
      await ref.read(habitsProvider.notifier).addHabit(result);
    }
  }

  Future<void> _openEditHabitForm(Habit habit) async {
    final result = await Navigator.push<Habit>(
      context,
      MaterialPageRoute(builder: (_) => HabitForm(habit: habit)),
    );
    if (result != null) {
      await ref.read(habitsProvider.notifier).updateHabit(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(habitsProvider);

    return habitsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (habits) => _HabitsContent(
        habits: habits,
        pageController: _pageController,
        selectedWeekMonday: _selectedWeekMonday,
        onPageChanged: _onPageChanged,
        onAddHabit: _openAddHabitForm,
        onEditHabit: _openEditHabitForm,
        ref: ref,
      ),
    );
  }
}

class _HabitsContent extends StatefulWidget {
  final List<Habit> habits;
  final PageController pageController;
  final DateTime selectedWeekMonday;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onAddHabit;
  final void Function(Habit) onEditHabit;
  final WidgetRef ref;

  const _HabitsContent({
    required this.habits,
    required this.pageController,
    required this.selectedWeekMonday,
    required this.onPageChanged,
    required this.onAddHabit,
    required this.onEditHabit,
    required this.ref,
  });

  @override
  State<_HabitsContent> createState() => _HabitsContentState();
}

class _HabitsContentState extends State<_HabitsContent> {
  StreakResult? _streaks;
  double? _consistency;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  @override
  void didUpdateWidget(covariant _HabitsContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.habits != widget.habits) {
      _loadStats();
    }
  }

  Future<void> _loadStats() async {
    if (widget.habits.isEmpty) {
      setState(() {
        _streaks = StreakResult(currentStreak: 0, bestStreak: 0);
        _consistency = 0;
      });
      return;
    }
    final repo = widget.ref.read(habitRepositoryProvider);
    final streaks = await computeStreaks(repo, widget.habits);
    final consistency = await computeConsistency(repo, widget.habits);
    if (mounted) {
      setState(() {
        _streaks = streaks;
        _consistency = consistency;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Static header section ──────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Row(
            children: [
              const Expanded(
                child: Text('Habits', style: headingXL),
              ),
              if (_consistency != null)
                ConsistencyPill(percentage: _consistency!),
            ],
          ),
        ),

        const SizedBox(height: 20),

        if (_streaks != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                StreakCard(
                  label: 'Current Best',
                  weeks: _streaks!.currentStreak,
                  habitName: _streaks!.currentHabitName,
                ),
                const SizedBox(width: 12),
                StreakCard(
                  label: 'All-time Best',
                  weeks: _streaks!.bestStreak,
                  habitName: _streaks!.bestHabitName,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],

        // ── Swipeable week section ─────────────────────────
        Expanded(
          child: PageView.builder(
            controller: widget.pageController,
            onPageChanged: widget.onPageChanged,
            itemBuilder: (context, page) {
              final monday = mondayOfWeek(DateTime.now())
                  .add(Duration(days: (page - 500) * 7));
              final weekDates = weekDatesFor(monday);
              final startDate = weekDates.first;
              final endDate = weekDates.last;

              final completionsAsync = widget.ref
                  .watch(habitCompletionsForWeekProvider(startDate, endDate));

              return completionsAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (completions) => _WeekHabitList(
                  habits: widget.habits,
                  completions: completions,
                  weekDates: weekDates,
                  monday: monday,
                  onAddHabit: widget.onAddHabit,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// The week-specific, swipeable portion: week label + habit cards + add button.
class _WeekHabitList extends StatelessWidget {
  final List<Habit> habits;
  final List<HabitCompletion> completions;
  final List<String> weekDates;
  final DateTime monday;
  final VoidCallback onAddHabit;

  const _WeekHabitList({
    required this.habits,
    required this.completions,
    required this.weekDates,
    required this.monday,
    required this.onAddHabit,
  });

  @override
  Widget build(BuildContext context) {
    final completionsByHabit = <int, Set<String>>{};
    for (final c in completions) {
      completionsByHabit.putIfAbsent(c.habitId, () => {}).add(c.date);
    }

    final sunday = monday.add(const Duration(days: 6));
    final weekLabel = _formatWeekLabel(monday, sunday);

    // Only show habits that existed during this week
    final visibleHabits = habits.where((h) {
      if (h.createdAt == null) return true;
      // Show if created on or before this week's Sunday
      final created = DateTime(h.createdAt!.year, h.createdAt!.month, h.createdAt!.day);
      return !created.isAfter(sunday);
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
      children: [
        // Week label
        Text(
          weekLabel,
          style: caption.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          'ACTIVE HABITS',
          style: caption.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),

        const SizedBox(height: 12),

        if (visibleHabits.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                'No habits yet.\nTap + to create your first habit!',
                textAlign: TextAlign.center,
                style: bodyMedium.copyWith(color: textMuted),
              ),
            ),
          ),

        ...visibleHabits.map((habit) {
          final completedDates = completionsByHabit[habit.id] ?? {};
          final completedCount = completedDates.length;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: HabitCard(
              name: habit.name,
              iconKey: habit.icon,
              colorKey: habit.color,
              completedThisWeek: completedCount,
              timesPerWeek: habit.timesPerWeek,
              completedDates: completedDates,
              weekDates: weekDates,
            ),
          );
        }),

        const SizedBox(height: 8),

        GestureDetector(
          onTap: onAddHabit,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(radiusLarge),
              border: Border.all(color: borderSoft, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_rounded, color: primaryLavender, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Add Habit',
                  style: bodyMedium.copyWith(
                    color: primaryLavender,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static String _formatWeekLabel(DateTime monday, DateTime sunday) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[monday.month - 1]} ${monday.day} – ${months[sunday.month - 1]} ${sunday.day}';
  }
}
