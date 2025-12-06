import 'package:flutter/material.dart';
import 'archive.dart';
import 'goals_list.dart';
import 'goal_form.dart';
import '../models/goal.dart';
import '../widgets/bottom_nav_item.dart';
import '../widgets/circular_add_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _goalsListTabIndex = 0;
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

  void _addGoal() async {
    final initialType = _goalsListTabIndex == 0 ? 'Weekly' : 'Yearly';
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoalForm(
          yearlyGoals: _goals.where((g) => g.type == 'Yearly').toList(),
          initialType: initialType,
        ),
      ),
    );

    if (result != null) {
      await GoalStorage.saveGoal(result);
      await _loadGoals();
      setState(() {
        _selectedIndex = 0;
        _goalsListTabIndex = (result as Goal).type == 'Weekly' ? 0 : 1;
      });
    }
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return GoalsList(
          key: ValueKey('goals_list_$_goalsListTabIndex'),
          initialTabIndex: _goalsListTabIndex,
          onTabChanged: (index) {
            _goalsListTabIndex = index;
          },
        );
      case 1:
        return const Archive();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _buildBody(),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BottomNavItem(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home_rounded,
                isSelected: _selectedIndex == 0,
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              CircularAddButton(onTap: _addGoal),
              BottomNavItem(
                icon: Icons.archive_outlined,
                selectedIcon: Icons.archive_rounded,
                isSelected: _selectedIndex == 1,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
