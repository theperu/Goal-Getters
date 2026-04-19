/// Helper to get the Monday of the ISO week containing [date].
DateTime mondayOfWeek(DateTime date) {
  final d = DateTime(date.year, date.month, date.day);
  return d.subtract(Duration(days: d.weekday - 1));
}

/// Format a DateTime to YYYY-MM-DD.
String formatDateKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Get the list of 7 date strings (Mon–Sun) for the week containing [date].
List<String> weekDatesFor(DateTime date) {
  final monday = mondayOfWeek(date);
  return List.generate(7, (i) => formatDateKey(monday.add(Duration(days: i))));
}
