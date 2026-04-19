import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/style.dart';
import '../../model/yearly_goal.dart';
import '../../providers/goals_provider.dart';
import 'widgets/yearly_goal_card.dart';
import 'widgets/yearly_goal_detail_sheet.dart';
import 'yearly_goal_form.dart';

class VisionPage extends ConsumerStatefulWidget {
  const VisionPage({super.key});

  @override
  ConsumerState<VisionPage> createState() => _VisionPageState();
}

class _VisionPageState extends ConsumerState<VisionPage> {
  late PageController _pageController;
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;
    _pageController = PageController(initialPage: 500);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _yearForPage(int page) => DateTime.now().year + (page - 500);

  void _onPageChanged(int page) {
    setState(() => _selectedYear = _yearForPage(page));
  }

  Future<void> _openAddGoalForm() async {
    final result = await Navigator.push<YearlyGoal>(
      context,
      MaterialPageRoute(
        builder: (_) => YearlyGoalForm(year: _selectedYear),
      ),
    );
    if (result != null) {
      await ref.read(yearlyGoalsProvider.notifier).addGoal(result);
    }
  }

  Future<void> _openGoalDetail(YearlyGoal goal) async {
    final allWeekly =
        await ref.read(allWeeklyForYearProvider(goal.year).future);
    final relatedGoals =
        allWeekly.where((w) => w.relatedYearlyGoalId == goal.id).toList();

    if (!mounted) return;

    YearlyGoalDetailSheet.show(
      context,
      goal: goal,
      relatedGoals: relatedGoals,
      onEdit: (g) async {
        final result = await Navigator.push<YearlyGoal>(
          context,
          MaterialPageRoute(
            builder: (_) => YearlyGoalForm(year: g.year, yearlyGoal: g),
          ),
        );
        if (result != null) {
          await ref.read(yearlyGoalsProvider.notifier).updateGoal(result);
        }
      },
      onDelete: (g) async {
        if (g.id != null) {
          await ref.read(yearlyGoalsProvider.notifier).removeGoal(g.id!);
        }
      },
      onUpdateStatus: (g, status) async {
        await ref
            .read(yearlyGoalsProvider.notifier)
            .updateGoalStatus(g, status);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final goalsAsync =
        ref.watch(yearlyGoalsByYearProvider(_selectedYear));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // Title — swipeable year
        SizedBox(
          height: 80,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, page) {
              final year = _yearForPage(page);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$year Vision', style: headingXL),
                    const SizedBox(height: 4),
                    Text(
                      'Your long-term outcomes and progress.',
                      style: caption.copyWith(color: textMuted),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        // Goals list
        Expanded(
          child: goalsAsync.when(
            data: (goals) {
              final items = <Widget>[];

              for (final goal in goals) {
                items.add(
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                    child: YearlyGoalCard(
                      goal: goal,
                      onTap: () => _openGoalDetail(goal),
                    ),
                  ),
                );
              }

              // Add button
              items.add(
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                  child: _AddAmbitionCard(onTap: _openAddGoalForm),
                ),
              );

              // Bottom padding for nav bar
              items.add(const SizedBox(height: 100));

              return ListView(
                padding: EdgeInsets.zero,
                children: items,
              );
            },
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }
}

class _AddAmbitionCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddAmbitionCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(radiusLarge),
          border: Border.all(
            color: borderSoft,
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderSoft, width: 1.5),
              ),
              child: const Icon(Icons.add, color: textMuted, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              'Define new ambition',
              style: bodyLarge.copyWith(color: textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
