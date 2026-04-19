import 'base_entity.dart';

class GoalFields extends BaseEntityFields {
  static const String tableName = 'goal';
  static const String name = 'name';
  static const String difficulty = 'difficulty';
  static const String importance = 'importance';
  static const String status = 'status';
  static const String notes = 'notes';
  static const String type = 'type';
  static const String relatedYearlyGoalId = 'relatedYearlyGoalId';
  static const String week = 'week';
  static const String year = 'year';
}

class Goal extends BaseEntity {
  final String name;
  final String difficulty;
  final String importance;
  final String status;
  final String notes;
  final String type;
  final int? relatedYearlyGoalId;
  final int? week;
  final int? year;

  Goal({
    super.id,
    required this.name,
    required this.difficulty,
    required this.importance,
    required this.status,
    this.notes = '',
    required this.type,
    this.relatedYearlyGoalId,
    this.week,
    this.year,
    super.createdAt,
    super.updatedAt,
  });

  Goal copy({
    int? id,
    String? name,
    String? difficulty,
    String? importance,
    String? status,
    String? notes,
    String? type,
    int? relatedYearlyGoalId,
    bool clearRelatedYearlyGoalId = false,
    int? week,
    bool clearWeek = false,
    int? year,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Goal(
        id: id ?? this.id,
        name: name ?? this.name,
        difficulty: difficulty ?? this.difficulty,
        importance: importance ?? this.importance,
        status: status ?? this.status,
        notes: notes ?? this.notes,
        type: type ?? this.type,
        relatedYearlyGoalId: clearRelatedYearlyGoalId
            ? null
            : (relatedYearlyGoalId ?? this.relatedYearlyGoalId),
        week: clearWeek ? null : (week ?? this.week),
        year: year ?? this.year,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  static Goal fromJson(Map<String, Object?> json) => Goal(
        id: json[BaseEntityFields.id] as int?,
        name: json[GoalFields.name] as String,
        difficulty: json[GoalFields.difficulty] as String,
        importance: json[GoalFields.importance] as String,
        status: json[GoalFields.status] as String,
        notes: (json[GoalFields.notes] as String?) ?? '',
        type: json[GoalFields.type] as String,
        relatedYearlyGoalId: json[GoalFields.relatedYearlyGoalId] as int?,
        week: json[GoalFields.week] as int?,
        year: json[GoalFields.year] as int?,
        createdAt: json[BaseEntityFields.createdAt] != null
            ? DateTime.parse(json[BaseEntityFields.createdAt] as String)
            : null,
        updatedAt: json[BaseEntityFields.updatedAt] != null
            ? DateTime.parse(json[BaseEntityFields.updatedAt] as String)
            : null,
      );

  Map<String, Object?> toJson({bool update = false}) => {
        if (update) BaseEntityFields.id: id,
        GoalFields.name: name,
        GoalFields.difficulty: difficulty,
        GoalFields.importance: importance,
        GoalFields.status: status,
        GoalFields.notes: notes,
        GoalFields.type: type,
        GoalFields.relatedYearlyGoalId: relatedYearlyGoalId,
        GoalFields.week: week,
        GoalFields.year: year,
        BaseEntityFields.createdAt: update
            ? createdAt?.toIso8601String()
            : DateTime.now().toIso8601String(),
        BaseEntityFields.updatedAt:
            update ? DateTime.now().toIso8601String() : null,
      };
}
