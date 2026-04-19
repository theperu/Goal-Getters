import 'base_entity.dart';

class ReflectionFields extends BaseEntityFields {
  static const String tableName = 'reflection';
  static const String mood = 'mood';
  static const String text = 'text';
  static const String date = 'date';
}

class Reflection extends BaseEntity {
  final int mood; // 1-5: very bad, bad, okay, good, very good
  final String? text;
  final String date; // YYYY-MM-DD

  Reflection({
    super.id,
    required this.mood,
    this.text,
    required this.date,
    super.createdAt,
    super.updatedAt,
  });

  Reflection copy({
    int? id,
    int? mood,
    String? text,
    bool clearText = false,
    String? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Reflection(
        id: id ?? this.id,
        mood: mood ?? this.mood,
        text: clearText ? null : (text ?? this.text),
        date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  static Reflection fromJson(Map<String, Object?> json) => Reflection(
        id: json[BaseEntityFields.id] as int?,
        mood: json[ReflectionFields.mood] as int,
        text: json[ReflectionFields.text] as String?,
        date: json[ReflectionFields.date] as String,
        createdAt: json[BaseEntityFields.createdAt] != null
            ? DateTime.parse(json[BaseEntityFields.createdAt] as String)
            : null,
        updatedAt: json[BaseEntityFields.updatedAt] != null
            ? DateTime.parse(json[BaseEntityFields.updatedAt] as String)
            : null,
      );

  Map<String, Object?> toJson({bool update = false}) => {
        if (update) BaseEntityFields.id: id,
        ReflectionFields.mood: mood,
        ReflectionFields.text: text,
        ReflectionFields.date: date,
        BaseEntityFields.createdAt: update
            ? createdAt?.toIso8601String()
            : DateTime.now().toIso8601String(),
        BaseEntityFields.updatedAt:
            update ? DateTime.now().toIso8601String() : null,
      };

  String get moodLabel {
    switch (mood) {
      case 1:
        return 'Very Bad';
      case 2:
        return 'Bad';
      case 3:
        return 'Okay';
      case 4:
        return 'Good';
      case 5:
        return 'Very Good';
      default:
        return 'Okay';
    }
  }
}
