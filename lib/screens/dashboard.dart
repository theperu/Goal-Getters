import 'package:flutter/material.dart';
import '../models/goal.dart';

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

    // Filter only weekly goals for the current year
    List<Goal> weeklyGoals = _goals.where((goal) =>
        goal.type == 'Weekly' &&
        goal.year == currentYear).toList();

    int totalGoals = weeklyGoals.length;
    int completedGoals = weeklyGoals.where((g) => g.status == 'Done ✅').length;
    int inProgressGoals = weeklyGoals.where((g) => g.status == 'In Progress ⌛').length;
    int blockedGoals = weeklyGoals.where((g) => g.status == 'Blocked ⛔').length;

    // Calculate completion rate
    double completionRate = totalGoals > 0
        ? (completedGoals / totalGoals * 100).roundToDouble()
        : 0.0;

    return {
      'totalGoals': totalGoals,
      'completedGoals': completedGoals,
      'inProgressGoals': inProgressGoals,
      'blockedGoals': blockedGoals,
      'completionRate': completionRate,
    };
  }

  @override
  Widget build(BuildContext context) {
    final data = _processGoalsData();

    return Scaffold(
      backgroundColor: const Color(0xFF111827), // Background color
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Week Header
              Card(
                color: const Color(0xFF1F2937), // Updated card background
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () {},
                        color: Colors.grey[400],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Weekly goals stats',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${data['totalGoals']} total goals',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {},
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Stats Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _StatCard(
                    title: 'Completed',
                    value: data['completedGoals'].toString(),
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                  _StatCard(
                    title: 'In Progress',
                    value: data['inProgressGoals'].toString(),
                    icon: Icons.pending,
                    color: Colors.blue,
                  ),
                  _StatCard(
                    title: 'Completion Rate',
                    value: '${data['completionRate']}%',
                    icon: Icons.trending_up,
                    color: Colors.orange,
                  ),
                  _StatCard(
                    title: 'Blocked',
                    value: data['blockedGoals'].toString(),
                    icon: Icons.error,
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937), // Updated card background
        borderRadius: BorderRadius.circular(12), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40), // Slightly larger icon
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
