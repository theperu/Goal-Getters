import 'package:sqflite/sqflite.dart';
import '../migration_base.dart';

class SplitGoalTables extends Migration {
  SplitGoalTables()
      : super(
            version: 2,
            description:
                'Split goal table into weekly_goal and yearly_goal, remove emojis from statuses, add timebox fields');

  /// Map old emoji statuses to new plain-text statuses
  static String _migrateStatus(String old) {
    switch (old) {
      case 'Todo 📝':
        return 'Todo';
      case 'In Progress ⌛':
        return 'In Progress';
      case 'Done ✅':
        return 'Done';
      case 'Blocked ⛔':
        return 'Blocked';
      case 'Archived 🗃️':
        return 'Archived';
      case 'Rescheduled 🔄':
        return 'Rescheduled';
      default:
        return old;
    }
  }

  /// Map old emoji importance to plain text
  static String _migrateImportance(String old) {
    switch (old) {
      case 'Low 🌱':
        return 'Low';
      case 'Medium 🌿':
        return 'Medium';
      case 'High 🌳':
        return 'High';
      default:
        return old;
    }
  }

  /// Map old star difficulty to numeric string
  static String _migrateDifficulty(String old) {
    final count = old.codeUnits.where((c) => c == 0x2B50).length;
    if (count > 0) return count.toString();
    return old;
  }

  @override
  Future<void> up(Database db) async {
    // Create the new weekly_goal table
    await db.execute('''
      CREATE TABLE weekly_goal (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        importance TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'Todo',
        notes TEXT NOT NULL DEFAULT '',
        relatedYearlyGoalId INTEGER,
        week INTEGER NOT NULL,
        year INTEGER NOT NULL,
        timeboxStart TEXT,
        timeboxMinutes INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updatedAt TIMESTAMP
      )
    ''');

    // Create the new yearly_goal table
    await db.execute('''
      CREATE TABLE yearly_goal (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        importance TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'Todo',
        notes TEXT NOT NULL DEFAULT '',
        year INTEGER NOT NULL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updatedAt TIMESTAMP
      )
    ''');

    // Migrate yearly goals first (so we can map old IDs to new IDs)
    final yearlyRows = await db.query('goal',
        where: "type = ?", whereArgs: ['Yearly'], orderBy: 'id ASC');

    final Map<int, int> yearlyIdMap = {}; // old id -> new id

    for (final row in yearlyRows) {
      final newId = await db.insert('yearly_goal', {
        'name': row['name'],
        'difficulty': _migrateDifficulty(row['difficulty'] as String),
        'importance': _migrateImportance(row['importance'] as String),
        'status': _migrateStatus(row['status'] as String),
        'notes': row['notes'] ?? '',
        'year': row['year'] ?? DateTime.now().year,
        'createdAt': row['createdAt'],
        'updatedAt': row['updatedAt'],
      });
      yearlyIdMap[row['id'] as int] = newId;
    }

    // Migrate weekly goals, remapping relatedYearlyGoalId
    final weeklyRows = await db.query('goal',
        where: "type = ?", whereArgs: ['Weekly'], orderBy: 'id ASC');

    for (final row in weeklyRows) {
      final oldRelatedId = row['relatedYearlyGoalId'] as int?;
      final newRelatedId =
          oldRelatedId != null ? yearlyIdMap[oldRelatedId] : null;

      await db.insert('weekly_goal', {
        'name': row['name'],
        'difficulty': _migrateDifficulty(row['difficulty'] as String),
        'importance': _migrateImportance(row['importance'] as String),
        'status': _migrateStatus(row['status'] as String),
        'notes': row['notes'] ?? '',
        'relatedYearlyGoalId': newRelatedId,
        'week': row['week'] ?? 1,
        'year': row['year'] ?? DateTime.now().year,
        'timeboxStart': null,
        'timeboxMinutes': null,
        'createdAt': row['createdAt'],
        'updatedAt': row['updatedAt'],
      });
    }

    // Drop the old table
    await db.execute('DROP TABLE IF EXISTS goal');
  }
}
