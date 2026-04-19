import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes/routes.dart';
import 'services/data_migration.dart';
import 'services/database/goal_getters_database.dart';
import 'services/database/repositories/weekly_goal_repository.dart';
import 'services/database/repositories/yearly_goal_repository.dart';
import 'ui/theme/app_theme.dart';
import 'services/goal_archiver.dart';
import 'services/notification_service.dart';
import 'providers/shared_preferences_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize database and repositories
  final db = GoalGettersDatabase.instance;
  final weeklyRepo = WeeklyGoalRepository(database: db);
  final yearlyRepo = YearlyGoalRepository(database: db);

  // Migrate data from SharedPreferences to SQLite (one-time)
  await DataMigrationService.migrateIfNeeded(weeklyRepo, yearlyRepo);

  // Initialize notifications
  await NotificationService.init();

  // Re-schedule reminder if previously enabled (survives reboot / force-stop)
  try {
    await NotificationService.restoreScheduledReminder(sharedPreferences);
  } catch (e) {
    debugPrint('Failed to restore reminder: $e');
  }

  // Archive old weekly goals
  final archivedCount = await GoalArchiver.archiveOldGoals(weeklyRepo);
  if (archivedCount > 0) {
    debugPrint('Archived $archivedCount old goals');
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefProvider.overrideWithValue(sharedPreferences),
      ],
      child: const GoalGettersApp(),
    ),
  );
}

class GoalGettersApp extends ConsumerWidget {
  const GoalGettersApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Goal Getters',
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      onGenerateRoute: makeRoute,
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
