import 'package:flutter/material.dart';
import 'goal_form.dart';
import '../widgets/goal_card.dart';
import '../models/goal.dart';
import '../utils/goal_helpers.dart';
import '../widgets/tab_switcher.dart';
import '../widgets/period_navigation_bar.dart';
import '../widgets/multi_segment_progress.dart';
import '../widgets/styled_container.dart';

class GoalsList extends StatefulWidget {
  final int initialTabIndex;
  final Function(int)? onTabChanged;

  const GoalsList({super.key, this.initialTabIndex = 0, this.onTabChanged});

  @override
  State<GoalsList> createState() => _GoalsListState();
}

class _GoalsListState extends State<GoalsList> with SingleTickerProviderStateMixin {
  List<Goal> _goals = [];
  late DateTime _selectedDate;
  late TabController _tabController;
  String _selectedType = 'weekly';
  
  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTabIndex);
    _selectedType = widget.initialTabIndex == 0 ? 'weekly' : 'yearly';
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedType = _tabController.index == 0 ? 'weekly' : 'yearly';
        });
        widget.onTabChanged?.call(_tabController.index);
      }
    });
    _loadGoals();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadGoals() async {
    final goals = await GoalStorage.loadGoals();
    setState(() {
      _goals = goals;
    });
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
      await _loadGoals();
      // Switch to the correct tab based on the goal type
      final targetIndex = (result as Goal).type == 'Weekly' ? 0 : 1;
      if (_tabController.index != targetIndex) {
        _tabController.animateTo(targetIndex);
      }
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

  void _updateGoalNotes(Goal goal, String newNotes) async {
    final updatedGoal = Goal(
      id: goal.id,
      name: goal.name,
      difficulty: goal.difficulty,
      importance: goal.importance,
      status: goal.status,
      notes: newNotes,
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
      _selectedDate = _selectedDate.add(Duration(days: 7 * delta));
    });
  }

  void _changeYear(int delta) {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year + delta, _selectedDate.month, _selectedDate.day);
    });
  }

  String getWeekDateRange(DateTime date) {
    final weekOfYear = _getWeekOfYear(date);
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysToAdd = (weekOfYear - 1) * 7 - firstDayOfYear.weekday + 1;
    final startOfWeek = firstDayOfYear.add(Duration(days: daysToAdd));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return '${getMonthName(startOfWeek.month)} ${startOfWeek.day} - ${getMonthName(endOfWeek.month)} ${endOfWeek.day}';
  }

  Map<String, dynamic> _calculateSummary() {
    final currentWeek = _getWeekOfYear(_selectedDate);
    final currentYear = _selectedDate.year;
    
    List<Goal> filteredGoals;
    if (_selectedType == 'weekly') {
      filteredGoals = _goals.where((goal) =>
          goal.type == 'Weekly' &&
          goal.year == currentYear &&
          goal.week == currentWeek).toList();
    } else {
      filteredGoals = _goals.where((goal) =>
          goal.type == 'Yearly' &&
          goal.year == currentYear).toList();
    }

    int total = filteredGoals.length;
    int completed = filteredGoals.where((g) => g.status == 'Done ✅').length;
    int inProgress = filteredGoals.where((g) => g.status == 'In Progress ⌛').length;
    int todo = filteredGoals.where((g) => g.status == 'Todo 📝').length;
    int notCompleted = filteredGoals.where((g) => 
        g.status == 'Blocked ⛔' || 
        g.status == 'Archived 🗃️' || 
        g.status == 'Rescheduled 🔄').length;
    
    double completionRate = total > 0 ? (completed / total) : 0.0;

    return {
      'total': total,
      'completed': completed,
      'inProgress': inProgress,
      'todo': todo,
      'notCompleted': notCompleted,
      'completionRate': completionRate,
    };
  }

  Widget _buildNavigationBar() {
    final currentWeek = _getWeekOfYear(_selectedDate);
    final currentYear = _selectedDate.year;
    final currentWeekRange = getWeekDateRange(_selectedDate);
    final summary = _calculateSummary();
    
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 0),
      child: Column(
        children: [
          // Weekly/Yearly Switcher
          TabSwitcher(
            tabController: _tabController,
            tabs: const ['Weekly', 'Yearly'],
          ),
          const SizedBox(height: 12),
          // Summary Section
          StyledContainer(
            width: double.infinity,
            borderRadius: 20,
            hasShadow: false,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Left side - text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedType == 'weekly' ? 'Weekly Goals' : 'Yearly Goals',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF66E0FF),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedType == 'weekly' 
                            ? 'Week ${_getWeekOfYear(_selectedDate)}'
                            : 'Year ${_selectedDate.year}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${summary['completed']} of ${summary['total']} completed',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFF3F4F6),
                        ),
                      ),
                    ],
                  ),
                ),
                // Right side - multi-segment circular progress
                MultiSegmentCircularProgress(
                  size: 64,
                  strokeWidth: 6,
                  segments: [
                    ProgressSegment(summary['completed'] / (summary['total'] == 0 ? 1 : summary['total']), const Color(0xFF10B981)),
                    ProgressSegment(summary['inProgress'] / (summary['total'] == 0 ? 1 : summary['total']), const Color(0xFF3B82F6)),
                    ProgressSegment(summary['notCompleted'] / (summary['total'] == 0 ? 1 : summary['total']), const Color(0xFFEF4444)),
                  ],
                  center: Text(
                    '${(summary['completionRate'] * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF3F4F6),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Compact Navigation Bar
          PeriodNavigationBar(
            onPrevious: () {
              if (_selectedType == 'weekly') {
                _changeWeek(-1);
              } else {
                _changeYear(-1);
              }
            },
            onNext: () {
              if (_selectedType == 'weekly') {
                _changeWeek(1);
              } else {
                _changeYear(1);
              }
            },
            centerContent: _selectedType == "weekly"
                ? WeekNavigationContent(
                    week: currentWeek,
                    year: currentYear,
                    weekRange: currentWeekRange,
                  )
                : YearNavigationContent(year: currentYear),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final currentWeek = _getWeekOfYear(_selectedDate);
    final currentYear = _selectedDate.year;

    switch (_selectedType) {
      case "weekly":
        final weeklyGoals = _goals.where((goal) => 
          goal.type == 'Weekly' && 
          goal.week == currentWeek && 
          goal.year == currentYear
        ).toList();

        return ReorderableListView.builder(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 0),
          itemCount: weeklyGoals.length,
          proxyDecorator: (Widget child, int index, Animation<double> animation) {
            return AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Material(
                  elevation: 8,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: Transform.scale(
                    scale: 1.05,
                    child: Opacity(
                      opacity: 0.9,
                      child: child,
                    ),
                  ),
                );
              },
              child: child,
            );
          },
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final goal = weeklyGoals.removeAt(oldIndex);
              weeklyGoals.insert(newIndex, goal);
              final allOtherGoals = _goals.where((g) => 
                !(g.type == 'Weekly' && g.week == currentWeek && g.year == currentYear)
              ).toList();
              _goals = [...allOtherGoals, ...weeklyGoals];
              GoalStorage.saveGoals(_goals);
            });
          },
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
              key: ValueKey(goal.id),
              goal: goal,
              relatedGoal: relatedGoal,
              onEdit: _editGoal,
              onDelete: _deleteGoal,
              onUpdateStatus: _updateGoalStatus,
              onUpdateNotes: _updateGoalNotes,
              statusColors: const {
                'Todo 📝': Color(0xFF1E293B),
                'In Progress ⌛': Color(0xFF1E3A5F),
                'Done ✅': Color(0xFF064E3B),
                'Blocked ⛔': Color(0xFF450A0A),
                'Archived 🗃️': Color(0xFF3B1E54),
                'Rescheduled 🔄': Color(0xFF78350F),
              },
            );
          },
        );

      case "yearly":
        final yearlyGoals = _goals.where((goal) => 
          goal.type == 'Yearly' && 
          goal.year == currentYear
        ).toList();

        return ReorderableListView.builder(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 0),
          itemCount: yearlyGoals.length,
          proxyDecorator: (Widget child, int index, Animation<double> animation) {
            return AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Material(
                  elevation: 8,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: Transform.scale(
                    scale: 1.05,
                    child: Opacity(
                      opacity: 0.9,
                      child: child,
                    ),
                  ),
                );
              },
              child: child,
            );
          },
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final goal = yearlyGoals.removeAt(oldIndex);
              yearlyGoals.insert(newIndex, goal);
              final allOtherGoals = _goals.where((g) => 
                !(g.type == 'Yearly' && g.year == currentYear)
              ).toList();
              _goals = [...allOtherGoals, ...yearlyGoals];
            });
          },
          itemBuilder: (context, index) => GoalCard(
            key: ValueKey(yearlyGoals[index].id),
            goal: yearlyGoals[index],
            onEdit: _editGoal,
            onDelete: _deleteGoal,
            onUpdateStatus: _updateGoalStatus,
            onUpdateNotes: _updateGoalNotes,
            statusColors: const {
              'Todo 📝': Color(0xFF1E293B),
              'In Progress ⌛': Color(0xFF1E3A5F),
              'Done ✅': Color(0xFF064E3B),
              'Blocked ⛔': Color(0xFF450A0A),
              'Archived 🗃️': Color(0xFF3B1E54),
              'Rescheduled 🔄': Color(0xFF78350F),
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
      backgroundColor: const Color(0xFF111827),
      body: Column(
        children: [
          _buildNavigationBar(),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }
}

