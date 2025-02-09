import 'package:flutter/material.dart';
import 'package:goal_getters/screens/goals_list.dart';
import 'goal_form.dart';
import '../models/goal.dart';
import '../screens/dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
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

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:  // Weekly Goals
        return const GoalsList(type: "weekly");

      case 1:  // Yearly Goals
        return const GoalsList(type: "yearly");

      case 2:  // Dashboard
        return Dashboard(goals: _goals);

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goal Tracker'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'Weekly Goals',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Yearly Goals',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGoal,
        child: const Icon(Icons.add),
      ),
    );
  }
}