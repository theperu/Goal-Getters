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
    
    if (widget.type == "weekly") {  // Weekly Goals
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_left),
              onPressed: () => _changeWeek(-1),
            ),
            Text(
              'Week $currentWeek, $currentYear',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_right),
              onPressed: () => _changeWeek(1),
            ),
          ],
        ),
      );
    } else if (widget.type == "yearly") {  // Yearly Goals
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_left),
              onPressed: () => _changeYear(-1),
            ),
            Text(
              '$currentYear',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_right),
              onPressed: () => _changeYear(1),
            ),
          ],
        ),
      );
    } else {  // Dashboard
      return const SizedBox.shrink();  // Empty for now
    }
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
                'Todo 📝': Colors.grey,
                'In Progress ⌛': Colors.blue,
                'Done ✅': Color.fromARGB(255, 82, 171, 86),
                'Blocked ⛔': Color.fromARGB(255, 232, 85, 74),
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
              'Todo 📝': Colors.grey,
              'In Progress ⌛': Colors.blue,
              'Done ✅': Color.fromARGB(255, 82, 171, 86),
              'Blocked ⛔': Color.fromARGB(255, 232, 85, 74),
            },
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildNavigationBar(),
        Expanded(
          child: _buildBody(),
        ),
      ],
    );
  }
}