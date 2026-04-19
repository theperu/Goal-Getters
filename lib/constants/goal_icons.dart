import 'package:flutter/material.dart';

/// Icon choices for yearly goals — each has a codePoint and label.
class GoalIcon {
  final String key;
  final IconData icon;
  final String label;

  const GoalIcon({required this.key, required this.icon, required this.label});
}

const List<GoalIcon> goalIconChoices = [
  GoalIcon(key: 'book', icon: Icons.menu_book, label: 'Reading'),
  GoalIcon(key: 'fitness', icon: Icons.fitness_center, label: 'Fitness'),
  GoalIcon(key: 'run', icon: Icons.directions_run, label: 'Running'),
  GoalIcon(key: 'language', icon: Icons.language, label: 'Language'),
  GoalIcon(key: 'code', icon: Icons.code, label: 'Coding'),
  GoalIcon(key: 'money', icon: Icons.savings, label: 'Savings'),
  GoalIcon(key: 'travel', icon: Icons.flight, label: 'Travel'),
  GoalIcon(key: 'music', icon: Icons.music_note, label: 'Music'),
  GoalIcon(key: 'art', icon: Icons.palette, label: 'Art'),
  GoalIcon(key: 'health', icon: Icons.favorite, label: 'Health'),
  GoalIcon(key: 'meditation', icon: Icons.self_improvement, label: 'Mindfulness'),
  GoalIcon(key: 'education', icon: Icons.school, label: 'Education'),
  GoalIcon(key: 'career', icon: Icons.work, label: 'Career'),
  GoalIcon(key: 'social', icon: Icons.people, label: 'Social'),
  GoalIcon(key: 'nutrition', icon: Icons.restaurant, label: 'Nutrition'),
  GoalIcon(key: 'sleep', icon: Icons.bedtime, label: 'Sleep'),
  GoalIcon(key: 'writing', icon: Icons.edit_note, label: 'Writing'),
  GoalIcon(key: 'photo', icon: Icons.camera_alt, label: 'Photography'),
  GoalIcon(key: 'home', icon: Icons.home, label: 'Home'),
  GoalIcon(key: 'star', icon: Icons.star, label: 'General'),
];

IconData getGoalIconData(String? key) {
  if (key == null) return Icons.star;
  return goalIconChoices
      .firstWhere((g) => g.key == key, orElse: () => goalIconChoices.last)
      .icon;
}
