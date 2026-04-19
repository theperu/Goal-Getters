import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/yearly_goal.dart';
import '../../../model/base_entity.dart';
import '../goal_getters_database.dart';

part 'yearly_goal_repository.g.dart';

@Riverpod(keepAlive: true)
YearlyGoalRepository yearlyGoalRepository(Ref ref) {
  return YearlyGoalRepository(database: ref.watch(databaseProvider));
}

class YearlyGoalRepository {
  final GoalGettersDatabase database;

  YearlyGoalRepository({required this.database});

  // ─── CREATE ───────────────────────────────────────────
  Future<YearlyGoal> insert(YearlyGoal goal) async {
    final db = await database.database;
    final id = await db.insert(
      YearlyGoalFields.tableName,
      goal.toJson(),
    );
    return goal.copy(id: id);
  }

  // ─── READ (single) ───────────────────────────────────
  Future<YearlyGoal?> selectById(int id) async {
    final db = await database.database;
    final result = await db.query(
      YearlyGoalFields.tableName,
      where: '${BaseEntityFields.id} = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return YearlyGoal.fromJson(result.first);
  }

  // ─── READ (all) ──────────────────────────────────────
  Future<List<YearlyGoal>> selectAll() async {
    final db = await database.database;
    final result = await db.query(
      YearlyGoalFields.tableName,
      orderBy: '${BaseEntityFields.id} ASC',
    );
    return result.map((json) => YearlyGoal.fromJson(json)).toList();
  }

  // ─── READ (by year) ─────────────────────────────────
  Future<List<YearlyGoal>> selectByYear(int year) async {
    final db = await database.database;
    final result = await db.query(
      YearlyGoalFields.tableName,
      where: '${YearlyGoalFields.year} = ?',
      whereArgs: [year],
      orderBy: '${BaseEntityFields.id} ASC',
    );
    return result.map((json) => YearlyGoal.fromJson(json)).toList();
  }

  // ─── READ (archived / rescheduled) ──────────────────
  Future<List<YearlyGoal>> selectArchived() async {
    final db = await database.database;
    final result = await db.query(
      YearlyGoalFields.tableName,
      where: '${YearlyGoalFields.status} IN (?, ?)',
      whereArgs: ['Archived', 'Rescheduled'],
      orderBy: '${YearlyGoalFields.year} DESC',
    );
    return result.map((json) => YearlyGoal.fromJson(json)).toList();
  }

  // ─── UPDATE ──────────────────────────────────────────
  Future<int> updateItem(YearlyGoal goal) async {
    final db = await database.database;
    return db.update(
      YearlyGoalFields.tableName,
      goal.toJson(update: true),
      where: '${BaseEntityFields.id} = ?',
      whereArgs: [goal.id],
    );
  }

  // ─── DELETE ──────────────────────────────────────────
  Future<int> deleteById(int id) async {
    final db = await database.database;
    return db.delete(
      YearlyGoalFields.tableName,
      where: '${BaseEntityFields.id} = ?',
      whereArgs: [id],
    );
  }
}
