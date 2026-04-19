import 'package:add_2_calendar/add_2_calendar.dart';

import '../model/weekly_goal.dart';

class CalendarService {
  static final CalendarService _instance = CalendarService._();
  factory CalendarService() => _instance;
  CalendarService._();

  /// Compute the exact date for a given ISO week number and day of week.
  /// dayOfWeek: 1=Monday, 7=Sunday (ISO 8601).
  DateTime getDateFromWeekAndDay(int year, int week, int dayOfWeek) {
    // Jan 4 is always in ISO week 1
    final jan4 = DateTime(year, 1, 4);
    // Monday of week 1
    final mondayWeek1 = jan4.subtract(Duration(days: jan4.weekday - 1));
    // Monday of the target week
    final mondayOfWeek = mondayWeek1.add(Duration(days: (week - 1) * 7));
    // Add days to reach the target day (dayOfWeek 1=Mon, so offset = dayOfWeek - 1)
    return mondayOfWeek.add(Duration(days: dayOfWeek - 1));
  }

  /// Open the native calendar app with pre-filled event info from a WeeklyGoal.
  /// Returns true if the intent was launched successfully.
  Future<bool> openCalendarWithEvent(WeeklyGoal goal) async {
    if (goal.dayOfWeek == null) return false;

    final date = getDateFromWeekAndDay(goal.year, goal.week, goal.dayOfWeek!);

    Event event;

    if (goal.timeboxStart != null && goal.timeboxStart!.isNotEmpty) {
      // Timed event
      final parts = goal.timeboxStart!.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final start = DateTime(date.year, date.month, date.day, hour, minute);
      final durationMinutes = goal.timeboxMinutes ?? 60;
      final end = start.add(Duration(minutes: durationMinutes));

      event = Event(
        title: goal.name,
        description: goal.notes.isNotEmpty ? goal.notes : null,
        startDate: start,
        endDate: end,
        allDay: false,
      );
    } else {
      // All-day event
      event = Event(
        title: goal.name,
        description: goal.notes.isNotEmpty ? goal.notes : null,
        startDate: DateTime(date.year, date.month, date.day),
        endDate: DateTime(date.year, date.month, date.day, 23, 59),
        allDay: true,
      );
    }

    return await Add2Calendar.addEvent2Cal(event);
  }
}
