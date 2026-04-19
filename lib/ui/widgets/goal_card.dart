import 'package:flutter/material.dart';
import '../../model/goal.dart';
import '../../constants/style.dart';
import 'goal_details_bottom_sheet.dart';
import 'status_dropdown.dart';
import 'difficulty_stars.dart';
import 'priority_chip.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;
  final Goal? relatedGoal;
  final Function(Goal) onEdit;
  final Function(Goal) onDelete;
  final Function(Goal, String) onUpdateStatus;
  final Function(Goal, String)? onUpdateNotes;
  final Map<String, Color> statusColors;

  const GoalCard({
    super.key,
    required this.goal,
    this.relatedGoal,
    required this.onEdit,
    required this.onDelete,
    required this.onUpdateStatus,
    this.onUpdateNotes,
    required this.statusColors,
  });

  void _showGoalDetailsBottomSheet(BuildContext context) {
    GoalDetailsBottomSheet.show(
      context,
      goal: goal,
      relatedGoal: relatedGoal,
      onEdit: onEdit,
      onDelete: onDelete,
      onUpdateStatus: onUpdateStatus,
      onUpdateNotes: onUpdateNotes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: spacingS, vertical: spacingXS),
      child: Card(
        color: statusColors[goal.status] ?? statusBgTodo,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
          side: const BorderSide(color: borderSoft, width: 2),
        ),
        child: InkWell(
          onTap: () => _showGoalDetailsBottomSheet(context),
          borderRadius: BorderRadius.circular(radiusLarge),
          child: Padding(
            padding: paddingAllM,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: spacingM),
                        child: Text(
                          goal.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                        ),
                      ),
                    ),
                    StatusDropdown(
                      currentStatus: goal.status,
                      onStatusChanged: (status) => onUpdateStatus(goal, status),
                    ),
                  ],
                ),
                const SizedBox(height: spacingS),
                Wrap(
                  spacing: spacingS,
                  runSpacing: spacingS,
                  children: [
                    DifficultyChip(difficulty: goal.difficulty),
                    PriorityChip(importance: goal.importance),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

