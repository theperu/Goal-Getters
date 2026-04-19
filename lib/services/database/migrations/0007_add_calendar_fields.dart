import 'package:sqflite/sqflite.dart';
import '../migration_base.dart';

class AddCalendarFields extends Migration {
  AddCalendarFields()
      : super(
            version: 7,
            description: 'Add calendar event fields to weekly_goal');

  @override
  Future<void> up(Database db) async {
    await db.execute(
        '''ALTER TABLE weekly_goal ADD COLUMN calendarEventId TEXT''');
    await db.execute(
        '''ALTER TABLE weekly_goal ADD COLUMN calendarId TEXT''');
  }
}
