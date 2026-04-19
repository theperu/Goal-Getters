import 'package:flutter/material.dart';
import '../../../constants/style.dart';
import '../../../constants/goal_icons.dart';
import '../../../model/yearly_goal.dart';
import '../../../model/weekly_goal.dart';
import '../../../ui/widgets/difficulty_stars.dart';
import '../../../ui/widgets/priority_chip.dart';
import '../../../ui/widgets/status_dropdown.dart';

class YearlyGoalDetailSheet extends StatelessWidget {
  final YearlyGoal goal;
  final List<WeeklyGoal> relatedGoals;
  final void Function(YearlyGoal) onEdit;
  final void Function(YearlyGoal) onDelete;
  final void Function(YearlyGoal, String) onUpdateStatus;

  const YearlyGoalDetailSheet({
    super.key,
    required this.goal,
    required this.relatedGoals,
    required this.onEdit,
    required this.onDelete,
    required this.onUpdateStatus,
  });

  static void show(
    BuildContext context, {
    required YearlyGoal goal,
    required List<WeeklyGoal> relatedGoals,
    required void Function(YearlyGoal) onEdit,
    required void Function(YearlyGoal) onDelete,
    required void Function(YearlyGoal, String) onUpdateStatus,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (_) => YearlyGoalDetailSheet(
        goal: goal,
        relatedGoals: relatedGoals,
        onEdit: onEdit,
        onDelete: onDelete,
        onUpdateStatus: onUpdateStatus,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final iconData = getGoalIconData(goal.icon);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXL)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            height: 4,
            width: 40,
            margin: const EdgeInsets.symmetric(vertical: spacingS),
            decoration: BoxDecoration(
              color: borderSoft,
              borderRadius: BorderRadius.circular(radiusLarge),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: paddingAllXL,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon + Title row
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: primaryLavender.withValues(alpha: 0.12),
                          borderRadius:
                              BorderRadius.circular(radiusSmall),
                        ),
                        child: Icon(iconData,
                            color: primaryLavender, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          goal.name,
                          style: headingMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: spacingXL),

                  // Status
                  _DetailRow(
                    label: 'Status',
                    child: StatusDropdown(
                      currentStatus: goal.status,
                      onStatusChanged: (s) {
                        onUpdateStatus(goal, s);
                        Navigator.pop(context);
                      },
                      fontSize: 13,
                      padding: const EdgeInsets.symmetric(
                          horizontal: spacingM, vertical: 6),
                    ),
                  ),
                  const SizedBox(height: spacingL),

                  // Difficulty + Priority
                  Wrap(
                    spacing: spacingM,
                    runSpacing: spacingM,
                    children: [
                      DifficultyChip(
                        difficulty: goal.difficulty,
                        starSize: iconSizeSmall,
                      ),
                      PriorityChip(
                        importance: goal.importance,
                        iconSize: iconSizeSmall,
                        fontSize: 13,
                      ),
                    ],
                  ),
                  const SizedBox(height: spacingXL),

                  // Year
                  _DetailRow(
                    label: 'Year',
                    child: Text('${goal.year}', style: bodyLarge),
                  ),
                  const SizedBox(height: spacingL),

                  // Notes
                  if (goal.notes.isNotEmpty) ...[
                    Text('Notes', style: labelMedium.copyWith(color: textSecondary)),
                    const SizedBox(height: spacingS),
                    Container(
                      width: double.infinity,
                      padding: paddingAllM,
                      decoration: BoxDecoration(
                        color: bgPrimary,
                        borderRadius:
                            BorderRadius.circular(radiusSmall),
                        border:
                            Border.all(color: borderSoft, width: 1),
                      ),
                      child: Text(goal.notes, style: bodyMedium),
                    ),
                    const SizedBox(height: spacingXL),
                  ],

                  // Related weekly goals
                  Text('Related Weekly Goals',
                      style: labelMedium.copyWith(
                          color: textSecondary)),
                  const SizedBox(height: spacingS),
                  if (relatedGoals.isEmpty)
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'No weekly goals linked yet.',
                        style: caption.copyWith(
                            color: textMuted),
                      ),
                    )
                  else
                    Column(
                      children: relatedGoals
                          .map((w) => _RelatedWeeklyGoalTile(
                              goal: w))
                          .toList(),
                    ),

                  const SizedBox(height: spacingXXL),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            onEdit(goal);
                          },
                          icon: const Icon(Icons.edit_outlined,
                              size: 18),
                          label: const Text('Edit'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primaryLavender,
                            side: const BorderSide(
                                color: primaryLavender, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  radiusMedium),
                            ),
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _confirmDelete(context),
                          icon: const Icon(Icons.delete_outline,
                              size: 18),
                          label: const Text('Delete'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: errorColor,
                            side: const BorderSide(
                                color: errorColor, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  radiusMedium),
                            ),
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Goal'),
        content: Text('Delete "${goal.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);   // close dialog
              Navigator.pop(context); // close sheet
              onDelete(goal);
            },
            child: const Text('Delete',
                style: TextStyle(color: errorColor)),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final Widget child;

  const _DetailRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label,
              style: labelMedium.copyWith(color: textSecondary)),
        ),
        child,
      ],
    );
  }
}

class _RelatedWeeklyGoalTile extends StatelessWidget {
  final WeeklyGoal goal;

  const _RelatedWeeklyGoalTile({required this.goal});

  @override
  Widget build(BuildContext context) {
    final isDone = goal.status == 'Done';
    final statusColor = statusColorMap[goal.status] ?? statusTodo;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgPrimary,
        borderRadius: BorderRadius.circular(radiusSmall),
        border: Border.all(color: borderSoft, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isDone ? statusDone : statusTodo,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              goal.name,
              style: bodyMedium.copyWith(
                decoration: isDone ? TextDecoration.lineThrough : null,
                color: isDone ? textMuted : textMain,
              ),
            ),
          ),
          Text(
            'W${goal.week}',
            style: caption.copyWith(color: textMuted),
          ),
          const SizedBox(width: 8),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}
