import 'package:flutter/material.dart';
import '../../../constants/style.dart';
import '../../../model/weekly_goal.dart';
import '../../../model/yearly_goal.dart';
import '../../../services/calendar_service.dart';
import '../../../ui/widgets/difficulty_stars.dart';
import '../../../ui/widgets/priority_chip.dart';
import '../../../ui/widgets/status_dropdown.dart';

class WeeklyGoalDetailSheet extends StatefulWidget {
  final WeeklyGoal goal;
  final YearlyGoal? relatedYearlyGoal;
  final void Function(WeeklyGoal) onEdit;
  final void Function(WeeklyGoal) onDelete;
  final void Function(WeeklyGoal, String) onUpdateStatus;
  final void Function(WeeklyGoal)? onGoalUpdated;

  const WeeklyGoalDetailSheet({
    super.key,
    required this.goal,
    this.relatedYearlyGoal,
    required this.onEdit,
    required this.onDelete,
    required this.onUpdateStatus,
    this.onGoalUpdated,
  });

  static void show(
    BuildContext context, {
    required WeeklyGoal goal,
    YearlyGoal? relatedYearlyGoal,
    required void Function(WeeklyGoal) onEdit,
    required void Function(WeeklyGoal) onDelete,
    required void Function(WeeklyGoal, String) onUpdateStatus,
    void Function(WeeklyGoal)? onGoalUpdated,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (_) => WeeklyGoalDetailSheet(
        goal: goal,
        relatedYearlyGoal: relatedYearlyGoal,
        onEdit: onEdit,
        onDelete: onDelete,
        onUpdateStatus: onUpdateStatus,
        onGoalUpdated: onGoalUpdated,
      ),
    );
  }

  @override
  State<WeeklyGoalDetailSheet> createState() => _WeeklyGoalDetailSheetState();
}

class _WeeklyGoalDetailSheetState extends State<WeeklyGoalDetailSheet> {
  late WeeklyGoal _goal;

  static const _dayNames = [
    '',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    _goal = widget.goal;
  }

  Future<void> _addToCalendar() async {
    await CalendarService().openCalendarWithEvent(_goal);
    final updated = _goal.copy(
      calendarEventId: 'added',
    );
    setState(() => _goal = updated);
    widget.onGoalUpdated?.call(updated);
  }

  Future<void> _openInCalendar() async {
    await CalendarService().openCalendarWithEvent(_goal);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
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
                  // Title
                  Text(_goal.name, style: headingMedium),
                  const SizedBox(height: spacingXL),

                  // Status
                  _DetailRow(
                    label: 'Status',
                    child: StatusDropdown(
                      currentStatus: _goal.status,
                      onStatusChanged: (s) {
                        widget.onUpdateStatus(_goal, s);
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
                        difficulty: _goal.difficulty,
                        starSize: iconSizeSmall,
                      ),
                      PriorityChip(
                        importance: _goal.importance,
                        iconSize: iconSizeSmall,
                        fontSize: 13,
                      ),
                    ],
                  ),
                  const SizedBox(height: spacingXL),

                  // Week & Year
                  _DetailRow(
                    label: 'Week',
                    child: Text('W${_goal.week}, ${_goal.year}',
                        style: bodyLarge),
                  ),
                  const SizedBox(height: spacingL),

                  // Day of week
                  if (_goal.dayOfWeek != null) ...[
                    _DetailRow(
                      label: 'Day',
                      child: Text(_dayNames[_goal.dayOfWeek!],
                          style: bodyLarge),
                    ),
                    const SizedBox(height: spacingL),
                  ],

                  // Timebox
                  if (_goal.timeboxStart != null &&
                      _goal.timeboxStart!.isNotEmpty) ...[
                    _DetailRow(
                      label: 'Time',
                      child: Text(
                        _goal.timeboxMinutes != null
                            ? '${_goal.timeboxStart} (${_goal.timeboxMinutes} min)'
                            : _goal.timeboxStart!,
                        style: bodyLarge,
                      ),
                    ),
                    const SizedBox(height: spacingL),
                  ],

                  // Calendar event
                  if (_goal.calendarEventId != null) ...[
                    GestureDetector(
                      onTap: _openInCalendar,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: spacingM, vertical: spacingM),
                        decoration: BoxDecoration(
                          color: primaryLavender.withValues(alpha: 0.08),
                          borderRadius:
                              BorderRadius.circular(radiusSmall),
                          border: Border.all(
                              color:
                                  primaryLavender.withValues(alpha: 0.3),
                              width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.event,
                                size: 18,
                                color: primaryLavender),
                            const SizedBox(width: spacingS),
                            const Expanded(
                              child: Text(
                                'Added to Calendar',
                                style: TextStyle(
                                    color: primaryLavender,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Icon(Icons.open_in_new,
                                size: 16,
                                color: primaryLavender),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: spacingL),
                  ] else if (_goal.dayOfWeek != null) ...[
                    // Show "Add to Calendar" button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _addToCalendar,
                        icon: const Icon(Icons.calendar_today,
                                size: 16),
                        label: const Text('Add to Calendar'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryLavender,
                          side: const BorderSide(
                              color: primaryLavender, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(radiusMedium),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: spacingL),
                  ],

                  // Related yearly goal
                  if (widget.relatedYearlyGoal != null) ...[
                    _DetailRow(
                      label: 'Yearly',
                      child: Expanded(
                        child: Text(widget.relatedYearlyGoal!.name,
                            style: bodyLarge),
                      ),
                    ),
                    const SizedBox(height: spacingL),
                  ],

                  // Notes
                  if (_goal.notes.isNotEmpty) ...[
                    Text('Notes',
                        style:
                            labelMedium.copyWith(color: textSecondary)),
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
                      child: Text(_goal.notes, style: bodyMedium),
                    ),
                    const SizedBox(height: spacingXL),
                  ],

                  const SizedBox(height: spacingXL),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            widget.onEdit(_goal);
                          },
                          icon:
                              const Icon(Icons.edit_outlined, size: 18),
                          label: const Text('Edit'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primaryLavender,
                            side: const BorderSide(
                                color: primaryLavender, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(radiusMedium),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14),
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
                              borderRadius:
                                  BorderRadius.circular(radiusMedium),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14),
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
        content: Text('Delete "${_goal.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // close dialog
              Navigator.pop(context); // close sheet
              widget.onDelete(_goal);
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
