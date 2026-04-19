import 'base_entity.dart';

class WeeklyGoalFields extends BaseEntityFields {
  static const String tableName = 'weekly_goal';
  static const String name = 'name';
  static const String difficulty = 'difficulty';
  static const String importance = 'importance';
  static const String status = 'status';
  static const String notes = 'notes';
  static const String relatedYearlyGoalId = 'relatedYearlyGoalId';
  static const String week = 'week';
  static const String year = 'year';
  static const String timeboxStart = 'timeboxStart';
  static const String timeboxMinutes = 'timeboxMinutes';
  static const String dayOfWeek = 'dayOfWeek';
  static const String calendarEventId = 'calendarEventId';
  static const String calendarId = 'calendarId';
}

class WeeklyGoal extends BaseEntity {
  final String name;
  final String difficulty;
  final String importance;
  final String status;
  final String notes;
  final int? relatedYearlyGoalId;
  final int week;
  final int year;
  final String? timeboxStart;
  final int? timeboxMinutes;
  final int? dayOfWeek;
  final String? calendarEventId;
  final String? calendarId;

  WeeklyGoal({
    super.id,
    required this.name,
    required this.difficulty,
    required this.importance,
    required this.status,
    this.notes = '',
    this.relatedYearlyGoalId,
    required this.week,
    required this.year,
    this.timeboxStart,
    this.timeboxMinutes,
    this.dayOfWeek,
    this.calendarEventId,
    this.calendarId,
    super.createdAt,
    super.updatedAt,
  });

  WeeklyGoal copy({
    int? id,
    String? name,
    String? difficulty,
    String? importance,
    String? status,
    String? notes,
    int? relatedYearlyGoalId,
    bool clearRelatedYearlyGoalId = false,
    int? week,
    int? year,
    String? timeboxStart,
    bool clearTimeboxStart = false,
    int? timeboxMinutes,
    bool clearTimeboxMinutes = false,
    int? dayOfWeek,
    bool clearDayOfWeek = false,
    String? calendarEventId,
    bool clearCalendarEventId = false,
    String? calendarId,
    bool clearCalendarId = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      WeeklyGoal(
        id: id ?? this.id,
        name: name ?? this.name,
        difficulty: difficulty ?? this.difficulty,
        importance: importance ?? this.importance,
        status: status ?? this.status,
        notes: notes ?? this.notes,
        relatedYearlyGoalId: clearRelatedYearlyGoalId
            ? null
            : (relatedYearlyGoalId ?? this.relatedYearlyGoalId),
        week: week ?? this.week,
        year: year ?? this.year,
        timeboxStart:
            clearTimeboxStart ? null : (timeboxStart ?? this.timeboxStart),
        timeboxMinutes: clearTimeboxMinutes
            ? null
            : (timeboxMinutes ?? this.timeboxMinutes),
        dayOfWeek:
            clearDayOfWeek ? null : (dayOfWeek ?? this.dayOfWeek),
        calendarEventId: clearCalendarEventId
            ? null
            : (calendarEventId ?? this.calendarEventId),
        calendarId:
            clearCalendarId ? null : (calendarId ?? this.calendarId),
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  static WeeklyGoal fromJson(Map<String, Object?> json) => WeeklyGoal(
        id: json[BaseEntityFields.id] as int?,
        name: json[WeeklyGoalFields.name] as String,
        difficulty: json[WeeklyGoalFields.difficulty] as String,
        importance: json[WeeklyGoalFields.importance] as String,
        status: json[WeeklyGoalFields.status] as String,
        notes: (json[WeeklyGoalFields.notes] as String?) ?? '',
        relatedYearlyGoalId:
            json[WeeklyGoalFields.relatedYearlyGoalId] as int?,
        week: json[WeeklyGoalFields.week] as int,
        year: json[WeeklyGoalFields.year] as int,
        timeboxStart: json[WeeklyGoalFields.timeboxStart] as String?,
        timeboxMinutes: json[WeeklyGoalFields.timeboxMinutes] as int?,
        dayOfWeek: json[WeeklyGoalFields.dayOfWeek] as int?,
        calendarEventId:
            json[WeeklyGoalFields.calendarEventId] as String?,
        calendarId: json[WeeklyGoalFields.calendarId] as String?,
        createdAt: json[BaseEntityFields.createdAt] != null
            ? DateTime.parse(json[BaseEntityFields.createdAt] as String)
            : null,
        updatedAt: json[BaseEntityFields.updatedAt] != null
            ? DateTime.parse(json[BaseEntityFields.updatedAt] as String)
            : null,
      );

  Map<String, Object?> toJson({bool update = false}) => {
        if (update) BaseEntityFields.id: id,
        WeeklyGoalFields.name: name,
        WeeklyGoalFields.difficulty: difficulty,
        WeeklyGoalFields.importance: importance,
        WeeklyGoalFields.status: status,
        WeeklyGoalFields.notes: notes,
        WeeklyGoalFields.relatedYearlyGoalId: relatedYearlyGoalId,
        WeeklyGoalFields.week: week,
        WeeklyGoalFields.year: year,
        WeeklyGoalFields.timeboxStart: timeboxStart,
        WeeklyGoalFields.timeboxMinutes: timeboxMinutes,
        WeeklyGoalFields.dayOfWeek: dayOfWeek,
        WeeklyGoalFields.calendarEventId: calendarEventId,
        WeeklyGoalFields.calendarId: calendarId,
        BaseEntityFields.createdAt: update
            ? createdAt?.toIso8601String()
            : DateTime.now().toIso8601String(),
        BaseEntityFields.updatedAt:
            update ? DateTime.now().toIso8601String() : null,
      };
}
