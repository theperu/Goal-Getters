import 'package:flutter/material.dart';
import '../screens/dashboard.dart';
import 'goals_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<String> _titles = ["Weekly", "Yearly", "Dashboard"];

  @override
  void initState() {
    super.initState();
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const GoalsList(type: "weekly");
      case 1:
        return const GoalsList(type: "yearly");
      case 2:
        return Dashboard();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF1F2937),
                child: IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            );
          },
        ),
        title: Text(
          _titles[_selectedIndex], // Dynamic title
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30, // Bigger title
            fontWeight: FontWeight.w100,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xFF1F2937),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {}, // Currently does nothing
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF111827),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF1F2937),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(color: Color(0xFFF3F4F6), fontSize: 24),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.white),
              title: const Text('Weekly', style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month_rounded, color: Colors.white),
              title: const Text('Yearly', style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dashboard, color: Colors.white),
              title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
