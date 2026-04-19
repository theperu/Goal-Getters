import 'package:flutter/material.dart';

/// Predefined color choices for habits — soft pastels in the Lavender Logic style.
class HabitColor {
  final String key;
  final Color color;
  final String label;

  const HabitColor({required this.key, required this.color, required this.label});
}

const List<HabitColor> habitColorChoices = [
  HabitColor(key: 'lavender', color: Color(0xFF9B7BF7), label: 'Lavender'),
  HabitColor(key: 'mint', color: Color(0xFF5EC6A0), label: 'Mint'),
  HabitColor(key: 'peach', color: Color(0xFFFF9F6E), label: 'Peach'),
  HabitColor(key: 'sky', color: Color(0xFF6BB5F0), label: 'Sky'),
  HabitColor(key: 'rose', color: Color(0xFFF07B8D), label: 'Rose'),
  HabitColor(key: 'amber', color: Color(0xFFF0C44C), label: 'Amber'),
  HabitColor(key: 'teal', color: Color(0xFF4CB8B0), label: 'Teal'),
  HabitColor(key: 'lilac', color: Color(0xFFB47BF0), label: 'Lilac'),
];

Color getHabitColor(String? key) {
  if (key == null) return habitColorChoices.first.color;
  return habitColorChoices
      .firstWhere((c) => c.key == key, orElse: () => habitColorChoices.first)
      .color;
}
