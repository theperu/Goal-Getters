import 'package:sqflite/sqflite.dart';
import '../migration_base.dart';

class InitialSchema extends Migration {
  InitialSchema() : super(version: 1, description: 'Create goal table');

  @override
  Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE goal (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        importance TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'Todo 📝',
        notes TEXT NOT NULL DEFAULT '',
        type TEXT NOT NULL,
        relatedYearlyGoalId INTEGER,
        week INTEGER,
        year INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updatedAt TIMESTAMP
      )
    ''');
  }
}
