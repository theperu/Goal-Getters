import 'package:sqflite/sqflite.dart';
import '../migration_base.dart';

class AddDayOfWeek extends Migration {
  AddDayOfWeek()
      : super(
            version: 3,
            description: 'Add dayOfWeek column to weekly_goal table');

  @override
  Future<void> up(Database db) async {
    await db.execute('''
      ALTER TABLE weekly_goal ADD COLUMN dayOfWeek INTEGER
    ''');
  }
}
