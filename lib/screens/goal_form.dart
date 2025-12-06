import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import '../models/goal.dart';

class GoalForm extends StatefulWidget {
  final Goal? goal;
  final List<Goal> yearlyGoals;
  final String? initialType;

  const GoalForm({
    super.key,
    this.goal,
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
  String? _relatedYearlyGoalId;
  int? _week;
  int? _year;

  // Dropdown state management
  bool _showTypeDropdown = false;
  bool _showWeekDropdown = false;
  bool _showYearDropdown = false;
  bool _showRelatedGoalDropdown = false;
  bool _showDifficultyDropdown = false;
  bool _showPriorityDropdown = false;
  bool _showStatusDropdown = false;
  bool _showNameError = false;
  
  final String _typeDropdownId = 'typeDropdown';
  final String _weekDropdownId = 'weekDropdown';
  final String _yearDropdownId = 'yearDropdown';
  final String _relatedGoalDropdownId = 'relatedGoalDropdown';
  final String _difficultyDropdownId = 'difficultyDropdown';
  final String _priorityDropdownId = 'priorityDropdown';
  final String _statusDropdownId = 'statusDropdown';

  final List<String> _difficulties = ['⭐', '⭐⭐', '⭐⭐⭐', '⭐⭐⭐⭐', '⭐⭐⭐⭐⭐'];
  final List<String> _importanceLevels = ['Low 🌱', 'Medium 🌿', 'High 🌳'];
  final List<String> _statusOptions = ['Todo 📝', 'In Progress ⌛', 'Done ✅', 'Blocked ⛔', 'Archived 🗃️', 'Rescheduled 🔄'];
  final List<String> _types = ['Weekly', 'Yearly'];

  @override
  void initState() {
    super.initState();
    _name = widget.goal?.name ?? '';
    _difficulty = widget.goal?.difficulty ?? '⭐⭐⭐';
    _importance = widget.goal?.importance ?? 'Medium 🌿';
    _status = widget.goal?.status ?? 'Todo 📝';
    _notes = widget.goal?.notes ?? '';
    _type = widget.goal?.type ?? widget.initialType ?? 'Weekly';
    _relatedYearlyGoalId = widget.goal?.relatedYearlyGoalId;
    _week = widget.goal?.week ?? _weekOfYear();
    _year = widget.goal?.year ?? DateTime.now().year;
    
    _nameController = TextEditingController(text: _name);
    _notesController = TextEditingController(text: _notes);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Goal Name',
                      style: TextStyle(
                        color: Color(0xFFF3F4F6),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    MoonTextInput(
                      controller: _nameController,
                      backgroundColor: const Color(0xFF1F2937),
                      textColor: const Color(0xFFF3F4F6),
                      hintTextColor: Colors.grey,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (value) => _name = value,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Type dropdown
                _buildMoonDropdown(
                  label: "Goal Type",
                  value: _type,
                  items: _types,
                  showDropdown: _showTypeDropdown,
                  groupId: _typeDropdownId,
                  onChanged: (value) {
                    setState(() {
                      _type = value;
                      _showTypeDropdown = false;
                      if (_type == 'Yearly') {
                        _relatedYearlyGoalId = null;
                        _week = null;
                      }
                    });
                  },
                  onToggle: () => setState(() => _showTypeDropdown = !_showTypeDropdown),
                ),
                const SizedBox(height: 16),

                if (_type == 'Yearly') ...[
                  _buildMoonDropdown(
                    label: "Year",
                    value: _year ?? DateTime.now().year,
                    items: List.generate(6, (index) => DateTime.now().year - 2 + index),
                    showDropdown: _showYearDropdown,
                    groupId: _yearDropdownId,
                    onChanged: (value) {
                      setState(() {
                        _year = value;
                        _showYearDropdown = false;
                      });
                    },
                    onToggle: () => setState(() => _showYearDropdown = !_showYearDropdown),
                  ),
                  const SizedBox(height: 16),
                ],

                if (_type == 'Weekly') ...[
                  _buildMoonDropdown(
                    label: "Week",
                    value: _week ?? _weekOfYear(),
                    items: List.generate(53, (index) => index + 1),
                    showDropdown: _showWeekDropdown,
                    groupId: _weekDropdownId,
                    onChanged: (value) {
                      setState(() {
                        _week = value;
                        _showWeekDropdown = false;
                      });
                    },
                    onToggle: () => setState(() => _showWeekDropdown = !_showWeekDropdown),
                  ),
                  const SizedBox(height: 16),
                  if (widget.yearlyGoals.isNotEmpty) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Related Yearly Goal (Optional)',
                          style: TextStyle(
                            color: Color(0xFFF3F4F6),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        MoonDropdown(
                          show: _showRelatedGoalDropdown,
                          groupId: _relatedGoalDropdownId,
                          constrainWidthToChild: false,
                          backgroundColor: const Color(0xFF1F2937),
                          onTapOutside: () => setState(() => _showRelatedGoalDropdown = false),
                          content: SizedBox(
                            width: double.infinity,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 300,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    MoonMenuItem(
                                      onTap: () {
                                        setState(() {
                                          _relatedYearlyGoalId = null;
                                          _showRelatedGoalDropdown = false;
                                        });
                                      },
                                      label: const Text(
                                        'None',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    ...widget.yearlyGoals.map((goal) {
                                      return MoonMenuItem(
                                        onTap: () {
                                          setState(() {
                                            _relatedYearlyGoalId = goal.id;
                                            _showRelatedGoalDropdown = false;
                                          });
                                        },
                                        label: Text(
                                          goal.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () => setState(() => _showRelatedGoalDropdown = !_showRelatedGoalDropdown),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1F2937),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFF374151),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _relatedYearlyGoalId == null 
                                      ? 'None'
                                      : widget.yearlyGoals.firstWhere((g) => g.id == _relatedYearlyGoalId).name,
                                    style: const TextStyle(
                                      color: Color(0xFFF3F4F6),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Icon(
                                    _showRelatedGoalDropdown ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                    color: const Color(0xFFF3F4F6),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ],

                _buildMoonDropdown(
                  label: "Difficulty",
                  value: _difficulty,
                  items: _difficulties,
                  showDropdown: _showDifficultyDropdown,
                  groupId: _difficultyDropdownId,
                  onChanged: (value) {
                    setState(() {
                      _difficulty = value;
                      _showDifficultyDropdown = false;
                    });
                  },
                  onToggle: () => setState(() => _showDifficultyDropdown = !_showDifficultyDropdown),
                ),
                const SizedBox(height: 16),

                _buildMoonDropdown(
                  label: "Priority",
                  value: _importance,
                  items: _importanceLevels,
                  showDropdown: _showPriorityDropdown,
                  groupId: _priorityDropdownId,
                  onChanged: (value) {
                    setState(() {
                      _importance = value;
                      _showPriorityDropdown = false;
                    });
                  },
                  onToggle: () => setState(() => _showPriorityDropdown = !_showPriorityDropdown),
                ),
                const SizedBox(height: 16),

                _buildMoonDropdown(
                  label: "Status",
                  value: _status,
                  items: _statusOptions,
                  showDropdown: _showStatusDropdown,
                  groupId: _statusDropdownId,
                  onChanged: (value) {
                    setState(() {
                      _status = value;
                      _showStatusDropdown = false;
                    });
                  },
                  onToggle: () => setState(() => _showStatusDropdown = !_showStatusDropdown),
                ),
                const SizedBox(height: 16),

                // Notes field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notes',
                      style: TextStyle(
                        color: Color(0xFFF3F4F6),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    MoonTextArea(
                      controller: _notesController,
                      backgroundColor: const Color(0xFF1F2937),
                      textColor: const Color(0xFFF3F4F6),
                      height: 200,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (value) => _notes = value,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Error alert
                if (_showNameError) ...[
                  MoonAlert.filled(
                    show: true,
                    color: const Color(0xFFEF4444),
                    backgroundColor: const Color(0xFFEF4444).withValues(alpha: 0.15),
                    leading: const Icon(Icons.error_outline, color: Color(0xFFEF4444)),
                    label: const Text(
                      'Please enter a goal name',
                      style: TextStyle(color: Color(0xFFEF4444)),
                    ),
                    trailing: MoonButton.icon(
                      buttonSize: MoonButtonSize.xs,
                      onTap: () => setState(() => _showNameError = false),
                      icon: const Icon(Icons.close, size: 16, color: Color(0xFFEF4444)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Submit button
                MoonButton(
                  onTap: _submitForm,
                  backgroundColor: const Color(0xFF66E0FF),
                  width: double.infinity,
                  buttonSize: MoonButtonSize.lg,
                  label: Text(
                    widget.goal == null ? 'Add Goal' : 'Save Changes',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoonDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required bool showDropdown,
    required String groupId,
    required ValueChanged<T> onChanged,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFF3F4F6),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        MoonDropdown(
          show: showDropdown,
          groupId: groupId,
          constrainWidthToChild: false,
          backgroundColor: const Color(0xFF1F2937),
          onTapOutside: () => setState(() {
            if (groupId == _typeDropdownId) _showTypeDropdown = false;
            if (groupId == _weekDropdownId) _showWeekDropdown = false;
            if (groupId == _relatedGoalDropdownId) _showRelatedGoalDropdown = false;
            if (groupId == _difficultyDropdownId) _showDifficultyDropdown = false;
            if (groupId == _priorityDropdownId) _showPriorityDropdown = false;
            if (groupId == _statusDropdownId) _showStatusDropdown = false;
          }),
          content: SizedBox(
            width: double.infinity,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 300,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: items.map((item) {
                    return MoonMenuItem(
                      onTap: () {
                        onChanged(item);
                        setState(() {
                          if (groupId == _typeDropdownId) _showTypeDropdown = false;
                          if (groupId == _weekDropdownId) _showWeekDropdown = false;
                          if (groupId == _relatedGoalDropdownId) _showRelatedGoalDropdown = false;
                          if (groupId == _difficultyDropdownId) _showDifficultyDropdown = false;
                          if (groupId == _priorityDropdownId) _showPriorityDropdown = false;
                          if (groupId == _statusDropdownId) _showStatusDropdown = false;
                        });
                      },
                      label: Text(
                        item.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          child: GestureDetector(
            onTap: onToggle,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF374151),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value.toString(),
                    style: const TextStyle(
                      color: Color(0xFFF3F4F6),
                      fontSize: 14,
                    ),
                  ),
                  Icon(
                    showDropdown ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: const Color(0xFFF3F4F6),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
