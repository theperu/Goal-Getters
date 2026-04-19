import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/habit.dart';
import '../model/habit_completion.dart';
import '../services/database/repositories/habit_repository.dart';

part 'habits_provider.g.dart';

// =============================================================================
// Habits CRUD
// =============================================================================

@Riverpod(keepAlive: true)
class Habits extends _$Habits {
  @override
  Future<List<Habit>> build() async {
    return await ref.read(habitRepositoryProvider).selectAllHabits();
  }

  Future<void> addHabit(Habit habit) async {
    state = await AsyncValue.guard(() async {
      await ref.read(habitRepositoryProvider).insertHabit(habit);
      return _refresh();
    });
  }

  Future<void> updateHabit(Habit habit) async {
    state = await AsyncValue.guard(() async {
      await ref.read(habitRepositoryProvider).updateHabit(habit);
      return _refresh();
    });
  }

  Future<void> removeHabit(int id) async {
    state = await AsyncValue.guard(() async {
      await ref.read(habitRepositoryProvider).deleteHabit(id);
      return _refresh();
    });
  }

  Future<List<Habit>> _refresh() async {
    ref.invalidate(habitCompletionsForWeekProvider);
    return await ref.read(habitRepositoryProvider).selectAllHabits();
  }
}

// =============================================================================
// Completions for a given week
// =============================================================================

@riverpod
Future<List<HabitCompletion>> habitCompletionsForWeek(
    Ref ref, String startDate, String endDate) async {
  ref.watch(habitsProvider);
  return await ref
      .read(habitRepositoryProvider)
      .selectAllCompletionsForRange(startDate, endDate);
}

// =============================================================================
// Toggle a completion (add/remove)
// =============================================================================

Future<void> toggleHabitCompletion(
  HabitRepository repo,
  int habitId,
  String date,
  bool currentlyCompleted,
) async {
  if (currentlyCompleted) {
    await repo.deleteCompletion(habitId, date);
  } else {
    await repo.insertCompletion(HabitCompletion(
      habitId: habitId,
      date: date,
    ));
  }
}

// =============================================================================
// Streak calculation helpers
// =============================================================================

/// Returns the Monday of the ISO week containing [date].
DateTime _mondayOfWeek(DateTime date) {
  final d = DateTime(date.year, date.month, date.day);
  return d.subtract(Duration(days: d.weekday - 1));
}

/// Format a DateTime to YYYY-MM-DD.
String _dateStr(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Compute the current streak and best streak in weeks.
/// A "successful week" is one where **every** habit met its timesPerWeek target.
/// Streak counts consecutive successful weeks ending at the current week.
class StreakResult {
  final int currentStreak;
  final String? currentHabitName;
  final int bestStreak;
  final String? bestHabitName;
  StreakResult({
    required this.currentStreak,
    this.currentHabitName,
    required this.bestStreak,
    this.bestHabitName,
  });
}

Future<StreakResult> computeStreaks(
  HabitRepository repo,
  List<Habit> habits,
) async {
  if (habits.isEmpty) return StreakResult(currentStreak: 0, bestStreak: 0);

  final now = DateTime.now();
  final currentMonday = _mondayOfWeek(now);

  // Fetch all completions once
  final allCompletions = <int, Set<String>>{};
  for (final habit in habits) {
    final completions = await repo.selectAllCompletionsForHabit(habit.id!);
    allCompletions[habit.id!] = completions.map((c) => c.date).toSet();
  }

  int bestCurrentStreak = 0;
  String? bestCurrentName;
  int allTimeBest = 0;
  String? allTimeBestName;

  for (final habit in habits) {
    if (habit.createdAt == null) continue;
    final startMonday = _mondayOfWeek(habit.createdAt!);
    final dates = allCompletions[habit.id!] ?? {};

    int running = 0;
    int habitBest = 0;
    int habitCurrent = 0;

    var weekStart = startMonday;
    while (!weekStart.isAfter(currentMonday)) {
      final isCurrentWeek = weekStart == currentMonday;
      final weekDates = List.generate(
          7, (i) => _dateStr(weekStart.add(Duration(days: i))));
      final completedDays = weekDates.where((d) => dates.contains(d)).length;

      if (isCurrentWeek) {
        // For the current (incomplete) week, check if the target is still
        // reachable: count remaining days and see if they could fill the gap.
        // If already met, count it. Otherwise just skip it — don't break the streak.
        if (completedDays >= habit.timesPerWeek) {
          running++;
        }
        // else: leave running untouched (don't penalise a partial week)
      } else {
        if (completedDays >= habit.timesPerWeek) {
          running++;
        } else {
          running = 0;
        }
      }

      if (running > habitBest) habitBest = running;
      weekStart = weekStart.add(const Duration(days: 7));
    }

    habitCurrent = running;

    if (habitCurrent > bestCurrentStreak) {
      bestCurrentStreak = habitCurrent;
      bestCurrentName = habit.name;
    }
    if (habitBest > allTimeBest) {
      allTimeBest = habitBest;
      allTimeBestName = habit.name;
    }
  }

  return StreakResult(
    currentStreak: bestCurrentStreak,
    currentHabitName: bestCurrentName,
    bestStreak: allTimeBest,
    bestHabitName: allTimeBestName,
  );
}

/// Compute consistency percentage: across all habits and all weeks since creation,
/// what fraction of weekly targets were met.
Future<double> computeConsistency(
  HabitRepository repo,
  List<Habit> habits,
) async {
  if (habits.isEmpty) return 0.0;

  DateTime? earliest;
  for (final h in habits) {
    if (h.createdAt != null && (earliest == null || h.createdAt!.isBefore(earliest))) {
      earliest = h.createdAt;
    }
  }
  if (earliest == null) return 0.0;

  final now = DateTime.now();
  final currentMonday = _mondayOfWeek(now);
  final startMonday = _mondayOfWeek(earliest);

  final allCompletions = <int, Set<String>>{};
  for (final habit in habits) {
    final completions = await repo.selectAllCompletionsForHabit(habit.id!);
    allCompletions[habit.id!] = completions.map((c) => c.date).toSet();
  }

  int totalTargets = 0;
  int metTargets = 0;

  var weekStart = startMonday;
  while (!weekStart.isAfter(currentMonday)) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    final weekDates = List.generate(
        7, (i) => _dateStr(weekStart.add(Duration(days: i))));

    for (final habit in habits) {
      if (habit.createdAt == null) continue;
      final habitCreatedMonday = _mondayOfWeek(habit.createdAt!);
      if (habitCreatedMonday.isAfter(weekEnd)) continue;

      totalTargets++;
      final completedDays = weekDates
          .where((d) => allCompletions[habit.id]?.contains(d) ?? false)
          .length;
      if (completedDays >= habit.timesPerWeek) {
        metTargets++;
      }
    }

    weekStart = weekStart.add(const Duration(days: 7));
  }

  return totalTargets > 0 ? (metTargets / totalTargets) * 100 : 0.0;
}
