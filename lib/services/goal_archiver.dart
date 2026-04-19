import '../constants/constants.dart';
import 'database/repositories/weekly_goal_repository.dart';

class GoalArchiver {
  static Future<int> archiveOldGoals(WeeklyGoalRepository repository) async {
    final now = DateTime.now();
    final currentWeek = getWeekOfYear(now);
    final currentYear = now.year;

    final oldOpenGoals =
        await repository.selectOldOpenGoals(currentYear, currentWeek);
    int archivedCount = 0;

    for (final goal in oldOpenGoals) {
      await repository.updateItem(goal.copy(status: 'Archived'));
      archivedCount++;
    }

    return archivedCount;
  }
}