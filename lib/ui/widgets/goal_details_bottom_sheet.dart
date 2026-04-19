import 'dart:async';
import 'package:flutter/material.dart';
import '../../model/goal.dart';
import '../../constants/style.dart';
import 'status_dropdown.dart';
import 'difficulty_stars.dart';
import 'priority_chip.dart';

/// A bottom sheet displaying full goal details
/// Extracted from goal_card.dart
class GoalDetailsBottomSheet extends StatefulWidget {
  final Goal goal;
  final Goal? relatedGoal;
  final Function(Goal) onEdit;
  final Function(Goal) onDelete;
  final Function(Goal, String) onUpdateStatus;
  final Function(Goal, String)? onUpdateNotes;

  const GoalDetailsBottomSheet({
    super.key,
    required this.goal,
    this.relatedGoal,
    required this.onEdit,
    required this.onDelete,
    required this.onUpdateStatus,
    this.onUpdateNotes,
  });

  /// Shows the bottom sheet
  static void show(
    BuildContext context, {
    required Goal goal,
    Goal? relatedGoal,
    required Function(Goal) onEdit,
    required Function(Goal) onDelete,
    required Function(Goal, String) onUpdateStatus,
    Function(Goal, String)? onUpdateNotes,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext context) => GoalDetailsBottomSheet(
        goal: goal,
        relatedGoal: relatedGoal,
        onEdit: onEdit,
        onDelete: onDelete,
        onUpdateStatus: onUpdateStatus,
        onUpdateNotes: onUpdateNotes,
      ),
    );
  }

  @override
  State<GoalDetailsBottomSheet> createState() => _GoalDetailsBottomSheetState();
}

class _GoalDetailsBottomSheetState extends State<GoalDetailsBottomSheet> {
  late String currentStatus;
  late TextEditingController _notesController;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.goal.status;
    _notesController = TextEditingController(text: widget.goal.notes);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  void _onNotesChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (widget.onUpdateNotes != null) {
        widget.onUpdateNotes!(widget.goal, value);
      }
    });
  }

  void _onStatusChanged(String newStatus) {
    setState(() {
      currentStatus = newStatus;
    });
    widget.onUpdateStatus(widget.goal, newStatus);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7 + bottomInset,
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
                  // Title and Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: spacingM),
                          child: Text(
                            widget.goal.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary,
                                ),
                          ),
                        ),
                      ),
                      StatusDropdown(
                        currentStatus: currentStatus,
                        onStatusChanged: _onStatusChanged,
                        fontSize: 13,
                        padding: const EdgeInsets.symmetric(horizontal: spacingM, vertical: 6),
                      ),
                    ],
                  ),
                  const SizedBox(height: spacingXL),

                  // Difficulty and Priority
                  Wrap(
                    spacing: spacingM,
                    runSpacing: spacingM,
                    children: [
                      DifficultyChip(
                        difficulty: widget.goal.difficulty,
                        starSize: iconSizeSmall,
                      ),
                      PriorityChip(
                        importance: widget.goal.importance,
                        iconSize: iconSizeSmall,
                        fontSize: 13,
                      ),
                    ],
                  ),
                  const SizedBox(height: spacingXL),

                  // Related Goal
                  if (widget.relatedGoal != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: spacingXL),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: spacingM, vertical: spacingS),
                        decoration: BoxDecoration(
                          color: primaryCyan.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(radiusMedium),
                          border: Border.all(
                            color: primaryCyan.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.link, size: iconSizeSmall, color: primaryCyan),
                            const SizedBox(width: spacingS),
                            Expanded(
                              child: Text(
                                'Related to: ${widget.relatedGoal!.name}',
                                style: const TextStyle(
                                  color: primaryCyan,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Notes Section
                  Text(
                    'Notes:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: textPrimary,
                        ),
                  ),
                  const SizedBox(height: spacingM),
                  SizedBox(
                    height: 250,
                    child: TextField(
                      controller: _notesController,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: textSecondary,
                            fontSize: 14,
                          ),
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      onChanged: _onNotesChanged,
                      decoration: InputDecoration(
                        hintText: 'Add notes...',
                        hintStyle: const TextStyle(color: textMuted),
                        filled: true,
                        fillColor: borderSoft,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(radiusMedium),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(spacingM),
                      ),
                    ),
                  ),
                  const SizedBox(height: spacingXXL),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Material(
                        color: primaryCyan.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(radiusMedium),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(radiusMedium),
                          onTap: () {
                            Navigator.pop(context);
                            widget.onEdit(widget.goal);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(spacingS),
                            child: Icon(Icons.edit, size: iconSizeMedium, color: primaryCyan),
                          ),
                        ),
                      ),
                      const SizedBox(width: spacingM),
                      DeleteButtonWithConfirmation(
                        onDelete: () {
                          Navigator.pop(context);
                          widget.onDelete(widget.goal);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A delete button with confirmation modal
class DeleteButtonWithConfirmation extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteButtonWithConfirmation({
    super.key,
    required this.onDelete,
  });

  Future<void> _showDeleteModal(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: bgSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            padding: paddingAllXXL,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: errorColor,
                      size: iconSizeLarge,
                    ),
                    SizedBox(width: spacingM),
                    Text(
                      'Delete Goal?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: spacingL),
                const Text(
                  'This action cannot be undone. The goal will be permanently deleted.',
                  style: TextStyle(
                    fontSize: 14,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: spacingXXL),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: bgInput,
                        padding: const EdgeInsets.symmetric(horizontal: spacingL, vertical: spacingS),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(radiusMedium),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel', style: TextStyle(color: textPrimary)),
                    ),
                    const SizedBox(width: spacingM),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: errorColor,
                        padding: const EdgeInsets.symmetric(horizontal: spacingL, vertical: spacingS),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(radiusMedium),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        onDelete();
                      },
                      child: const Text('Delete', style: TextStyle(color: surface, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: errorColor.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(radiusMedium),
      child: InkWell(
        borderRadius: BorderRadius.circular(radiusMedium),
        onTap: () => _showDeleteModal(context),
        child: const Padding(
          padding: EdgeInsets.all(spacingS),
          child: Icon(Icons.delete, size: iconSizeMedium, color: errorColor),
        ),
      ),
    );
  }
}
