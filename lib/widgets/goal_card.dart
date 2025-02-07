import 'package:flutter/material.dart';
import 'package:goal_getters/models/goal.dart';

class GoalCard extends StatefulWidget {
  final Goal goal;
  final Goal? relatedGoal;
  final Function(Goal) onEdit;
  final Function(Goal) onDelete;
  final Function(Goal, String) onUpdateStatus;
  final Map<String, Color> statusColors;

  const GoalCard({
    super.key,
    required this.goal,
    this.relatedGoal,
    required this.onEdit,
    required this.onDelete,
    required this.onUpdateStatus,
    required this.statusColors,
  });

  @override
  _GoalCardState createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Goal Title & Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Goal Name
                  Expanded(
                    child: Text(
                      widget.goal.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Status Dropdown Button
                  PopupMenuButton<String>(
                    initialValue: widget.goal.status,
                    onSelected: (String status) =>
                        widget.onUpdateStatus(widget.goal, status),
                    itemBuilder: (BuildContext context) => [
                      'Todo 📝',
                      'In Progress ⌛',
                      'Done ✅',
                      'Blocked ⛔',
                    ].map((String status) {
                      return PopupMenuItem<String>(
                        value: status,
                        child: Row(
                          children: [
                            Icon(Icons.circle, color: widget.statusColors[status], size: 12),
                            const SizedBox(width: 8),
                            Text(status),
                          ],
                        ),
                      );
                    }).toList(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: widget.statusColors[widget.goal.status]!.withOpacity(0.1),
                        border: Border.all(color: widget.statusColors[widget.goal.status]!, width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.circle, color: widget.statusColors[widget.goal.status], size: 12),
                          const SizedBox(width: 6),
                          Text(
                            widget.goal.status,
                            style: TextStyle(
                              color: widget.statusColors[widget.goal.status],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Difficulty & Importance
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    label: Text('Difficulty: ${widget.goal.difficulty}'),
                    avatar: const Icon(Icons.bar_chart, size: 18),
                  ),
                  Chip(
                    label: Text('Importance: ${widget.goal.importance}'),
                    avatar: const Icon(Icons.priority_high, size: 18),
                  ),
                ],
              ),

              if (_isExpanded) ...[
                const SizedBox(height: 12),
                const Divider(),

                // Related Goal
                if (widget.relatedGoal != null)
                  Chip(
                    label: Text('Related to: ${widget.relatedGoal!.name}'),
                    avatar: const Icon(Icons.link, size: 18),
                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                  ),

                // Notes Section
                if (widget.goal.notes.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Notes:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.goal.notes,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],

                const SizedBox(height: 12),
                if(widget.goal.relatedYearlyGoalId != null || widget.goal.notes.isNotEmpty)
                  const Divider(),

                // Edit & Delete Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => widget.onEdit(widget.goal),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text("Edit"),
                    ),
                    TextButton.icon(
                      onPressed: () => widget.onDelete(widget.goal),
                      icon: const Icon(Icons.delete, size: 18),
                      label: const Text("Delete"),
                      style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
