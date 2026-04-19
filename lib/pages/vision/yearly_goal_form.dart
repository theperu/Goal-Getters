import 'package:flutter/material.dart';
import '../../constants/style.dart';
import '../../constants/goal_icons.dart';
import '../../model/yearly_goal.dart';

class YearlyGoalForm extends StatefulWidget {
  final int year;
  final YearlyGoal? yearlyGoal;

  const YearlyGoalForm({
    super.key,
    required this.year,
    this.yearlyGoal,
  });

  @override
  State<YearlyGoalForm> createState() => _YearlyGoalFormState();
}

class _YearlyGoalFormState extends State<YearlyGoalForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _notesController;

  late String _name;
  late String _difficulty;
  late String _importance;
  late String _status;
  late String _notes;
  late int _year;
  String? _icon;

  bool _showNameError = false;

  final List<String> _difficulties = ['1', '2', '3', '4', '5'];
  final List<String> _importanceLevels = ['Low', 'Medium', 'High'];
  final List<String> _statusOptions = [
    'Todo',
    'In Progress',
    'Done',
    'Blocked',
    'Archived',
    'Rescheduled',
  ];

  bool get _isEditing => widget.yearlyGoal != null;

  @override
  void initState() {
    super.initState();
    final yg = widget.yearlyGoal;
    _name = yg?.name ?? '';
    _difficulty = yg?.difficulty ?? '3';
    _importance = yg?.importance ?? 'Medium';
    _status = yg?.status ?? 'Todo';
    _notes = yg?.notes ?? '';
    _year = yg?.year ?? widget.year;
    _icon = yg?.icon;

    _nameController = TextEditingController(text: _name);
    _notesController = TextEditingController(text: _notes);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_name.trim().isEmpty) {
      setState(() => _showNameError = true);
      return;
    }
    setState(() => _showNameError = false);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final goal = YearlyGoal(
        id: widget.yearlyGoal?.id,
        name: _name,
        difficulty: _difficulty,
        importance: _importance,
        status: _status,
        notes: _notes,
        year: _year,
        icon: _icon,
        createdAt: widget.yearlyGoal?.createdAt,
      );
      Navigator.pop(context, goal);
    }
  }

  static const _labelStyle = TextStyle(
    color: textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  InputDecoration _fieldDecoration({String? hintText}) {
    return InputDecoration(
      filled: true,
      fillColor: surface,
      hintText: hintText,
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
      contentPadding:
          const EdgeInsets.symmetric(horizontal: spacingL, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPrimary,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Yearly Goal' : 'New Yearly Goal'),
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
              // Name
              const Text('Goal Name', style: _labelStyle),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: textPrimary),
                textCapitalization: TextCapitalization.sentences,
                onChanged: (v) => _name = v,
                decoration: _fieldDecoration(hintText: 'Enter goal name'),
              ),
              const SizedBox(height: 16),

              // Icon picker
              const Text('Icon', style: _labelStyle),
              const SizedBox(height: 8),
              _IconPicker(
                selectedIcon: _icon,
                onChanged: (key) => setState(() => _icon = key),
              ),
              const SizedBox(height: 16),

              // Year
              _buildDropdown<int>(
                label: 'Year',
                value: _year,
                items:
                    List.generate(6, (i) => DateTime.now().year - 2 + i),
                onChanged: (v) => setState(() => _year = v!),
              ),
              const SizedBox(height: 16),

              // Difficulty
              _buildDropdown<String>(
                label: 'Difficulty',
                value: _difficulty,
                items: _difficulties,
                onChanged: (v) => setState(() => _difficulty = v!),
              ),
              const SizedBox(height: 16),

              // Priority
              _buildDropdown<String>(
                label: 'Priority',
                value: _importance,
                items: _importanceLevels,
                onChanged: (v) => setState(() => _importance = v!),
              ),
              const SizedBox(height: 16),

              // Status
              _buildDropdown<String>(
                label: 'Status',
                value: _status,
                items: _statusOptions,
                onChanged: (v) => setState(() => _status = v!),
              ),
              const SizedBox(height: 16),

              // Notes
              const Text('Notes', style: _labelStyle),
              const SizedBox(height: 8),
              SizedBox(
                height: 160,
                child: TextField(
                  controller: _notesController,
                  style: const TextStyle(color: textPrimary),
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  onChanged: (v) => _notes = v,
                  decoration: _fieldDecoration(hintText: 'Add notes...').copyWith(
                    contentPadding: const EdgeInsets.all(spacingM),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Error
              if (_showNameError) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: spacingM, vertical: 10),
                  decoration: BoxDecoration(
                    color: errorColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(radiusSmall),
                    border: Border.all(
                        color: errorColor.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: errorColor, size: 20),
                      const SizedBox(width: spacingS),
                      const Expanded(
                        child: Text('Please enter a goal name',
                            style:
                                TextStyle(color: errorColor, fontSize: 14)),
                      ),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _showNameError = false),
                        child: const Icon(Icons.close,
                            size: 16, color: errorColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Submit
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryLavender,
                    foregroundColor: surface,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(radiusMedium),
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
          decoration: _fieldDecoration(),
          icon: const Icon(Icons.arrow_drop_down, color: textPrimary),
          isExpanded: true,
          menuMaxHeight: 300,
          items: items
              .map((item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(item.toString()),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _IconPicker extends StatelessWidget {
  final String? selectedIcon;
  final ValueChanged<String> onChanged;

  const _IconPicker({
    required this.selectedIcon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: goalIconChoices.map((choice) {
        final isSelected = selectedIcon == choice.key;
        return GestureDetector(
          onTap: () => onChanged(choice.key),
          child: Tooltip(
            message: choice.label,
            child: AnimatedContainer(
              duration: animationFast,
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? primaryLavender.withValues(alpha: 0.15)
                    : surface,
                borderRadius: BorderRadius.circular(radiusSmall),
                border: Border.all(
                  color: isSelected ? primaryLavender : borderSoft,
                  width: isSelected ? 2 : 1.5,
                ),
              ),
              child: Icon(
                choice.icon,
                color: isSelected ? primaryLavender : textSecondary,
                size: 22,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
