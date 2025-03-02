import 'package:flutter/material.dart';

import '../models/goal.dart';

class Archive extends StatefulWidget {
  const Archive({Key? key}) : super(key: key);

  @override
  _ArchiveState createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  List<Goal> _archivedGoals = [];
  bool _isLoading = true;
  final Set<String> _expandedGoalIds = {};

  @override
  void initState() {
    super.initState();
    _loadArchivedGoals();
  }

  Future<void> _loadArchivedGoals() async {
    setState(() {
      _isLoading = true;
    });

    final allGoals = await GoalStorage.loadGoals();
    _archivedGoals =
        allGoals.where((goal) => goal.status == 'Archived 🗃️').toList();

    _archivedGoals.sort((a, b) {
      if (a.year != b.year) {
        return (b.year ?? 0).compareTo(a.year ?? 0);
      }
      return (b.week ?? 0).compareTo(a.week ?? 0);
    });

    setState(() {
      _isLoading = false;
    });
  }

  Map<int, Map<int, List<Goal>>> _groupGoalsByYearAndWeek() {
    final groupedGoals = <int, Map<int, List<Goal>>>{};

    for (final goal in _archivedGoals) {
      if (goal.year == null || goal.week == null) continue;

      groupedGoals.putIfAbsent(goal.year!, () => {});
      groupedGoals[goal.year!]!.putIfAbsent(goal.week!, () => []);
      groupedGoals[goal.year!]![goal.week!]!.add(goal);
    }

    return groupedGoals;
  }

  String _formatWeekRange(int year, int week) {
    final firstDayOfYear = DateTime(year, 1, 1);
    final dayOffset = firstDayOfYear.weekday - 1;
    final weekStart = firstDayOfYear.add(Duration(days: (week - 1) * 7 - dayOffset));
    final weekEnd = weekStart.add(const Duration(days: 6));

    return '${_formatDate(weekStart)} - ${_formatDate(weekEnd)}';
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  static int _getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final difference = date.difference(firstDayOfYear);
    return ((difference.inDays + firstDayOfYear.weekday) / 7).ceil();
  }

  Future<void> _rescheduleGoal(Goal goal) async {
    final now = DateTime.now();
    final currentWeek = _getWeekOfYear(now);
    final currentYear = now.year;

    final weekOptions = <int>[currentWeek, currentWeek + 1, currentWeek + 2, currentWeek + 3];

    final result = await showDialog<Map<String, int>>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Color(0xFF1F2937),
          title: const Text('Reschedule to current or upcoming week', style: TextStyle(color: Colors.white)),
          children: [
            ...weekOptions.map((week) => 
              SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop({'week': week, 'year': currentYear}),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Week $week (${_formatWeekRange(currentYear, week)})',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ).toList(),
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop(),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Cancel', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        );
      },
    );

    if (result != null) {
      final updatedGoal = Goal(
        id: goal.id,
        name: goal.name,
        difficulty: goal.difficulty,
        importance: goal.importance,
        status: 'Todo 📝',
        notes: goal.notes,
        type: goal.type,
        relatedYearlyGoalId: goal.relatedYearlyGoalId,
        week: result['week'],
        year: result['year'],
      );

      await GoalStorage.saveGoal(updatedGoal);
      _loadArchivedGoals();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Goal rescheduled to Week ${result['week']}, ${result['year']}')),
      );
    }
  }

  void _toggleExpanded(String goalId) {
    setState(() {
      if (_expandedGoalIds.contains(goalId)) {
        _expandedGoalIds.remove(goalId);
      } else {
        _expandedGoalIds.add(goalId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF111827),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_archivedGoals.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFF111827),
        body: Center(
          child: Text('No archived goals found', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    final groupedGoals = _groupGoalsByYearAndWeek();
    final years = groupedGoals.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      body: ListView.builder(
        itemCount: years.length,
        itemBuilder: (context, yearIndex) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: years.map((year) {
              final weeksInYear = groupedGoals[year]!.keys.toList()..sort((a, b) => b.compareTo(a));

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Year Heading
                    Text(
                      '$year',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Weeks and Goals
                    ...weeksInYear.map((week) {
                      final goalsInWeek = groupedGoals[year]![week]!;

                      return Padding(
                        padding: const EdgeInsets.only(left: 16.0, bottom: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Week $week (${_formatWeekRange(year, week)})',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            ...goalsInWeek.map((goal) {
                              final isExpanded = _expandedGoalIds.contains(goal.id);

                              return Card(
                                color: const Color(0xFF1F2937),
                                margin: const EdgeInsets.symmetric(vertical: 4.0),
                                elevation: 1,
                                child: InkWell(
                                  onTap: () => _toggleExpanded(goal.id),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                goal.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.calendar_today, size: 20, color: Colors.white),
                                              onPressed: () => _rescheduleGoal(goal),
                                              tooltip: 'Reschedule',
                                            ),
                                          ],
                                        ),
                                        if (isExpanded) ...[
                                          const Divider(color: Colors.white),
                                          const SizedBox(height: 8),
                                          Text('Difficulty: ${goal.difficulty}', style: const TextStyle(color: Colors.white)),
                                          const SizedBox(height: 4),
                                          Text('Importance: ${goal.importance}', style: const TextStyle(color: Colors.white)),
                                          const SizedBox(height: 8),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
