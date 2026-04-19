import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../constants/style.dart';
import '../../model/weekly_goal.dart';
import '../../model/yearly_goal.dart';
import '../../services/calendar_service.dart';

class GoalForm extends StatefulWidget {
  final WeeklyGoal? weeklyGoal;
  final YearlyGoal? yearlyGoal;
  final List<YearlyGoal> yearlyGoals;
  final String? initialType;

  const GoalForm({
    super.key,
    this.weeklyGoal,
    this.yearlyGoal,
    required this.yearlyGoals,
    this.initialType,
  });

  @override
  State<GoalForm> createState() => _GoalFormState();
}

class _GoalFormState extends State<GoalForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _notesController;
  late String _name;
  late String _difficulty;
  late String _importance;
  late String _status;
  late String _notes;
  late String _type;
  int? _relatedYearlyGoalId;
  int? _week;
  int? _year;
  TimeOfDay? _timeboxStart;
  int? _timeboxMinutes;
  int? _dayOfWeek;
  bool _addToCalendar = false;

  bool _showNameError = false;

  final List<String> _difficulties = ['1', '2', '3', '4', '5'];
  final List<String> _importanceLevels = ['Low', 'Medium', 'High'];
  final List<String> _statusOptions = ['Todo', 'In Progress', 'Done', 'Blocked', 'Archived', 'Rescheduled'];
  final List<String> _types = ['Weekly', 'Yearly'];
  final List<int> _durationOptions = [15, 30, 45, 60, 90, 120];

  bool get _isEditing => widget.weeklyGoal != null || widget.yearlyGoal != null;

  @override
  void initState() {
    super.initState();
    final wg = widget.weeklyGoal;
    final yg = widget.yearlyGoal;

    _name = wg?.name ?? yg?.name ?? '';
    _difficulty = wg?.difficulty ?? yg?.difficulty ?? '3';
    _importance = wg?.importance ?? yg?.importance ?? 'Medium';
    _status = wg?.status ?? yg?.status ?? 'Todo';
    _notes = wg?.notes ?? yg?.notes ?? '';
    _type = yg != null ? 'Yearly' : (widget.initialType ?? 'Weekly');
    _relatedYearlyGoalId = wg?.relatedYearlyGoalId;
    _week = wg?.week ?? _weekOfYear();
    _year = wg?.year ?? yg?.year ?? DateTime.now().year;

    if (wg?.timeboxStart != null) {
      final parts = wg!.timeboxStart!.split(':');
      if (parts.length == 2) {
        _timeboxStart = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    }
    _timeboxMinutes = wg?.timeboxMinutes;
    _dayOfWeek = wg?.dayOfWeek;
    _addToCalendar = wg?.calendarEventId != null;

    _nameController = TextEditingController(text: _name);
    _notesController = TextEditingController(text: _notes);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  int _weekOfYear() => getWeekOfYear(DateTime.now());

  Future<void> _submitForm() async {
    // Validate goal name
    if (_name.trim().isEmpty) {
      setState(() {
        _showNameError = true;
      });
      return;
    }

    // Clear error before submitting
    setState(() {
      _showNameError = false;
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final String? timeboxStartStr = _timeboxStart != null
          ? '${_timeboxStart!.hour.toString().padLeft(2, '0')}:${_timeboxStart!.minute.toString().padLeft(2, '0')}'
          : null;

      if (_type == 'Yearly') {
        final goal = YearlyGoal(
          id: widget.yearlyGoal?.id,
          name: _name,
          difficulty: _difficulty,
          importance: _importance,
          status: _status,
          notes: _notes,
          year: _year ?? DateTime.now().year,
        );
        Navigator.pop(context, goal);
      } else {
        final goal = WeeklyGoal(
          id: widget.weeklyGoal?.id,
          name: _name,
          difficulty: _difficulty,
          importance: _importance,
          status: _status,
          notes: _notes,
          relatedYearlyGoalId: _relatedYearlyGoalId,
          week: _week ?? _weekOfYear(),
          year: _year ?? DateTime.now().year,
          timeboxStart: timeboxStartStr,
          timeboxMinutes: _timeboxMinutes,
          dayOfWeek: _dayOfWeek,
          calendarEventId: _addToCalendar && _dayOfWeek != null
              ? (widget.weeklyGoal?.calendarEventId ?? 'pending')
              : null,
          calendarId: _addToCalendar && _dayOfWeek != null
              ? widget.weeklyGoal?.calendarId
              : null,
        );

        // Open calendar app with pre-filled event if toggled on
        if (_addToCalendar && _dayOfWeek != null) {
          await CalendarService().openCalendarWithEvent(goal);
        }

        if (mounted) Navigator.pop(context, goal);
      }
    }
  }

  static const _labelStyle = TextStyle(
    color: textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: borderSoft, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: borderSoft, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: primaryLavender, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: spacingL, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPrimary,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Goal' : 'Add Goal'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name field
              const Text('Goal Name', style: _labelStyle),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: textPrimary),
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) => _name = value,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: surface,
                  hintText: 'Enter goal name',
                  hintStyle: const TextStyle(color: textMuted),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radiusMedium),
                    borderSide: const BorderSide(color: borderSoft, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radiusMedium),
                    borderSide: const BorderSide(color: borderSoft, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radiusMedium),
                    borderSide: const BorderSide(color: primaryLavender, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: spacingL, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),

              // Type dropdown
              _buildDropdown<String>(
                label: 'Goal Type',
                value: _type,
                items: _types,
                onChanged: (value) {
                  setState(() {
                    _type = value!;
                    if (_type == 'Yearly') {
                      _relatedYearlyGoalId = null;
                      _week = null;
                    }
                  });
                },
              ),
              const SizedBox(height: 16),

              if (_type == 'Yearly') ...[
                _buildDropdown<int>(
                  label: 'Year',
                  value: _year ?? DateTime.now().year,
                  items: List.generate(6, (index) => DateTime.now().year - 2 + index),
                  onChanged: (value) => setState(() => _year = value),
                ),
                const SizedBox(height: 16),
              ],

              if (_type == 'Weekly') ...[
                _buildDropdown<int>(
                  label: 'Week',
                  value: _week ?? _weekOfYear(),
                  items: List.generate(53, (index) => index + 1),
                  onChanged: (value) => setState(() => _week = value),
                ),
                const SizedBox(height: 16),
                if (widget.yearlyGoals.isNotEmpty) ...[
                  const Text('Related Yearly Goal (Optional)', style: _labelStyle),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int?>(
                    value: _relatedYearlyGoalId,
                    dropdownColor: bgSecondary,
                    style: const TextStyle(color: textPrimary, fontSize: 14),
                    decoration: _dropdownDecoration(),
                    icon: const Icon(Icons.arrow_drop_down, color: textPrimary),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('None'),
                      ),
                      ...widget.yearlyGoals.map((goal) => DropdownMenuItem<int?>(
                        value: goal.id,
                        child: Text(goal.name),
                      )),
                    ],
                    onChanged: (value) => setState(() => _relatedYearlyGoalId = value),
                  ),
                  const SizedBox(height: 16),
                ],
                // Day of week picker
                const Text('Day (Optional)', style: _labelStyle),
                const SizedBox(height: 8),
                _DayOfWeekPicker(
                  selectedDay: _dayOfWeek,
                  onChanged: (day) => setState(() {
                    _dayOfWeek = day;
                    if (day == null) {
                      _timeboxStart = null;
                      _timeboxMinutes = null;
                      _addToCalendar = false;
                    }
                  }),
                ),
                const SizedBox(height: 16),
                if (_dayOfWeek != null) ...[                // Timebox section
                const Text('Timebox (Optional)', style: _labelStyle),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: _timeboxStart ?? TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setState(() => _timeboxStart = picked);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: spacingL, vertical: 14),
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(radiusMedium),
                            border: Border.all(color: borderSoft, width: 2),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _timeboxStart != null
                                      ? _timeboxStart!.format(context)
                                      : 'Start time',
                                  style: TextStyle(
                                    color: _timeboxStart != null ? textPrimary : textMuted,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              if (_timeboxStart != null)
                                GestureDetector(
                                  onTap: () => setState(() => _timeboxStart = null),
                                  child: const Icon(Icons.close, size: 18, color: textSecondary),
                                )
                              else
                                const Icon(Icons.access_time, size: 18, color: textSecondary),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        value: _timeboxMinutes,
                        dropdownColor: bgSecondary,
                        style: const TextStyle(color: textPrimary, fontSize: 14),
                        decoration: _dropdownDecoration().copyWith(
                          hintText: 'Duration',
                          hintStyle: const TextStyle(color: textMuted, fontSize: 14),
                        ),
                        icon: const Icon(Icons.arrow_drop_down, color: textPrimary),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text('No limit'),
                          ),
                          // Include the current value if it's not in the standard options
                          if (_timeboxMinutes != null && !_durationOptions.contains(_timeboxMinutes))
                            DropdownMenuItem<int?>(
                              value: _timeboxMinutes,
                              child: Text(_timeboxMinutes! >= 60 ? '${_timeboxMinutes! ~/ 60}h ${_timeboxMinutes! % 60 > 0 ? '${_timeboxMinutes! % 60}m' : ''}' : '${_timeboxMinutes}m'),
                            ),
                          ..._durationOptions.map((mins) => DropdownMenuItem<int?>(
                            value: mins,
                            child: Text(mins >= 60 ? '${mins ~/ 60}h ${mins % 60 > 0 ? '${mins % 60}m' : ''}' : '${mins}m'),
                          )),
                        ],
                        onChanged: (value) => setState(() => _timeboxMinutes = value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Add to Calendar toggle
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: spacingL, vertical: 4),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(radiusMedium),
                    border: Border.all(color: borderSoft, width: 2),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 18, color: textSecondary),
                      const SizedBox(width: spacingM),
                      const Expanded(
                        child: Text('Add to Calendar', style: TextStyle(color: textPrimary, fontSize: 14)),
                      ),
                      Switch(
                        value: _addToCalendar,
                        activeColor: primaryLavender,
                        onChanged: (value) => setState(() => _addToCalendar = value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ], // end if (_dayOfWeek != null)
              ],

              _buildDropdown<String>(
                label: 'Difficulty',
                value: _difficulty,
                items: _difficulties,
                onChanged: (value) => setState(() => _difficulty = value!),
              ),
              const SizedBox(height: 16),

              _buildDropdown<String>(
                label: 'Priority',
                value: _importance,
                items: _importanceLevels,
                onChanged: (value) => setState(() => _importance = value!),
              ),
              const SizedBox(height: 16),

              _buildDropdown<String>(
                label: 'Status',
                value: _status,
                items: _statusOptions,
                onChanged: (value) => setState(() => _status = value!),
              ),
              const SizedBox(height: 16),

              // Notes field
              const Text('Notes', style: _labelStyle),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: TextField(
                  controller: _notesController,
                  style: const TextStyle(color: textPrimary),
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  onChanged: (value) => _notes = value,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: surface,
                    hintText: 'Add notes...',
                    hintStyle: const TextStyle(color: textMuted),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radiusMedium),
                      borderSide: const BorderSide(color: borderSoft, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radiusMedium),
                      borderSide: const BorderSide(color: borderSoft, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radiusMedium),
                      borderSide: const BorderSide(color: primaryLavender, width: 2),
                    ),
                    contentPadding: const EdgeInsets.all(spacingM),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Error alert
              if (_showNameError) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: spacingM, vertical: 10),
                  decoration: BoxDecoration(
                    color: errorColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(radiusSmall),
                    border: Border.all(color: errorColor.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: errorColor, size: 20),
                      const SizedBox(width: spacingS),
                      const Expanded(
                        child: Text(
                          'Please enter a goal name',
                          style: TextStyle(color: errorColor, fontSize: 14),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _showNameError = false),
                        child: const Icon(Icons.close, size: 16, color: errorColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryCyan,
                    foregroundColor: surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radiusMedium),
                    ),
                  ),
                  child: Text(
                    _isEditing ? 'Save Changes' : 'Add Goal',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          dropdownColor: bgSecondary,
          style: const TextStyle(color: textPrimary, fontSize: 14),
          decoration: _dropdownDecoration(),
          icon: const Icon(Icons.arrow_drop_down, color: textPrimary),
          isExpanded: true,
          menuMaxHeight: 300,
          items: items.map((item) => DropdownMenuItem<T>(
            value: item,
            child: Text(item.toString()),
          )).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _DayOfWeekPicker extends StatelessWidget {
  final int? selectedDay;
  final ValueChanged<int?> onChanged;

  const _DayOfWeekPicker({required this.selectedDay, required this.onChanged});

  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 1; i <= 7; i++) ...[
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(selectedDay == i ? null : i),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: selectedDay == i ? primaryLavender : surface,
                  borderRadius: BorderRadius.circular(radiusSmall),
                  border: Border.all(
                    color: selectedDay == i ? primaryLavender : borderSoft,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  _dayLabels[i - 1],
                  style: TextStyle(
                    color: selectedDay == i ? Colors.white : textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          if (i < 7) const SizedBox(width: 8),
        ],
      ],
    );
  }
}
