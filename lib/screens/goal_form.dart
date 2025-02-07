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
    _week = _weekOfYear();
    _year = widget.goal?.year ?? DateTime.now().year;
  }

  int _weekOfYear() {
    final firstDayOfYear = DateTime(DateTime.now().year, 1, 1);
    
    // Calculate days between the date and first day of year
    final difference = DateTime.now().difference(firstDayOfYear);
    
    return ((difference.inDays + firstDayOfYear.weekday) / 7).ceil();
  }

  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${_name.length}';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create new goal or update existing one
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
      appBar: AppBar(
        title: Text(widget.goal == null ? 'Add Goal' : 'Edit Goal'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name field
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(
                  labelText: 'Goal Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 16),

              // Type dropdown
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(
                  labelText: 'Goal Type',
                  border: OutlineInputBorder(),
                ),
                items: _types.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
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
                Row(
                  children: [
                    // Week dropdown
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _week ?? _weekOfYear(),
                        decoration: const InputDecoration(
                          labelText: 'Week',
                          border: OutlineInputBorder(),
                        ),
                        items: List.generate(53, (index) => index + 1)
                            .map((week) => DropdownMenuItem(
                                  value: week,
                                  child: Text('Week $week'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _week = value;
                            _year = DateTime.now().year; // Set year when week changes
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Year dropdown
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _year ?? DateTime.now().year,
                        decoration: const InputDecoration(
                          labelText: 'Year',
                          border: OutlineInputBorder(),
                        ),
                        items: List.generate(5, (index) => DateTime.now().year + index - 2)
                            .map((year) => DropdownMenuItem(
                                  value: year,
                                  child: Text(year.toString()),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _year = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Related yearly goal dropdown (only for weekly goals)
                if (widget.yearlyGoals.isNotEmpty)
                  DropdownButtonFormField<String?>(
                    value: _relatedYearlyGoalId,
                    decoration: const InputDecoration(
                      labelText: 'Related Yearly Goal (Optional)',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('None'),
                      ),
                      ...widget.yearlyGoals.map((goal) {
                        return DropdownMenuItem(
                          value: goal.id,
                          child: Text(goal.name),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _relatedYearlyGoalId = value;
                      });
                    },
                  ),
                const SizedBox(height: 16),
              ] else ...[
                // Year dropdown for non-weekly goals
                DropdownButtonFormField<int>(
                  value: _year ?? DateTime.now().year,
                  decoration: const InputDecoration(
                    labelText: 'Year',
                    border: OutlineInputBorder(),
                  ),
                  items: List.generate(5, (index) => DateTime.now().year + index - 2)
                      .map((year) => DropdownMenuItem(
                            value: year,
                            child: Text(year.toString()),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _year = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Difficulty dropdown
              DropdownButtonFormField<String>(
                value: _difficulty,
                decoration: const InputDecoration(
                  labelText: 'Difficulty',
                  border: OutlineInputBorder(),
                ),
                items: _difficulties.map((difficulty) {
                  return DropdownMenuItem(
                    value: difficulty,
                    child: Text(difficulty),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _difficulty = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Importance dropdown
              DropdownButtonFormField<String>(
                value: _importance,
                decoration: const InputDecoration(
                  labelText: 'Importance',
                  border: OutlineInputBorder(),
                ),
                items: _importanceLevels.map((importance) {
                  return DropdownMenuItem(
                    value: importance,
                    child: Text(importance),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _importance = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Status dropdown
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: _statusOptions.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Notes field
              TextFormField(
                initialValue: _notes,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onSaved: (value) => _notes = value ?? '',
              ),
              const SizedBox(height: 24),

              // Submit button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: Text(
                  widget.goal == null ? 'Add Goal' : 'Save Changes',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}