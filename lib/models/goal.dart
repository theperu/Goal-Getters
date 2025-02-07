import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Goal class definition
class Goal {
  final String id;
  final String name;
  final String difficulty;
  final String importance;
  final String status;
  final String notes;
  final String type;
  final String? relatedYearlyGoalId;
  final int? week;
  final int? year;

  Goal({
    required this.id,
    required this.name,
    required this.difficulty,
    required this.importance,
    required this.status,
    required this.notes,
    required this.type,
    this.relatedYearlyGoalId,
    this.week,
    this.year,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'difficulty': difficulty,
      'importance': importance,
      'status': status,
      'notes': notes,
      'type': type,
      'relatedYearlyGoalId': relatedYearlyGoalId,
      'week': week,
      'year': year,
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'],
      name: map['name'],
      difficulty: map['difficulty'],
      importance: map['importance'],
      status: map['status'],
      notes: map['notes'],
      type: map['type'],
      relatedYearlyGoalId: map['relatedYearlyGoalId'],
      week: map['week'],
      year: map['year'],
    );
  }
}

// Storage class to handle saving and loading goals
class GoalStorage {
  static const String _key = 'goals';

  static Future<void> saveGoals(List<Goal> goals) async {
    final prefs = await SharedPreferences.getInstance();
    final goalsJson = goals.map((goal) => jsonEncode(goal.toMap())).toList();
    await prefs.setStringList(_key, goalsJson);
  }

  static Future<List<Goal>> loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final goalsJson = prefs.getStringList(_key) ?? [];
    
    return goalsJson
        .map((json) => Goal.fromMap(jsonDecode(json)))
        .toList();
  }

  static Future<void> saveGoal(Goal goal) async {
    final goals = await loadGoals();
    final index = goals.indexWhere((g) => g.id == goal.id);
    
    if (index >= 0) {
      goals[index] = goal;
    } else {
      goals.add(goal);
    }
    
    await saveGoals(goals);
  }

  static Future<void> deleteGoal(String goalId) async {
    final goals = await loadGoals();
    goals.removeWhere((goal) => goal.id == goalId);
    await saveGoals(goals);
  }

  static Future<void> clearGoals() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}