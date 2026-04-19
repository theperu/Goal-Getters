import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/weekly_goal.dart';
import '../../../model/base_entity.dart';
import '../goal_getters_database.dart';

part 'weekly_goal_repository.g.dart';

@Riverpod(keepAlive: true)
WeeklyGoalRepository weeklyGoalRepository(Ref ref) {
  return WeeklyGoalRepository(database: ref.watch(databaseProvider));
}

class WeeklyGoalRepository {
  final GoalGettersDatabase database;

  WeeklyGoalRepository({required this.database});

  // ─── CREATE ───────────────────────────────────────────
  Future<WeeklyGoal> insert(WeeklyGoal goal) async {
    final db = await database.database;
    final id = await db.insert(
      WeeklyGoalFields.tableName,
      goal.toJson(),
    );
    return goal.copy(id: id);
  }

  // ─── READ (single) ───────────────────────────────────
  Future<WeeklyGoal?> selectById(int id) async {
    final db = await database.database;
    final result = await db.query(
      WeeklyGoalFields.tableName,
      where: '${BaseEntityFields.id} = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return WeeklyGoal.fromJson(result.first);
  }

  // ─── READ (all) ──────────────────────────────────────
  Future<List<WeeklyGoal>> selectAll() async {
    final db = await database.database;
    final result = await db.query(
      WeeklyGoalFields.tableName,
      orderBy: '${BaseEntityFields.id} ASC',
    );
    return result.map((json) => WeeklyGoal.fromJson(json)).toList();
  }

  // ─── READ (by week) ─────────────────────────────────
  Future<List<WeeklyGoal>> selectByWeek(int year, int week) async {
    final db = await database.database;
    final result = await db.query(
      WeeklyGoalFields.tableName,
      where:
          '${WeeklyGoalFields.year} = ? AND ${WeeklyGoalFields.week} = ?',
      whereArgs: [year, week],
      orderBy: '${BaseEntityFields.id} ASC',
    );
    return result.map((json) => WeeklyGoal.fromJson(json)).toList();
  }

  // ─── READ (all weekly goals for a year) ──────────────
  Future<List<WeeklyGoal>> selectAllForYear(int year) async {
    final db = await database.database;
    final result = await db.query(
      WeeklyGoalFields.tableName,
      where: '${WeeklyGoalFields.year} = ?',
      whereArgs: [year],
      orderBy: '${WeeklyGoalFields.week} ASC, ${BaseEntityFields.id} ASC',
    );
    return result.map((json) => WeeklyGoal.fromJson(json)).toList();
  }

  // ─── READ (archived / rescheduled) ──────────────────
  Future<List<WeeklyGoal>> selectArchived() async {
    final db = await database.database;
    final result = await db.query(
      WeeklyGoalFields.tableName,
      where: '${WeeklyGoalFields.status} IN (?, ?)',
      whereArgs: ['Archived', 'Rescheduled'],
      orderBy: '${WeeklyGoalFields.year} DESC, ${WeeklyGoalFields.week} DESC',
    );
    return result.map((json) => WeeklyGoal.fromJson(json)).toList();
  }

  // ─── READ (open weekly goals older than given week) ──
  Future<List<WeeklyGoal>> selectOldOpenGoals(int year, int week) async {
    final db = await database.database;
    final result = await db.rawQuery('''
      SELECT * FROM ${WeeklyGoalFields.tableName}
      WHERE (${WeeklyGoalFields.status} = 'Todo' OR ${WeeklyGoalFields.status} = 'In Progress')
        AND (
          ${WeeklyGoalFields.year} < ?
          OR (${WeeklyGoalFields.year} = ? AND ${WeeklyGoalFields.week} < ?)
        )
    ''', [year, year, week]);
    return result.map((json) => WeeklyGoal.fromJson(json)).toList();
  }

  // ─── UPDATE ──────────────────────────────────────────
  Future<int> updateItem(WeeklyGoal goal) async {
    final db = await database.database;
    return db.update(
      WeeklyGoalFields.tableName,
      goal.toJson(update: true),
      where: '${BaseEntityFields.id} = ?',
      whereArgs: [goal.id],
    );
  }

  // ─── DELETE ──────────────────────────────────────────
  Future<int> deleteById(int id) async {
    final db = await database.database;
    return db.delete(
      WeeklyGoalFields.tableName,
      where: '${BaseEntityFields.id} = ?',
      whereArgs: [id],
    );
  }
}
