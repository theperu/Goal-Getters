import 'package:flutter/material.dart';
import 'goal_form.dart';
import '../widgets/goal_card.dart';
import '../models/goal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Goal> _goals = [];
  late DateTime _selectedDate;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedDate = DateTime.now();
    _tabController.addListener(_handleTabChange);
    _loadGoals();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedDate = DateTime.now();
      });
    }
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
    
    if (_tabController.index == 0) {
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
    } else {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentWeek = _getWeekOfYear(_selectedDate);
    final currentYear = _selectedDate.year;

    final weeklyGoals = _goals.where((goal) => 
      goal.type == 'Weekly' && 
      goal.week == currentWeek && 
      goal.year == currentYear
    ).toList();
    
    final yearlyGoals = _goals.where((goal) => 
      goal.type == 'Yearly' && 
      goal.year == currentYear
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goal Tracker'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Weekly Goals'),
            Tab(text: 'Yearly Goals'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildNavigationBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView.builder(
                  itemCount: weeklyGoals.length,
                  itemBuilder: (context, index) {
                    final goal = weeklyGoals[index];
                    final relatedGoal = goal.relatedYearlyGoalId != null
                        ? _goals.firstWhere(
                            (g) => g.id == goal.relatedYearlyGoalId,
                            orElse: () => Goal(  // Default value when not found
                              id: '',
                              name: 'No related goal',
                              difficulty: 'Unknown',
                              importance: 'Unknown',
                              status: 'Todo 📝',
                              notes: '',
                              type: 'Yearly',
                            ),
                          )
                        : null; // No related goal if relatedYearlyGoalId is null

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
                ),

                ListView.builder(
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
                ),
              ],
            ),
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