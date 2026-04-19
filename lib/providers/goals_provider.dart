import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/weekly_goal.dart';
import '../model/yearly_goal.dart';
import '../services/database/repositories/weekly_goal_repository.dart';
import '../services/database/repositories/yearly_goal_repository.dart';

part 'goals_provider.g.dart';

// =============================================================================
// Weekly Goals
// =============================================================================

@Riverpod(keepAlive: true)
class WeeklyGoals extends _$WeeklyGoals {
  @override
  Future<List<WeeklyGoal>> build() async {
    return await ref.read(weeklyGoalRepositoryProvider).selectAll();
  }

  Future<void> addGoal(WeeklyGoal goal) async {
    state = await AsyncValue.guard(() async {
      await ref.read(weeklyGoalRepositoryProvider).insert(goal);
      return _refresh();
    });
  }

  Future<void> updateGoal(WeeklyGoal goal) async {
    state = await AsyncValue.guard(() async {
      await ref.read(weeklyGoalRepositoryProvider).updateItem(goal);
      return _refresh();
    });
  }

  Future<void> removeGoal(int id) async {
    state = await AsyncValue.guard(() async {
      await ref.read(weeklyGoalRepositoryProvider).deleteById(id);
      return _refresh();
    });
  }

  Future<void> updateGoalStatus(WeeklyGoal goal, String newStatus) async {
    final updated = goal.copy(status: newStatus);
    await updateGoal(updated);
  }

  Future<void> updateGoalNotes(WeeklyGoal goal, String newNotes) async {
    final updated = goal.copy(notes: newNotes);
    await updateGoal(updated);
  }

  Future<List<WeeklyGoal>> _refresh() async {
    ref.invalidate(weeklyGoalsByWeekProvider);
    ref.invalidate(archivedWeeklyGoalsProvider);
    return await ref.read(weeklyGoalRepositoryProvider).selectAll();
  }
}

// =============================================================================
// Yearly Goals
// =============================================================================

@Riverpod(keepAlive: true)
class YearlyGoals extends _$YearlyGoals {
  @override
  Future<List<YearlyGoal>> build() async {
    return await ref.read(yearlyGoalRepositoryProvider).selectAll();
  }

  Future<void> addGoal(YearlyGoal goal) async {
    state = await AsyncValue.guard(() async {
      await ref.read(yearlyGoalRepositoryProvider).insert(goal);
      return _refresh();
    });
  }

  Future<void> updateGoal(YearlyGoal goal) async {
    state = await AsyncValue.guard(() async {
      await ref.read(yearlyGoalRepositoryProvider).updateItem(goal);
      return _refresh();
    });
  }

  Future<void> removeGoal(int id) async {
    state = await AsyncValue.guard(() async {
      await ref.read(yearlyGoalRepositoryProvider).deleteById(id);
      return _refresh();
    });
  }

  Future<void> updateGoalStatus(YearlyGoal goal, String newStatus) async {
    final updated = goal.copy(status: newStatus);
    await updateGoal(updated);
  }

  Future<void> updateGoalNotes(YearlyGoal goal, String newNotes) async {
    final updated = goal.copy(notes: newNotes);
    await updateGoal(updated);
  }

  Future<List<YearlyGoal>> _refresh() async {
    ref.invalidate(yearlyGoalsByYearProvider);
    ref.invalidate(archivedYearlyGoalsProvider);
    return await ref.read(yearlyGoalRepositoryProvider).selectAll();
  }
}

// =============================================================================
// Navigation / UI state
// =============================================================================

@Riverpod(keepAlive: true)
class SelectedDate extends _$SelectedDate {
  @override
  DateTime build() => DateTime.now();

  void set(DateTime date) => state = date;

  void changeWeek(int delta) {
    state = state.add(Duration(days: 7 * delta));
  }

  void changeYear(int delta) {
    state = DateTime(state.year + delta, state.month, state.day);
  }
}

@Riverpod(keepAlive: true)
class SelectedGoalType extends _$SelectedGoalType {
  @override
  String build() => 'weekly';

  void set(String type) => state = type;
}

@Riverpod(keepAlive: true)
class SelectedNavIndex extends _$SelectedNavIndex {
  @override
  int build() => 0;

  void set(int index) => state = index;
}

// =============================================================================
// Query providers
// =============================================================================

@riverpod
Future<List<WeeklyGoal>> weeklyGoalsByWeek(Ref ref, int year, int week) async {
  ref.watch(weeklyGoalsProvider);
  return await ref.read(weeklyGoalRepositoryProvider).selectByWeek(year, week);
}

@riverpod
Future<List<YearlyGoal>> yearlyGoalsByYear(Ref ref, int year) async {
  ref.watch(yearlyGoalsProvider);
  return await ref.read(yearlyGoalRepositoryProvider).selectByYear(year);
}

@riverpod
Future<List<WeeklyGoal>> archivedWeeklyGoals(Ref ref) async {
  ref.watch(weeklyGoalsProvider);
  return await ref.read(weeklyGoalRepositoryProvider).selectArchived();
}

@riverpod
Future<List<YearlyGoal>> archivedYearlyGoals(Ref ref) async {
  ref.watch(yearlyGoalsProvider);
  return await ref.read(yearlyGoalRepositoryProvider).selectArchived();
}

@riverpod
Future<List<WeeklyGoal>> allWeeklyForYear(Ref ref, int year) async {
  ref.watch(weeklyGoalsProvider);
  return await ref.read(weeklyGoalRepositoryProvider).selectAllForYear(year);
}
