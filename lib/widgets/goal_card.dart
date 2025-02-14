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
    // Define status colors
    final Map<String, Color> statusColors = {
      'Todo 📝': const Color(0xFF4B5563),
      'In Progress ⌛': const Color(0xFF3B82F6),
      'Done ✅': const Color(0xFF10B981),
      'Blocked ⛔': const Color(0xFFEF4444),
    };

    return Card(
      color: widget.statusColors[widget.goal.status], // Background color is status color
      margin: const EdgeInsets.all(4),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
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
                        color: const Color(0xFFF3F4F6),
                      ),
                    ),
                  ),

                  // Status Dropdown Button
                  PopupMenuButton<String>(
                    initialValue: widget.goal.status,
                    onSelected: (String status) => widget.onUpdateStatus(widget.goal, status),
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
                            Icon(Icons.circle, color: statusColors[status], size: 12), // Circle in status color (menu only)
                            const SizedBox(width: 8),
                            Text(status, style: const TextStyle(color: Colors.white)), // White text
                          ],
                        ),
                      );
                    }).toList(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColors[widget.goal.status], // Background color based on status
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 6), // Keep spacing for alignment
                          Text(
                            widget.goal.status,
                            style: const TextStyle(
                              color: Colors.white, // White text
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
                    style: const TextStyle(fontWeight: FontWeight.w400, color: Color(0xFFF3F4F6)),
                  ),
                  const SizedBox(width: 12),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontWeight: FontWeight.w400, 
                        color: Color(0xFFF3F4F6), // White for "Importance:"
                      ),
                      children: [
                        const TextSpan(text: 'Importance: '), // "Importance:" stays white
                        TextSpan(
                          text: widget.goal.importance,
                          style: TextStyle(
                            color: widget.goal.importance == 'Low 🌱'
                                ? Color(0xFF44CA77)
                                : widget.goal.importance == 'Medium 🌿'
                                    ? Color(0xFFFB923C)
                                    : Color(0xFFF87171), // Colored based on importance
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (_isExpanded) ...[
                const SizedBox(height: 12),
                const Divider(color: const Color(0xFFF3F4F6)),

                // Related Goal
                if (widget.relatedGoal != null)
                  Chip(
                    label: Text(
                      'Related to: ${widget.relatedGoal!.name}',
                      style: const TextStyle(color: const Color(0xFFF3F4F6)), // Ensure text is black
                    ),
                    avatar: const Icon(Icons.link, size: 18, color: const Color(0xFFF3F4F6)), // Black icon
                    backgroundColor: const Color.fromARGB(31, 80, 80, 80), // Light grey background
                  ),
                  
                // Notes Section
                if (widget.goal.notes.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Notes:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFF3F4F6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.goal.notes,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFFF3F4F6)),
                  ),
                ],

                const SizedBox(height: 12),
                if (widget.goal.relatedYearlyGoalId != null || widget.goal.notes.isNotEmpty)
                  const Divider(color: const Color(0xFFF3F4F6)),

                // Edit & Delete Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => widget.onEdit(widget.goal),
                      icon: const Icon(Icons.edit, size: 18, color: const Color(0xFFF3F4F6)),
                      label: const Text("Edit", style: TextStyle(color: const Color(0xFFF3F4F6))),
                    ),
                    TextButton.icon(
                      onPressed: () => widget.onDelete(widget.goal),
                      icon: const Icon(Icons.delete, size: 18, color: const Color(0xFFF3F4F6)),
                      label: const Text("Delete", style: TextStyle(color: const Color(0xFFF3F4F6))),
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
