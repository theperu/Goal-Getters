import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../widgets/section_header.dart';
import '../widgets/mini_stat_card.dart';
import '../widgets/linear_progress_section.dart';
import '../widgets/circular_progress_card.dart';
import '../widgets/styled_container.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Goal> _goals = [];

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    final goals = await GoalStorage.loadGoals();
    setState(() {
      _goals = goals;
    });
  }

  Map<String, dynamic> _processGoalsData() {
    int currentYear = DateTime.now().year;
    int currentWeek = _getWeekNumber(DateTime.now());

    // Current week goals
    List<Goal> currentWeekGoals = _goals.where((goal) =>
        goal.type == 'Weekly' &&
        goal.year == currentYear &&
        goal.week == currentWeek).toList();

    int weekTotal = currentWeekGoals.length;
    int weekCompleted = currentWeekGoals.where((g) => g.status == 'Done ✅').length;
    int weekInProgress = currentWeekGoals.where((g) => g.status == 'In Progress ⌛').length;
    int weekBlocked = currentWeekGoals.where((g) => g.status == 'Blocked ⛔').length;
    int weekTodo = currentWeekGoals.where((g) => g.status == 'Todo 📝').length;

    double weekCompletionRate = weekTotal > 0
        ? (weekCompleted / weekTotal)
        : 0.0;

    // All weekly goals for the year
    List<Goal> allWeeklyGoals = _goals.where((goal) =>
        goal.type == 'Weekly' &&
        goal.year == currentYear).toList();

    int yearTotal = allWeeklyGoals.length;
    int yearCompleted = allWeeklyGoals.where((g) => g.status == 'Done ✅').length;
    double yearCompletionRate = yearTotal > 0
        ? (yearCompleted / yearTotal)
        : 0.0;

    // Yearly goals
    List<Goal> yearlyGoals = _goals.where((goal) =>
        goal.type == 'Yearly' &&
        goal.year == currentYear).toList();

    int yearlyGoalsTotal = yearlyGoals.length;
    int yearlyGoalsCompleted = yearlyGoals.where((g) => g.status == 'Done ✅').length;
    double yearlyGoalsRate = yearlyGoalsTotal > 0
        ? (yearlyGoalsCompleted / yearlyGoalsTotal)
        : 0.0;

    return {
      'currentWeek': currentWeek,
      'weekTotal': weekTotal,
      'weekCompleted': weekCompleted,
      'weekInProgress': weekInProgress,
      'weekBlocked': weekBlocked,
      'weekTodo': weekTodo,
      'weekCompletionRate': weekCompletionRate,
      'yearTotal': yearTotal,
      'yearCompleted': yearCompleted,
      'yearCompletionRate': yearCompletionRate,
      'yearlyGoalsTotal': yearlyGoalsTotal,
      'yearlyGoalsCompleted': yearlyGoalsCompleted,
      'yearlyGoalsRate': yearlyGoalsRate,
    };
  }

  int _getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final difference = date.difference(firstDayOfYear);
    return ((difference.inDays + firstDayOfYear.weekday) / 7).ceil();
  }

  @override
  Widget build(BuildContext context) {
    final data = _processGoalsData();

    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Week Progress Header
              CircularProgressCard(
                title: 'Week ${data['currentWeek']} Progress',
                progressValue: data['weekCompletionRate'] as double,
                completed: data['weekCompleted'] as int,
                total: data['weekTotal'] as int,
              ),
              const SizedBox(height: 24),

              // Current Week Status Breakdown
              const SectionHeader(text: 'This Week'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: MiniStatCard(
                      title: 'Todo',
                      value: data['weekTodo'].toString(),
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MiniStatCard(
                      title: 'In Progress',
                      value: data['weekInProgress'].toString(),
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: MiniStatCard(
                      title: 'Done',
                      value: data['weekCompleted'].toString(),
                      color: const Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MiniStatCard(
                      title: 'Blocked',
                      value: data['weekBlocked'].toString(),
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Year Overview
              const SectionHeader(text: 'Year Overview'),
              const SizedBox(height: 16),
              StyledContainer(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Weekly Goals Progress
                    LinearProgressSection(
                      label: 'Weekly Goals',
                      completed: data['yearCompleted'] as int,
                      total: data['yearTotal'] as int,
                      progressColor: const Color(0xFF66E0FF),
                    ),
                    const SizedBox(height: 24),
                    // Yearly Goals Progress
                    LinearProgressSection(
                      label: 'Yearly Goals',
                      completed: data['yearlyGoalsCompleted'] as int,
                      total: data['yearlyGoalsTotal'] as int,
                      progressColor: const Color(0xFFFFCE52),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}


