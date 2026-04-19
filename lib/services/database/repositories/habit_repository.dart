import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/habit.dart';
import '../../../model/habit_completion.dart';
import '../../../model/base_entity.dart';
import '../goal_getters_database.dart';

part 'habit_repository.g.dart';

@Riverpod(keepAlive: true)
HabitRepository habitRepository(Ref ref) {
  return HabitRepository(database: ref.watch(databaseProvider));
}

class HabitRepository {
  final GoalGettersDatabase database;

  HabitRepository({required this.database});

  // ─── HABIT CRUD ───────────────────────────────────────

  Future<Habit> insertHabit(Habit habit) async {
    final db = await database.database;
    final id = await db.insert(HabitFields.tableName, habit.toJson());
    return habit.copy(id: id);
  }

  Future<List<Habit>> selectAllHabits() async {
    final db = await database.database;
    final result = await db.query(
      HabitFields.tableName,
      orderBy: '${BaseEntityFields.id} ASC',
    );
    return result.map((json) => Habit.fromJson(json)).toList();
  }

  Future<Habit?> selectHabitById(int id) async {
    final db = await database.database;
    final result = await db.query(
      HabitFields.tableName,
      where: '${BaseEntityFields.id} = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return Habit.fromJson(result.first);
  }

  Future<int> updateHabit(Habit habit) async {
    final db = await database.database;
    return db.update(
      HabitFields.tableName,
      habit.toJson(update: true),
      where: '${BaseEntityFields.id} = ?',
      whereArgs: [habit.id],
    );
  }

  Future<int> deleteHabit(int id) async {
    final db = await database.database;
    return db.delete(
      HabitFields.tableName,
      where: '${BaseEntityFields.id} = ?',
      whereArgs: [id],
    );
  }

  // ─── COMPLETION CRUD ─────────────────────────────────

  Future<HabitCompletion> insertCompletion(HabitCompletion completion) async {
    final db = await database.database;
    final id = await db.insert(
      HabitCompletionFields.tableName,
      completion.toJson(),
    );
    return completion.copy(id: id);
  }

  Future<void> deleteCompletion(int habitId, String date) async {
    final db = await database.database;
    await db.delete(
      HabitCompletionFields.tableName,
      where:
          '${HabitCompletionFields.habitId} = ? AND ${HabitCompletionFields.date} = ?',
      whereArgs: [habitId, date],
    );
  }

  /// Get all completions for a habit within a date range (inclusive).
  Future<List<HabitCompletion>> selectCompletionsForRange(
      int habitId, String startDate, String endDate) async {
    final db = await database.database;
    final result = await db.query(
      HabitCompletionFields.tableName,
      where:
          '${HabitCompletionFields.habitId} = ? AND ${HabitCompletionFields.date} >= ? AND ${HabitCompletionFields.date} <= ?',
      whereArgs: [habitId, startDate, endDate],
      orderBy: '${HabitCompletionFields.date} ASC',
    );
    return result.map((json) => HabitCompletion.fromJson(json)).toList();
  }

  /// Get all completions for all habits within a date range (inclusive).
  Future<List<HabitCompletion>> selectAllCompletionsForRange(
      String startDate, String endDate) async {
    final db = await database.database;
    final result = await db.query(
      HabitCompletionFields.tableName,
      where:
          '${HabitCompletionFields.date} >= ? AND ${HabitCompletionFields.date} <= ?',
      whereArgs: [startDate, endDate],
      orderBy: '${HabitCompletionFields.date} ASC',
    );
    return result.map((json) => HabitCompletion.fromJson(json)).toList();
  }

  /// Get all completions for a specific habit.
  Future<List<HabitCompletion>> selectAllCompletionsForHabit(
      int habitId) async {
    final db = await database.database;
    final result = await db.query(
      HabitCompletionFields.tableName,
      where: '${HabitCompletionFields.habitId} = ?',
      whereArgs: [habitId],
      orderBy: '${HabitCompletionFields.date} ASC',
    );
    return result.map((json) => HabitCompletion.fromJson(json)).toList();
  }
}
