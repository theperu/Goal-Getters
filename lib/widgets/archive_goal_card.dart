import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import '../models/goal.dart';
import '../utils/styles.dart';

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
      decoration: ShapeDecoration(
        color: bgSecondary,
        shadows: [lightShadow],
        shape: MoonSquircleBorder(
          borderRadius: BorderRadius.circular(radiusMedium).squircleBorderRadius(context),
        ),
      ),
      child: InkWell(
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
                          decoration: ShapeDecoration(
                            color: goal.status == 'Rescheduled 🔄'
                                ? statusRescheduled
                                : statusArchived,
                            shape: MoonSquircleBorder(
                              borderRadius: BorderRadius.circular(radiusSmall).squircleBorderRadius(context),
                            ),
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
                              decorationColor: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  MoonButton.icon(
                    buttonSize: MoonButtonSize.sm,
                    backgroundColor: primaryCyan.withValues(alpha: 0.1),
                    icon: const Icon(
                      MoonIcons.time_calendar_24_light,
                      size: iconSizeMedium,
                      color: primaryCyan,
                    ),
                    onTap: onReschedule,
                  ),
                ],
              ),
              if (isExpanded) ...[
                const Divider(color: textPrimary),
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
