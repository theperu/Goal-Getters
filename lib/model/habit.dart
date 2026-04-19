import 'base_entity.dart';

class HabitFields extends BaseEntityFields {
  static const String tableName = 'habit';
  static const String name = 'name';
  static const String icon = 'icon';
  static const String color = 'color';
  static const String timesPerWeek = 'timesPerWeek';
}

class Habit extends BaseEntity {
  final String name;
  final String? icon;
  final String color;
  final int timesPerWeek;

  Habit({
    super.id,
    required this.name,
    this.icon,
    required this.color,
    required this.timesPerWeek,
    super.createdAt,
    super.updatedAt,
  });

  Habit copy({
    int? id,
    String? name,
    String? icon,
    bool clearIcon = false,
    String? color,
    int? timesPerWeek,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Habit(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: clearIcon ? null : (icon ?? this.icon),
        color: color ?? this.color,
        timesPerWeek: timesPerWeek ?? this.timesPerWeek,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  static Habit fromJson(Map<String, Object?> json) => Habit(
        id: json[BaseEntityFields.id] as int?,
        name: json[HabitFields.name] as String,
        icon: json[HabitFields.icon] as String?,
        color: json[HabitFields.color] as String,
        timesPerWeek: json[HabitFields.timesPerWeek] as int,
        createdAt: json[BaseEntityFields.createdAt] != null
            ? DateTime.parse(json[BaseEntityFields.createdAt] as String)
            : null,
        updatedAt: json[BaseEntityFields.updatedAt] != null
            ? DateTime.parse(json[BaseEntityFields.updatedAt] as String)
            : null,
      );

  Map<String, Object?> toJson({bool update = false}) => {
        if (update) BaseEntityFields.id: id,
        HabitFields.name: name,
        HabitFields.icon: icon,
        HabitFields.color: color,
        HabitFields.timesPerWeek: timesPerWeek,
        BaseEntityFields.createdAt: update
            ? createdAt?.toIso8601String()
            : DateTime.now().toIso8601String(),
        BaseEntityFields.updatedAt:
            update ? DateTime.now().toIso8601String() : null,
      };
}
