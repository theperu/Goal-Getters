import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/weekly_goal.dart';
import '../model/yearly_goal.dart';
import 'database/repositories/weekly_goal_repository.dart';
import 'database/repositories/yearly_goal_repository.dart';

class DataMigrationService {
  static const String _oldGoalsKey = 'goals';
  static const String _migrationCompleteKey = 'migration_v1_complete';

  /// Map old emoji statuses to plain text
  static String _migrateStatus(String old) {
    switch (old) {
      case 'Todo \u{1f4dd}':
        return 'Todo';
      case 'In Progress \u{231b}':
        return 'In Progress';
      case 'Done \u{2705}':
        return 'Done';
      case 'Blocked \u{26d4}':
        return 'Blocked';
      case 'Archived \u{1f5c3}\u{fe0f}':
        return 'Archived';
      case 'Rescheduled \u{1f504}':
        return 'Rescheduled';
      default:
        return old;
    }
  }

  /// Map old emoji importance to plain text
  static String _migrateImportance(String old) {
    if (old.contains('Low')) return 'Low';
    if (old.contains('High')) return 'High';
    return 'Medium';
  }

  /// Map old star difficulty to numeric
  static String _migrateDifficulty(String old) {
    final count = old.codeUnits.where((c) => c == 0x2B50).length;
    if (count > 0) return count.toString();
    return old;
  }

  /// Migrates goal data from SharedPreferences (JSON) to SQLite.
  /// Runs only once — skips if already completed.
  static Future<void> migrateIfNeeded(
    WeeklyGoalRepository weeklyRepo,
    YearlyGoalRepository yearlyRepo,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(_migrationCompleteKey) == true) return;

    final goalsJson = prefs.getStringList(_oldGoalsKey);
    if (goalsJson == null || goalsJson.isEmpty) {
      await prefs.setBool(_migrationCompleteKey, true);
      return;
    }

    // First pass: insert yearly goals, map old string IDs to new int IDs
    final Map<String, int> yearlyIdMap = {};

    for (final json in goalsJson) {
      final map = jsonDecode(json) as Map<String, dynamic>;
      if (map['type'] != 'Yearly') continue;

      final oldId = map['id'] as String;
      final goal = YearlyGoal(
        name: map['name'] as String,
        difficulty: _migrateDifficulty(map['difficulty'] as String),
        importance: _migrateImportance(map['importance'] as String),
        status: _migrateStatus(map['status'] as String),
        notes: (map['notes'] as String?) ?? '',
        year: map['year'] as int? ?? DateTime.now().year,
      );

      final inserted = await yearlyRepo.insert(goal);
      yearlyIdMap[oldId] = inserted.id!;
    }

    // Second pass: insert weekly goals, remap relatedYearlyGoalId
    for (final json in goalsJson) {
      final map = jsonDecode(json) as Map<String, dynamic>;
      if (map['type'] != 'Weekly') continue;

      final oldRelatedId = map['relatedYearlyGoalId'] as String?;
      final newRelatedId =
          oldRelatedId != null ? yearlyIdMap[oldRelatedId] : null;

      final goal = WeeklyGoal(
        name: map['name'] as String,
        difficulty: _migrateDifficulty(map['difficulty'] as String),
        importance: _migrateImportance(map['importance'] as String),
        status: _migrateStatus(map['status'] as String),
        notes: (map['notes'] as String?) ?? '',
        relatedYearlyGoalId: newRelatedId,
        week: map['week'] as int? ?? 1,
        year: map['year'] as int? ?? DateTime.now().year,
      );

      await weeklyRepo.insert(goal);
    }

    await prefs.setBool(_migrationCompleteKey, true);
    debugPrint(
        'Migrated goals from SharedPreferences to SQLite (split tables)');
  }
}
