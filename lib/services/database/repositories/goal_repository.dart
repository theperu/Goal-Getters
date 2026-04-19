import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/goal.dart';
import '../../../model/base_entity.dart';
import '../goal_getters_database.dart';

part 'goal_repository.g.dart';

@Riverpod(keepAlive: true)
GoalRepository goalRepository(Ref ref) {
  return GoalRepository(database: ref.watch(databaseProvider));
}

class GoalRepository {
  final GoalGettersDatabase database;

  GoalRepository({required this.database});

  // ─── CREATE ───────────────────────────────────────────
  Future<Goal> insert(Goal goal) async {
    final db = await database.database;
    final id = await db.insert(
      GoalFields.tableName,
      goal.toJson(),
    );
    return goal.copy(id: id);
  }

  // ─── READ (single) ───────────────────────────────────
  Future<Goal?> selectById(int id) async {
    final db = await database.database;
    final result = await db.query(
      GoalFields.tableName,
      where: '${BaseEntityFields.id} = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return Goal.fromJson(result.first);
  }

  // ─── READ (all) ──────────────────────────────────────
  Future<List<Goal>> selectAll() async {
    final db = await database.database;
    final result = await db.query(
      GoalFields.tableName,
      orderBy: '${BaseEntityFields.id} ASC',
    );
    return result.map((json) => Goal.fromJson(json)).toList();
  }

  // ─── READ (by week) ─────────────────────────────────
  Future<List<Goal>> selectByWeek(int year, int week) async {
    final db = await database.database;
    final result = await db.query(
      GoalFields.tableName,
      where:
          '${GoalFields.type} = ? AND ${GoalFields.year} = ? AND ${GoalFields.week} = ?',
      whereArgs: ['Weekly', year, week],
      orderBy: '${BaseEntityFields.id} ASC',
    );
    return result.map((json) => Goal.fromJson(json)).toList();
  }

  // ─── READ (by year — yearly goals) ──────────────────
  Future<List<Goal>> selectYearlyGoals(int year) async {
    final db = await database.database;
    final result = await db.query(
      GoalFields.tableName,
      where: '${GoalFields.type} = ? AND ${GoalFields.year} = ?',
      whereArgs: ['Yearly', year],
      orderBy: '${BaseEntityFields.id} ASC',
    );
    return result.map((json) => Goal.fromJson(json)).toList();
  }

  // ─── READ (all weekly goals for a year) ──────────────
  Future<List<Goal>> selectAllWeeklyForYear(int year) async {
    final db = await database.database;
    final result = await db.query(
      GoalFields.tableName,
      where: '${GoalFields.type} = ? AND ${GoalFields.year} = ?',
      whereArgs: ['Weekly', year],
      orderBy: '${GoalFields.week} ASC, ${BaseEntityFields.id} ASC',
    );
    return result.map((json) => Goal.fromJson(json)).toList();
  }

  // ─── READ (archived / rescheduled) ──────────────────
  Future<List<Goal>> selectArchived() async {
    final db = await database.database;
    final result = await db.query(
      GoalFields.tableName,
      where: '${GoalFields.status} IN (?, ?)',
      whereArgs: ['Archived 🗃️', 'Rescheduled 🔄'],
      orderBy: '${GoalFields.year} DESC, ${GoalFields.week} DESC',
    );
    return result.map((json) => Goal.fromJson(json)).toList();
  }

  // ─── READ (open weekly goals older than given week) ──
  Future<List<Goal>> selectOldOpenWeeklyGoals(int year, int week) async {
    final db = await database.database;
    final result = await db.rawQuery('''
      SELECT * FROM ${GoalFields.tableName}
      WHERE ${GoalFields.type} = 'Weekly'
        AND (${GoalFields.status} = 'Todo 📝' OR ${GoalFields.status} = 'In Progress ⌛')
        AND (
          ${GoalFields.year} < ?
          OR (${GoalFields.year} = ? AND ${GoalFields.week} < ?)
        )
    ''', [year, year, week]);
    return result.map((json) => Goal.fromJson(json)).toList();
  }

  // ─── UPDATE ──────────────────────────────────────────
  Future<int> updateItem(Goal goal) async {
    final db = await database.database;
    return db.update(
      GoalFields.tableName,
      goal.toJson(update: true),
      where: '${BaseEntityFields.id} = ?',
      whereArgs: [goal.id],
    );
  }

  // ─── DELETE ──────────────────────────────────────────
  Future<int> deleteById(int id) async {
    final db = await database.database;
    return db.delete(
      GoalFields.tableName,
      where: '${BaseEntityFields.id} = ?',
      whereArgs: [id],
    );
  }
}
