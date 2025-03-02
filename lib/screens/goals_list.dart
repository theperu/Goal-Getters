import 'package:flutter/material.dart';
import 'goal_form.dart';
import '../widgets/goal_card.dart';
import '../models/goal.dart';

class GoalsList extends StatefulWidget {
  final String type;
  final int sortingType;

  const GoalsList({
    super.key,
    required this.type,
    required this.sortingType,
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

  List<Goal> _sortGoals(List<Goal> goalsList, int sortingType) {
    final List<String> _difficulties = ['⭐', '⭐⭐', '⭐⭐⭐', '⭐⭐⭐⭐', '⭐⭐⭐⭐⭐'];
    final List<String> _importanceLevels = ['Low 🌱', 'Medium 🌿', 'High 🌳'];
    final List<String> _statusOptions = ['Todo 📝', 'In Progress ⌛', 'Done ✅', 'Blocked ⛔', 'Archived 🗃️'];

    goalsList.sort((a, b) {
      if (sortingType == 0) {
        // Sort by Status
        return _statusOptions.indexOf(a.status).compareTo(_statusOptions.indexOf(b.status));
      } else if (sortingType == 1) {
        // Sort by Difficulty (Reversed order - hardest first)
        return _difficulties.indexOf(b.difficulty).compareTo(_difficulties.indexOf(a.difficulty));
      } else if (sortingType == 2) {
        // Sort by Importance (Reversed order - highest importance first)
        return _importanceLevels.indexOf(b.importance).compareTo(_importanceLevels.indexOf(a.importance));
      }
      return 0; // No sorting if invalid type
    });

    return goalsList;
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

  // Function to get the start and end dates of the week
  String getWeekDateRange(DateTime date) {
    int currentWeekday = date.weekday; // Monday = 1, Sunday = 7
    DateTime startOfWeek = date.subtract(Duration(days: currentWeekday - 1)); // Get Monday
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6)); // Get Sunday

    // Format dates as "MMM dd" (e.g., "Feb 12")
    String formattedStart = "${_getMonthAbbreviation(startOfWeek.month)} ${startOfWeek.day}";
    String formattedEnd = "${_getMonthAbbreviation(endOfWeek.month)} ${endOfWeek.day}";

    return "$formattedStart - $formattedEnd";
  }

  // Helper function to get month abbreviation
  String _getMonthAbbreviation(int month) {
    const List<String> months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  Widget _buildNavigationBar() {
    final currentWeek = _getWeekOfYear(_selectedDate);
    final currentYear = _selectedDate.year;
    final currentWeekRange = getWeekDateRange(_selectedDate);
    
    return Padding(
      padding: const EdgeInsets.all(12), 
        child: Card(
          elevation: 1, // Set elevation to 1
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(36)), // Rounded corners
          ),
          color: const Color(0xFF1F2937), // Card background color
          margin: EdgeInsets.zero, // Remove margin around the card
          child: Padding(
            padding: const EdgeInsets.all(28.0), // Padding inside the card
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
                    color: Color(0xFFF3F4F6),
                    size: 28.0,
                  ),
                ),
                if (widget.type == "weekly")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Week $currentWeek, $currentYear',
                        style: const TextStyle(
                          color: Color(0xFFF3F4F6),
                          fontSize: 36.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 2), // Space between texts
                      Text(
                        currentWeekRange,
                        style: const TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                if (widget.type == "yearly")
                  Text(
                    '$currentYear',
                    style: const TextStyle(
                      color: Color(0xFFF3F4F6),
                      fontSize: 40.0,
                      fontWeight: FontWeight.normal,
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
                    color: Color(0xFFF3F4F6),
                    size: 32.0,
                  ),
                ),
              ],
            ),
          ),
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

        List<Goal> sortedGoals = _sortGoals(weeklyGoals, widget.sortingType);

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: sortedGoals.length,
          itemBuilder: (context, index) {
            final goal = sortedGoals[index];
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
                'Todo 📝': Color(0xFF161E2D),
                'In Progress ⌛': Color(0xFF15233C),
                'Done ✅': Color(0xFF112930),
                'Blocked ⛔': Color(0xFF271D2A),
                'Archived 🗃️': Color(0xFF271D2A),
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
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) => GoalCard(
            goal: yearlyGoals[index],
            onEdit: _editGoal,
            onDelete: _deleteGoal,
            onUpdateStatus: _updateGoalStatus,
            statusColors: const {
              'Todo 📝': Color(0xFF161E2D),
              'In Progress ⌛': Color(0xFF15233C),
              'Done ✅': Color(0xFF112930),
              'Blocked ⛔': Color(0xFF271D2A),
              'Archived 🗃️': Color(0xFF271D2A),
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
      backgroundColor: Color(0xFF111827),
      body: Column(
        children: [
          _buildNavigationBar(),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGoal,
        foregroundColor: const Color(0xFFF3F4F6),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.add),
      ),
    );
  }
}