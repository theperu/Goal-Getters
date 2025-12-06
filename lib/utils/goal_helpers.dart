import 'package:flutter/material.dart';
import 'styles.dart';

/// Status color mapping for goal statuses
const Map<String, Color> kStatusColors = statusBgColorMap;

/// Status badge colors (for chips and indicators)
const Map<String, Color> kStatusBadgeColors = statusColorMap;

/// List of all available statuses
const List<String> kStatusOptions = [
  'Todo 📝',
  'In Progress ⌛',
  'Done ✅',
  'Blocked ⛔',
  'Archived 🗃️',
  'Rescheduled 🔄',
];

/// Priority colors mapping
const Map<String, Color> kPriorityColors = priorityColorMap;

/// Get the color for a status badge/chip
Color getStatusColor(String status) {
  return kStatusBadgeColors[status] ?? statusTodo;
}

/// Get the background color for a goal card based on status
Color getStatusBackgroundColor(String status) {
  return kStatusColors[status] ?? statusTodo;
}

/// Get difficulty level as integer from star string (e.g., '⭐⭐⭐' -> 3)
int getDifficultyLevel(String difficulty) {
  return difficulty.split('⭐').length - 1;
}

/// Get priority text without emojis
String getPriorityText(String importance) {
  return importance
      .replaceAll('🌱', '')
      .replaceAll('🌿', '')
      .replaceAll('🌳', '')
      .trim();
}

/// Get priority color based on importance level
Color getPriorityColor(String importance) {
  return kPriorityColors[importance] ?? priorityLow;
}

/// Calculate the week number of the year for a given date
int getWeekOfYear(DateTime date) {
  final firstDayOfYear = DateTime(date.year, 1, 1);
  final difference = date.difference(firstDayOfYear);
  return ((difference.inDays + firstDayOfYear.weekday) / 7).ceil();
}

/// Format a date range for a specific week
String formatWeekRange(int year, int week) {
  final firstDayOfYear = DateTime(year, 1, 1);
  final dayOffset = firstDayOfYear.weekday - 1;
  final weekStart = firstDayOfYear.add(Duration(days: (week - 1) * 7 - dayOffset));
  final weekEnd = weekStart.add(const Duration(days: 6));

  return '${_formatDate(weekStart)} - ${_formatDate(weekEnd)}';
}

String _formatDate(DateTime date) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return '${months[date.month - 1]} ${date.day}';
}

/// Get month name from month number
String getMonthName(int month) {
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  return months[month - 1];
}
