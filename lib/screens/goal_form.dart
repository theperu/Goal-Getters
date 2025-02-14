import 'package:flutter/material.dart';
import '../models/goal.dart';

class GoalForm extends StatefulWidget {
  final Goal? goal;
  final List<Goal> yearlyGoals;

  const GoalForm({
    super.key,
    this.goal,
    required this.yearlyGoals,
  });

  @override
  State<GoalForm> createState() => _GoalFormState();
}

class _GoalFormState extends State<GoalForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _difficulty;
  late String _importance;
  late String _status;
  late String _notes;
  late String _type;
  String? _relatedYearlyGoalId;
  int? _week;
  int? _year;

  final List<String> _difficulties = ['⭐', '⭐⭐', '⭐⭐⭐', '⭐⭐⭐⭐', '⭐⭐⭐⭐⭐'];
  final List<String> _importanceLevels = ['Low 🌱', 'Medium 🌿', 'High 🌳'];
  final List<String> _statusOptions = ['Todo 📝', 'In Progress ⌛', 'Done ✅', 'Blocked ⛔'];
  final List<String> _types = ['Weekly', 'Yearly'];

  @override
  void initState() {
    super.initState();
    _name = widget.goal?.name ?? '';
    _difficulty = widget.goal?.difficulty ?? '⭐⭐⭐';
    _importance = widget.goal?.importance ?? 'Medium 🌿';
    _status = widget.goal?.status ?? 'Todo 📝';
    _notes = widget.goal?.notes ?? '';
    _type = widget.goal?.type ?? 'Weekly';
    _relatedYearlyGoalId = widget.goal?.relatedYearlyGoalId;
    _week = widget.goal?.week ?? _weekOfYear();
    _year = widget.goal?.year ?? DateTime.now().year;
  }

  int _weekOfYear() {
    final firstDayOfYear = DateTime(DateTime.now().year, 1, 1);
    final difference = DateTime.now().difference(firstDayOfYear);
    return ((difference.inDays + firstDayOfYear.weekday) / 7).ceil();
  }

  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${_name.length}';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final goal = Goal(
        id: widget.goal?.id ?? _generateId(),
        name: _name,
        difficulty: _difficulty,
        importance: _importance,
        status: _status,
        notes: _notes,
        type: _type,
        relatedYearlyGoalId: _type == 'Weekly' ? _relatedYearlyGoalId : null,
        week: _type == 'Weekly' ? _week : null,
        year: _year,
      );

      Navigator.pop(context, goal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111827), // Background color
      appBar: AppBar(
        title: Text(widget.goal == null ? 'Add Goal' : 'Edit Goal'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(color: Colors.grey.shade400),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
              border: const OutlineInputBorder(),
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Name field
                TextFormField(
                  initialValue: _name,
                  style: const TextStyle(color: Color(0xFFF3F4F6)), // Light text
                  decoration: const InputDecoration(labelText: 'Goal Name'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter a goal name' : null,
                  onSaved: (value) => _name = value!,
                ),
                const SizedBox(height: 16),

                // Type dropdown
                _buildDropdown(
                  label: "Goal Type",
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

                if (_type == 'Weekly') ...[
                  _buildDropdown(
                    label: "Week",
                    value: _week ?? _weekOfYear(),
                    items: List.generate(53, (index) => index + 1),
                    onChanged: (value) => setState(() => _week = value),
                  ),
                  const SizedBox(height: 16),
                ],

                _buildDropdown(
                  label: "Difficulty",
                  value: _difficulty,
                  items: _difficulties,
                  onChanged: (value) => setState(() => _difficulty = value!),
                ),
                const SizedBox(height: 16),

                _buildDropdown(
                  label: "Importance",
                  value: _importance,
                  items: _importanceLevels,
                  onChanged: (value) => setState(() => _importance = value!),
                ),
                const SizedBox(height: 16),

                _buildDropdown(
                  label: "Status",
                  value: _status,
                  items: _statusOptions,
                  onChanged: (value) => setState(() => _status = value!),
                ),
                const SizedBox(height: 16),

                // Notes field
                TextFormField(
                  initialValue: _notes,
                  style: const TextStyle(color: Color(0xFFF3F4F6)),
                  decoration: const InputDecoration(labelText: 'Notes'),
                  maxLines: 3,
                  onSaved: (value) => _notes = value ?? '',
                ),
                const SizedBox(height: 24),

                // Submit button
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6), // Blue button
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    widget.goal == null ? 'Add Goal' : 'Save Changes',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
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
    return DropdownButtonFormField<T>(
      value: value,
      style: const TextStyle(color: Color(0xFFF3F4F6)),
      decoration: InputDecoration(labelText: label),
      dropdownColor: const Color(0xFF374151), // Slightly lighter grey dropdown
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item.toString(), style: const TextStyle(color: Colors.white)),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
