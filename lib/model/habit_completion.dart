import 'base_entity.dart';

class HabitCompletionFields extends BaseEntityFields {
  static const String tableName = 'habit_completion';
  static const String habitId = 'habitId';
  static const String date = 'date';
}

class HabitCompletion extends BaseEntity {
  final int habitId;
  final String date; // YYYY-MM-DD

  HabitCompletion({
    super.id,
    required this.habitId,
    required this.date,
    super.createdAt,
    super.updatedAt,
  });

  HabitCompletion copy({
    int? id,
    int? habitId,
    String? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      HabitCompletion(
        id: id ?? this.id,
        habitId: habitId ?? this.habitId,
        date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  static HabitCompletion fromJson(Map<String, Object?> json) =>
      HabitCompletion(
        id: json[BaseEntityFields.id] as int?,
        habitId: json[HabitCompletionFields.habitId] as int,
        date: json[HabitCompletionFields.date] as String,
        createdAt: json[BaseEntityFields.createdAt] != null
            ? DateTime.parse(json[BaseEntityFields.createdAt] as String)
            : null,
        updatedAt: json[BaseEntityFields.updatedAt] != null
            ? DateTime.parse(json[BaseEntityFields.updatedAt] as String)
            : null,
      );

  Map<String, Object?> toJson({bool update = false}) => {
        if (update) BaseEntityFields.id: id,
        HabitCompletionFields.habitId: habitId,
        HabitCompletionFields.date: date,
        BaseEntityFields.createdAt: update
            ? createdAt?.toIso8601String()
            : DateTime.now().toIso8601String(),
        BaseEntityFields.updatedAt:
            update ? DateTime.now().toIso8601String() : null,
      };
}
