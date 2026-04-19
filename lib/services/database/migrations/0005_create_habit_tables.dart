import 'package:sqflite/sqflite.dart';
import '../migration_base.dart';

class CreateHabitTables extends Migration {
  CreateHabitTables()
      : super(
            version: 5,
            description: 'Create habit and habit_completion tables');

  @override
  Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE habit (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        icon TEXT,
        color TEXT NOT NULL,
        timesPerWeek INTEGER NOT NULL DEFAULT 7,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updatedAt TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE habit_completion (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        habitId INTEGER NOT NULL,
        date TEXT NOT NULL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updatedAt TIMESTAMP,
        FOREIGN KEY (habitId) REFERENCES habit(id) ON DELETE CASCADE,
        UNIQUE (habitId, date)
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_habit_completion_habit_date
      ON habit_completion (habitId, date)
    ''');
  }
}
