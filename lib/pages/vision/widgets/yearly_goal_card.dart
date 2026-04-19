import 'package:flutter/material.dart';
import '../../../constants/style.dart';
import '../../../constants/goal_icons.dart';
import '../../../model/yearly_goal.dart';

class YearlyGoalCard extends StatelessWidget {
  final YearlyGoal goal;
  final VoidCallback onTap;

  const YearlyGoalCard({
    super.key,
    required this.goal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconData = getGoalIconData(goal.icon);
    final statusColor = statusColorMap[goal.status] ?? statusTodo;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(radiusLarge),
          border: Border.all(color: borderSoft, width: 2),
          boxShadow: [shadowSm],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: primaryLavender.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(radiusSmall),
              ),
              child: Icon(iconData, color: primaryLavender, size: 22),
            ),
            const SizedBox(width: 14),

            // Name + Focus Area
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.name,
                    style: bodyLarge.copyWith(fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Focus Area: ${goal.importance}',
                    style: caption.copyWith(color: textSecondary),
                  ),
                ],
              ),
            ),

            // Status chip
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (statusBgColorMap[goal.status] ?? statusBgTodo),
                borderRadius: BorderRadius.circular(radiusRound),
              ),
              child: Text(
                goal.status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
