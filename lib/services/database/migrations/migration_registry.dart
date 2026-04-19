import '../migration_base.dart';
import '0001_initial_schema.dart';
import '0002_split_goal_tables.dart';
import '0003_add_day_of_week.dart';
import '0004_add_icon_to_yearly_goal.dart';
import '0005_create_habit_tables.dart';
import '0006_create_reflection_table.dart';
import '0007_add_calendar_fields.dart';

class MigrationRegistry {
  static List<Migration> getMigrations() {
    return [
      InitialSchema(),
      SplitGoalTables(),
      AddDayOfWeek(),
      AddIconToYearlyGoal(),
      CreateHabitTables(),
      CreateReflectionTable(),
      AddCalendarFields(),
    ];
  }

  static int getLatestVersion() {
    return getMigrations()
        .map((m) => m.version)
        .reduce((a, b) => a > b ? a : b);
  }
}
