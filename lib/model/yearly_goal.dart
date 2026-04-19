import 'base_entity.dart';

class YearlyGoalFields extends BaseEntityFields {
  static const String tableName = 'yearly_goal';
  static const String name = 'name';
  static const String difficulty = 'difficulty';
  static const String importance = 'importance';
  static const String status = 'status';
  static const String notes = 'notes';
  static const String year = 'year';
  static const String icon = 'icon';
}

class YearlyGoal extends BaseEntity {
  final String name;
  final String difficulty;
  final String importance;
  final String status;
  final String notes;
  final int year;
  final String? icon;

  YearlyGoal({
    super.id,
    required this.name,
    required this.difficulty,
    required this.importance,
    required this.status,
    this.notes = '',
    required this.year,
    this.icon,
    super.createdAt,
    super.updatedAt,
  });

  YearlyGoal copy({
    int? id,
    String? name,
    String? difficulty,
    String? importance,
    String? status,
    String? notes,
    int? year,
    String? icon,
    bool clearIcon = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      YearlyGoal(
        id: id ?? this.id,
        name: name ?? this.name,
        difficulty: difficulty ?? this.difficulty,
        importance: importance ?? this.importance,
        status: status ?? this.status,
        notes: notes ?? this.notes,
        year: year ?? this.year,
        icon: clearIcon ? null : (icon ?? this.icon),
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  static YearlyGoal fromJson(Map<String, Object?> json) => YearlyGoal(
        id: json[BaseEntityFields.id] as int?,
        name: json[YearlyGoalFields.name] as String,
        difficulty: json[YearlyGoalFields.difficulty] as String,
        importance: json[YearlyGoalFields.importance] as String,
        status: json[YearlyGoalFields.status] as String,
        notes: (json[YearlyGoalFields.notes] as String?) ?? '',
        year: json[YearlyGoalFields.year] as int,
        icon: json[YearlyGoalFields.icon] as String?,
        createdAt: json[BaseEntityFields.createdAt] != null
            ? DateTime.parse(json[BaseEntityFields.createdAt] as String)
            : null,
        updatedAt: json[BaseEntityFields.updatedAt] != null
            ? DateTime.parse(json[BaseEntityFields.updatedAt] as String)
            : null,
      );

  Map<String, Object?> toJson({bool update = false}) => {
        if (update) BaseEntityFields.id: id,
        YearlyGoalFields.name: name,
        YearlyGoalFields.difficulty: difficulty,
        YearlyGoalFields.importance: importance,
        YearlyGoalFields.status: status,
        YearlyGoalFields.notes: notes,
        YearlyGoalFields.year: year,
        YearlyGoalFields.icon: icon,
        BaseEntityFields.createdAt: update
            ? createdAt?.toIso8601String()
            : DateTime.now().toIso8601String(),
        BaseEntityFields.updatedAt:
            update ? DateTime.now().toIso8601String() : null,
      };
}
