import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/reflection.dart';
import '../../../model/base_entity.dart';
import '../goal_getters_database.dart';

part 'reflection_repository.g.dart';

@Riverpod(keepAlive: true)
ReflectionRepository reflectionRepository(Ref ref) {
  return ReflectionRepository(database: ref.watch(databaseProvider));
}

class ReflectionRepository {
  final GoalGettersDatabase database;

  ReflectionRepository({required this.database});

  Future<Reflection> insert(Reflection reflection) async {
    final db = await database.database;
    final id = await db.insert(ReflectionFields.tableName, reflection.toJson());
    return reflection.copy(id: id);
  }

  Future<Reflection?> selectByDate(String date) async {
    final db = await database.database;
    final result = await db.query(
      ReflectionFields.tableName,
      where: '${ReflectionFields.date} = ?',
      whereArgs: [date],
    );
    if (result.isEmpty) return null;
    return Reflection.fromJson(result.first);
  }

  Future<List<Reflection>> selectAll() async {
    final db = await database.database;
    final result = await db.query(
      ReflectionFields.tableName,
      orderBy: '${ReflectionFields.date} DESC',
    );
    return result.map((json) => Reflection.fromJson(json)).toList();
  }

  Future<List<Reflection>> selectRecent({int limit = 10}) async {
    final db = await database.database;
    final result = await db.query(
      ReflectionFields.tableName,
      orderBy: '${ReflectionFields.date} DESC',
      limit: limit,
    );
    return result.map((json) => Reflection.fromJson(json)).toList();
  }

  Future<List<Reflection>> selectByMonth(int year, int month) async {
    final db = await database.database;
    final startDate =
        '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-01';
    final endDate =
        '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-31';
    final result = await db.query(
      ReflectionFields.tableName,
      where:
          '${ReflectionFields.date} >= ? AND ${ReflectionFields.date} <= ?',
      whereArgs: [startDate, endDate],
      orderBy: '${ReflectionFields.date} ASC',
    );
    return result.map((json) => Reflection.fromJson(json)).toList();
  }

  Future<int> update(Reflection reflection) async {
    final db = await database.database;
    return db.update(
      ReflectionFields.tableName,
      reflection.toJson(update: true),
      where: '${BaseEntityFields.id} = ?',
      whereArgs: [reflection.id],
    );
  }

  Future<int> deleteById(int id) async {
    final db = await database.database;
    return db.delete(
      ReflectionFields.tableName,
      where: '${BaseEntityFields.id} = ?',
      whereArgs: [id],
    );
  }
}
