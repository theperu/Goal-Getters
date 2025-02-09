import 'package:flutter/material.dart';
import '../models/goal.dart';

class Dashboard extends StatelessWidget {
  final List<Goal> goals;

  const Dashboard({
    super.key,
    required this.goals,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Overview Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress Overview',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    // You can add charts or statistics here
                    Text(
                      'Total Goals: ${goals.length}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Recent Activity Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Activity',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    // You can add a list of recent changes here
                    const Text('Coming soon...'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Quick Stats Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Stats',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    // Add some basic statistics
                    Text(
                      'Completed Goals: ${goals.where((g) => g.status == 'Done ✅').length}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      'In Progress: ${goals.where((g) => g.status == 'In Progress ⌛').length}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      'Blocked: ${goals.where((g) => g.status == 'Blocked ⛔').length}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}