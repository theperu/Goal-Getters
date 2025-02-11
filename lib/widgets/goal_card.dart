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
      color: widget.statusColors[widget.goal.status], // Background color is status color
      margin: const EdgeInsets.all(2),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: Padding(
          padding: const EdgeInsets.all(20),
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
                        color: Colors.black, // Black text
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
                            Text(status, style: const TextStyle(color: Colors.black)), // Black text
                          ],
                        ),
                      );
                    }).toList(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white, // White background for contrast
                        border: Border.all(color: widget.statusColors[widget.goal.status]!, width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.circle, color: widget.statusColors[widget.goal.status], size: 12),
                          const SizedBox(width: 6),
                          Text(
                            widget.goal.status,
                            style: const TextStyle(
                              color: Colors.black, // Black text
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

              // Difficulty & Importance (Now in a Row & Thin)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Difficulty: ${widget.goal.difficulty}',
                    style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Importance: ${widget.goal.importance}',
                    style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                ],
              ),

              if (_isExpanded) ...[
                const SizedBox(height: 12),
                const Divider(color: Colors.black),

                // Related Goal
                if (widget.relatedGoal != null)
                  Chip(
                    label: Text(
                      'Related to: ${widget.relatedGoal!.name}',
                      style: const TextStyle(color: Colors.black), // Ensure text is black
                    ),
                    avatar: const Icon(Icons.link, size: 18, color: Colors.black), // Black icon
                    backgroundColor: const Color(0xFFE0E0E0), // Light grey background
                  ),
                  
                // Notes Section
                if (widget.goal.notes.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Notes:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.goal.notes,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                  ),
                ],

                const SizedBox(height: 12),
                if (widget.goal.relatedYearlyGoalId != null || widget.goal.notes.isNotEmpty)
                  const Divider(color: Colors.black),

                // Edit & Delete Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => widget.onEdit(widget.goal),
                      icon: const Icon(Icons.edit, size: 18, color: Colors.black),
                      label: const Text("Edit", style: TextStyle(color: Colors.black)),
                    ),
                    TextButton.icon(
                      onPressed: () => widget.onDelete(widget.goal),
                      icon: const Icon(Icons.delete, size: 18, color: Colors.black),
                      label: const Text("Delete", style: TextStyle(color: Colors.black)),
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
