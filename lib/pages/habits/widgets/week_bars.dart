import 'package:flutter/material.dart';
import '../../../constants/habit_colors.dart';

/// Build the 7 vertical bars showing daily completion for a habit.
class WeekBars extends StatelessWidget {
  final String colorKey;
  final Set<String> completedDates;
  final List<String> weekDates;

  const WeekBars({
    super.key,
    required this.colorKey,
    required this.completedDates,
    required this.weekDates,
  });

  @override
  Widget build(BuildContext context) {
    final color = getHabitColor(colorKey);
    final fadedColor = color.withValues(alpha: 0.25);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(7, (i) {
        final isCompleted = completedDates.contains(weekDates[i]);
        return Container(
          width: 4,
          height: 22,
          margin: EdgeInsets.only(right: i < 6 ? 3 : 0),
          decoration: BoxDecoration(
            color: isCompleted ? color : fadedColor,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
