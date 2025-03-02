import '../models/goal.dart';

class GoalArchiver {
  static Future<int> archiveOldGoals() async {
    final now = DateTime.now();
    final currentWeek = _getWeekOfYear(now);
    final currentYear = now.year;
    
    final goals = await GoalStorage.loadGoals();
    int archivedCount = 0;
    
    for (int i = 0; i < goals.length; i++) {
      final goal = goals[i];
      
      if (goal.type == 'Weekly' && 
          goal.week != null && 
          goal.year != null) {

        bool isOldGoal = goal.year! < currentYear || 
                        (goal.year! == currentYear && goal.week! < currentWeek);
        
        bool isOpenGoal = goal.status == 'Todo 📝' || goal.status == 'In Progress ⌛';
        
        if (isOldGoal && isOpenGoal) {
          final updatedGoal = Goal(
            id: goal.id,
            name: goal.name,
            difficulty: goal.difficulty,
            importance: goal.importance,
            status: 'Archived 🗃️',
            notes: goal.notes,
            type: goal.type,
            relatedYearlyGoalId: goal.relatedYearlyGoalId,
            week: goal.week,
            year: goal.year,
          );
          
          goals[i] = updatedGoal;
          archivedCount++;
        }
      }
    }

    if (archivedCount > 0) {
      await GoalStorage.saveGoals(goals);
    }
    
    return archivedCount;
  }
  
  static int _getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final difference = date.difference(firstDayOfYear);
    return ((difference.inDays + firstDayOfYear.weekday) / 7).ceil();
  }
}