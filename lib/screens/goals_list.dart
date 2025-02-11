import 'package:flutter/material.dart';
import 'goal_form.dart';
import '../widgets/goal_card.dart';
import '../models/goal.dart';

class GoalsList extends StatefulWidget {
  final String type;

  const GoalsList({
    super.key,
    required this.type,
  });

  @override
  State<GoalsList> createState() => _GoalsListState();
}

class _GoalsListState extends State<GoalsList> {
  List<Goal> _goals = [];
  late DateTime _selectedDate;
  
  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    final goals = await GoalStorage.loadGoals();
    setState(() {
      _goals = goals;
    });
  }

  void _addGoal() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoalForm(
          yearlyGoals: _goals.where((g) => g.type == 'Yearly').toList(),
        ),
      ),
    );

    if (result != null) {
      await GoalStorage.saveGoal(result);
      _loadGoals();
    }
  }

  void _editGoal(Goal goal) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoalForm(
          goal: goal,
          yearlyGoals: _goals.where((g) => g.type == 'Yearly').toList(),
        ),
      ),
    );

    if (result != null) {
      await GoalStorage.saveGoal(result);
      _loadGoals();
    }
  }

  void _deleteGoal(Goal goal) async {
    await GoalStorage.deleteGoal(goal.id);
    _loadGoals();
  }

  void _updateGoalStatus(Goal goal, String newStatus) async {
    final updatedGoal = Goal(
      id: goal.id,
      name: goal.name,
      difficulty: goal.difficulty,
      importance: goal.importance,
      status: newStatus,
      notes: goal.notes,
      type: goal.type,
      relatedYearlyGoalId: goal.relatedYearlyGoalId,
      week: goal.week,
      year: goal.year,
    );

    await GoalStorage.saveGoal(updatedGoal);
    _loadGoals();
  }

  int _getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final difference = date.difference(firstDayOfYear);
    return ((difference.inDays + firstDayOfYear.weekday) / 7).ceil();
  }

  void _changeWeek(int delta) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: delta * 7));
    });
  }

  void _changeYear(int delta) {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year + delta, 
          _selectedDate.month, _selectedDate.day);
    });
  }

  Widget _buildNavigationBar() {
    final currentWeek = _getWeekOfYear(_selectedDate);
    final currentYear = _selectedDate.year;
    
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF3883b1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36.0),
          bottomRight: Radius.circular(36.0),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () { 
              if (widget.type == 'weekly') {
                _changeWeek(-1);
              } else {
                _changeYear(-1);
              }
            }, // Go to previous year/week
            child: const Icon(
              Icons.keyboard_arrow_left_outlined,
              color: Colors.white,
              size: 28.0,
            ),
          ),
          if (widget.type == "weekly")
            Text(
              'Week $currentWeek, $currentYear',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (widget.type == "yearly")
            Text(
              '$currentYear',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          GestureDetector(
            onTap: () { 
              if (widget.type == 'weekly') {
                _changeWeek(1);
              } else {
                _changeYear(1);
              }
            }, // Go to next year/week
            child: const Icon(
              Icons.keyboard_arrow_right_outlined,
              color: Colors.white,
              size: 32.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final currentWeek = _getWeekOfYear(_selectedDate);
    final currentYear = _selectedDate.year;

    switch (widget.type) {
      case "weekly":  // Weekly Goals
        final weeklyGoals = _goals.where((goal) => 
          goal.type == 'Weekly' && 
          goal.week == currentWeek && 
          goal.year == currentYear
        ).toList();

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: weeklyGoals.length,
          itemBuilder: (context, index) {
            final goal = weeklyGoals[index];
            final relatedGoal = goal.relatedYearlyGoalId != null
                ? _goals.firstWhere(
                    (g) => g.id == goal.relatedYearlyGoalId,
                    orElse: () => Goal(
                      id: '',
                      name: 'No related goal',
                      difficulty: 'Unknown',
                      importance: 'Unknown',
                      status: 'Todo 📝',
                      notes: '',
                      type: 'Yearly',
                    ),
                  )
                : null;

            return GoalCard(
              goal: goal,
              relatedGoal: relatedGoal,
              onEdit: _editGoal,
              onDelete: _deleteGoal,
              onUpdateStatus: _updateGoalStatus,
              statusColors: const {
                'Todo 📝': Color(0xFFF8F8F8),
                'In Progress ⌛': Color(0xFF3883b1),
                'Done ✅': Color(0xFF3cbb6d),
                'Blocked ⛔': Color(0xFFbb3c3c),
              },
            );
          },
        );

      case "yearly":  // Yearly Goals
        final yearlyGoals = _goals.where((goal) => 
          goal.type == 'Yearly' && 
          goal.year == currentYear
        ).toList();

        return ListView.builder(
          itemCount: yearlyGoals.length,
          itemBuilder: (context, index) => GoalCard(
            goal: yearlyGoals[index],
            onEdit: _editGoal,
            onDelete: _deleteGoal,
            onUpdateStatus: _updateGoalStatus,
            statusColors: const {
              'Todo 📝': Color(0xFFF8F8F8),
              'In Progress ⌛': Color(0xFF3883b1),
              'Done ✅': Color(0xFF3cbb6d),
              'Blocked ⛔': Color(0xFFbb3c3c),
            },
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          _buildNavigationBar(),
          Expanded(
            child: _buildBody(),
          ),
        ],
      )
    );
  }
}