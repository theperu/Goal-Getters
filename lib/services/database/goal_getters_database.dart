import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'migration_manager.dart';
import 'migrations/migration_registry.dart';

part 'goal_getters_database.g.dart';

@Riverpod(keepAlive: true)
GoalGettersDatabase database(Ref ref) {
  return GoalGettersDatabase.instance;
}

class GoalGettersDatabase {
  static final GoalGettersDatabase instance = GoalGettersDatabase._init();
  static Database? _database;

  GoalGettersDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('goal_getters.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: MigrationRegistry.getLatestVersion(),
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await MigrationManager.migrate(db, 0, version);
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    await MigrationManager.migrate(db, oldVersion, newVersion);
  }

  /// Closes the database and clears the cached instance so it can be re-opened.
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
