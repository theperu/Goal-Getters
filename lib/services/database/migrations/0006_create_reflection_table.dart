import 'package:sqflite/sqflite.dart';
import '../migration_base.dart';

class CreateReflectionTable extends Migration {
  CreateReflectionTable()
      : super(version: 6, description: 'Create reflection table for journal');

  @override
  Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE reflection (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mood INTEGER NOT NULL,
        text TEXT,
        date TEXT NOT NULL UNIQUE,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updatedAt TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE UNIQUE INDEX idx_reflection_date
      ON reflection (date)
    ''');
  }
}
