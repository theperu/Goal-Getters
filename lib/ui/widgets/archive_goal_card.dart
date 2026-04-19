import 'package:flutter/material.dart';
import '../../model/goal.dart';
import '../../constants/style.dart';

/// An expandable card for archived/rescheduled goals
/// Used in archive.dart
class ArchiveGoalCard extends StatelessWidget {
  final Goal goal;
  final bool isExpanded;
  final VoidCallback onTap;
  final VoidCallback onReschedule;

  const ArchiveGoalCard({
    super.key,
    required this.goal,
    required this.isExpanded,
    required this.onTap,
    required this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: spacingXS),
      decoration: BoxDecoration(
        color: surface,
        boxShadow: [shadowSm],
        borderRadius: BorderRadius.circular(radiusMedium),
        border: Border.all(color: borderSoft, width: 2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(radiusMedium),
        onTap: onTap,
        child: Padding(
          padding: paddingAllM,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        // Status indicator
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: spacingS, vertical: spacingXS),
                          decoration: BoxDecoration(
                            color: goal.status == 'Rescheduled 🔄'
                                ? statusRescheduled
                                : statusArchived,
                            borderRadius: BorderRadius.circular(radiusRound),
                          ),
                          child: Text(
                            goal.status == 'Rescheduled 🔄' ? '🔄' : '🗃️',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: spacingS),
                        Expanded(
                          child: Text(
                            goal.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              color: textPrimary,
                              decoration: goal.status == 'Rescheduled 🔄'
                                  ? TextDecoration.lineThrough
                                  : null,
                              decorationColor: textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: primaryCyan.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(radiusMedium),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(radiusMedium),
                      onTap: onReschedule,
                      child: const Padding(
                        padding: EdgeInsets.all(spacingS),
                        child: Icon(
                          Icons.calendar_month,
                          size: iconSizeMedium,
                          color: primaryCyan,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (isExpanded) ...[
                const Divider(color: borderSoft),
                const SizedBox(height: spacingS),
                Text('Difficulty: ${goal.difficulty}',
                    style: const TextStyle(color: textPrimary)),
                const SizedBox(height: spacingXS),
                Text('Importance: ${goal.importance}',
                    style: const TextStyle(color: textPrimary)),
                const SizedBox(height: spacingS),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
