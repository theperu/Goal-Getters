import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/style.dart';
import '../../../model/habit.dart';
import '../../../model/habit_completion.dart';
import '../../../providers/habits_provider.dart';
import '../../../services/database/repositories/habit_repository.dart';
import 'habit_checkin_card.dart';

class HabitsCheckinSection extends ConsumerStatefulWidget {
  final DateTime selectedDate;

  const HabitsCheckinSection({super.key, required this.selectedDate});

  @override
  ConsumerState<HabitsCheckinSection> createState() =>
      _HabitsCheckinSectionState();
}

class _HabitsCheckinSectionState extends ConsumerState<HabitsCheckinSection> {
  String _dateStr(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(habitsProvider);
    final dateString = _dateStr(widget.selectedDate);

    // Watch completions for the selected date
    final completionsAsync =
        ref.watch(habitCompletionsForWeekProvider(dateString, dateString));

    return habitsAsync.when(
      data: (habits) {
        if (habits.isEmpty) return const SizedBox.shrink();

        return completionsAsync.when(
          data: (completions) => _buildSection(
            habits,
            completions,
            dateString,
          ),
          loading: () => _buildSection(habits, [], dateString),
          error: (_, __) => _buildSection(habits, [], dateString),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildSection(
    List<Habit> habits,
    List<HabitCompletion> completions,
    String dateString,
  ) {
    final completedHabitIds = completions.map((c) => c.habitId).toSet();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'HABITS CHECK-IN',
            style: caption.copyWith(
              color: textMuted,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Horizontal scrollable list
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: habits.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final habit = habits[index];
              final isCompleted = completedHabitIds.contains(habit.id);

              return HabitCheckinCard(
                name: habit.name,
                iconKey: habit.icon,
                colorKey: habit.color,
                isCompleted: isCompleted,
                onTap: () async {
                  final repo = ref.read(habitRepositoryProvider);
                  await toggleHabitCompletion(
                    repo,
                    habit.id!,
                    dateString,
                    isCompleted,
                  );
                  if (mounted) {
                    ref.invalidate(habitCompletionsForWeekProvider);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
