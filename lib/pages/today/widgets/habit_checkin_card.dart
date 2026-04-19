import 'package:flutter/material.dart';
import '../../../constants/goal_icons.dart';
import '../../../constants/habit_colors.dart';
import '../../../constants/style.dart';

class HabitCheckinCard extends StatelessWidget {
  final String name;
  final String? iconKey;
  final String colorKey;
  final bool isCompleted;
  final VoidCallback onTap;

  const HabitCheckinCard({
    super.key,
    required this.name,
    this.iconKey,
    required this.colorKey,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final habitColor = getHabitColor(colorKey);
    final iconData = getGoalIconData(iconKey);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Card body
            Container(
              width: 100,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: isCompleted
                    ? habitColor.withValues(alpha: 0.15)
                    : borderSoft.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(radiusLarge),
                border: Border.all(
                  color: isCompleted
                      ? habitColor.withValues(alpha: 0.3)
                      : borderSoft,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon circle
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? habitColor.withValues(alpha: 0.25)
                          : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      iconData,
                      size: 22,
                      color: isCompleted ? habitColor : textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Habit name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      name,
                      style: labelSmall.copyWith(
                        color: isCompleted ? habitColor : textSecondary,
                        fontWeight:
                            isCompleted ? FontWeight.w600 : FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
