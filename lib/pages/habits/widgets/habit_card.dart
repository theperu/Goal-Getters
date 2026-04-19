import 'package:flutter/material.dart';
import '../../../constants/goal_icons.dart';
import '../../../constants/habit_colors.dart';
import '../../../constants/style.dart';
import 'week_bars.dart';

/// A single habit card row.
class HabitCard extends StatelessWidget {
  final String name;
  final String? iconKey;
  final String colorKey;
  final int completedThisWeek;
  final int timesPerWeek;
  final Set<String> completedDates;
  final List<String> weekDates;

  const HabitCard({
    super.key,
    required this.name,
    this.iconKey,
    required this.colorKey,
    required this.completedThisWeek,
    required this.timesPerWeek,
    required this.completedDates,
    required this.weekDates,
  });

  @override
  Widget build(BuildContext context) {
    final color = getHabitColor(colorKey);
    final isDone = completedThisWeek >= timesPerWeek;

    return Opacity(
      opacity: isDone ? 0.55 : 1.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: cardDecoration,
        child: Row(
          children: [
            // Icon badge — shows checkmark overlay when done
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isDone
                        ? mint.withValues(alpha: 0.2)
                        : color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    getGoalIconData(iconKey),
                    size: 20,
                    color: isDone ? mint : color,
                  ),
                ),
                if (isDone)
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: mint.withValues(alpha: 0.85),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded,
                        size: 20, color: Colors.white),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Name
            Expanded(
              child: Text(
                name,
                style: bodyLarge.copyWith(
                  color: isDone ? textMuted : textMain,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                  decorationColor: textMuted,
                ),
              ),
            ),
            // Week bars
            WeekBars(
              colorKey: colorKey,
              completedDates: completedDates,
              weekDates: weekDates,
            ),
            const SizedBox(width: 12),
            // Progress indicator
            Text(
              '$completedThisWeek/$timesPerWeek',
              style: bodySmall.copyWith(color: textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
