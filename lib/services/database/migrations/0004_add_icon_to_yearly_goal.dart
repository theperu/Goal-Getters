import 'package:sqflite/sqflite.dart';
import '../migration_base.dart';

class AddIconToYearlyGoal extends Migration {
  AddIconToYearlyGoal()
      : super(
            version: 4,
            description: 'Add icon column to yearly_goal table');

  @override
  Future<void> up(Database db) async {
    await db.execute('''
      ALTER TABLE yearly_goal ADD COLUMN icon TEXT
    ''');
  }
}
