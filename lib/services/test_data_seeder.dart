import '../constants/constants.dart';
import '../model/weekly_goal.dart';
import '../model/yearly_goal.dart';
import '../model/habit.dart';
import '../model/habit_completion.dart';
import '../model/reflection.dart';
import '../services/database/repositories/weekly_goal_repository.dart';
import '../services/database/repositories/yearly_goal_repository.dart';
import '../services/database/repositories/habit_repository.dart';
import '../services/database/repositories/reflection_repository.dart';
import '../services/database/goal_getters_database.dart';

class TestDataSeeder {
  final WeeklyGoalRepository weeklyRepo;
  final YearlyGoalRepository yearlyRepo;
  final HabitRepository habitRepo;
  final ReflectionRepository reflectionRepo;
  final GoalGettersDatabase database;

  TestDataSeeder({
    required this.weeklyRepo,
    required this.yearlyRepo,
    required this.habitRepo,
    required this.reflectionRepo,
    required this.database,
  });

  Future<void> seed() async {
    // ── Clear existing data ───────────────────────────────
    final db = await database.database;
    await db.delete('habit_completion');
    await db.delete('habit');
    await db.delete('weekly_goal');
    await db.delete('yearly_goal');
    await db.delete('reflection');

    final now = DateTime.now();
    final currentYear = now.year;
    final currentWeek = getWeekOfYear(now);
    final today = now.weekday; // 1=Mon..7=Sun

    // ── Yearly Goals ──────────────────────────────────────
    final yearlyGoals = [
      YearlyGoal(name: 'Read 24 books', difficulty: '3', importance: 'High', status: 'In Progress', notes: 'Currently on book #7 – Atomic Habits', year: currentYear, icon: 'book'),
      YearlyGoal(name: 'Run a half marathon', difficulty: '4', importance: 'High', status: 'In Progress', notes: 'Training plan started in January, long run up to 15 km', year: currentYear, icon: 'run'),
      YearlyGoal(name: 'Save €5 000 emergency fund', difficulty: '3', importance: 'Medium', status: 'In Progress', notes: '€2 800 saved so far', year: currentYear, icon: 'money'),
      YearlyGoal(name: 'Learn conversational Spanish', difficulty: '4', importance: 'Medium', status: 'Todo', notes: 'Start with Duolingo + italki sessions', year: currentYear, icon: 'language'),
      YearlyGoal(name: 'Ship side-project MVP', difficulty: '5', importance: 'High', status: 'In Progress', notes: 'Flutter app – backend done, working on UI', year: currentYear, icon: 'code'),
    ];

    final insertedYearly = <YearlyGoal>[];
    for (final g in yearlyGoals) {
      insertedYearly.add(await yearlyRepo.insert(g));
    }

    // ── Weekly Goals for current week ─────────────────────
    int dayOf(int offset) {
      var d = today + offset;
      if (d < 1) d += 7;
      if (d > 7) d -= 7;
      return d;
    }

    final weeklyGoals = [
      WeeklyGoal(name: 'Review pull requests', difficulty: '2', importance: 'High', status: 'Done', notes: 'Reviewed 3 PRs on the main repo', week: currentWeek, year: currentYear, dayOfWeek: dayOf(-1), timeboxStart: '09:00', timeboxMinutes: 60, relatedYearlyGoalId: insertedYearly[4].id),
      WeeklyGoal(name: 'Write blog post draft', difficulty: '3', importance: 'Medium', status: 'In Progress', notes: 'Topic: productivity systems for developers', week: currentWeek, year: currentYear, dayOfWeek: today, timeboxStart: '10:00', timeboxMinutes: 90),
      WeeklyGoal(name: '5 km training run', difficulty: '2', importance: 'High', status: 'Todo', notes: 'Easy pace, focus on form', week: currentWeek, year: currentYear, dayOfWeek: today, timeboxStart: '18:00', timeboxMinutes: 40, relatedYearlyGoalId: insertedYearly[1].id),
      WeeklyGoal(name: 'Call dentist for appointment', difficulty: '1', importance: 'Low', status: 'Todo', week: currentWeek, year: currentYear, dayOfWeek: today),
      WeeklyGoal(name: 'Finish onboarding screen UI', difficulty: '4', importance: 'High', status: 'Todo', notes: 'Figma design is ready, just implement it', week: currentWeek, year: currentYear, dayOfWeek: dayOf(1), timeboxStart: '09:30', timeboxMinutes: 120, relatedYearlyGoalId: insertedYearly[4].id),
      WeeklyGoal(name: 'Grocery shopping & meal prep', difficulty: '2', importance: 'Medium', status: 'Todo', week: currentWeek, year: currentYear, dayOfWeek: dayOf(2)),
      WeeklyGoal(name: 'Spanish lesson on italki', difficulty: '2', importance: 'Medium', status: 'Todo', notes: '30 min conversation practice', week: currentWeek, year: currentYear, dayOfWeek: dayOf(2), timeboxStart: '19:00', timeboxMinutes: 30, relatedYearlyGoalId: insertedYearly[3].id),
      WeeklyGoal(name: 'Transfer €400 to savings', difficulty: '1', importance: 'High', status: 'Todo', notes: 'Monthly auto-save target', week: currentWeek, year: currentYear, relatedYearlyGoalId: insertedYearly[2].id),
      WeeklyGoal(name: 'Read 3 chapters of current book', difficulty: '2', importance: 'Medium', status: 'In Progress', notes: 'Atomic Habits ch. 8-10', week: currentWeek, year: currentYear, relatedYearlyGoalId: insertedYearly[0].id),
    ];

    final prevWeek = currentWeek > 1 ? currentWeek - 1 : 52;
    final prevYear = currentWeek > 1 ? currentYear : currentYear - 1;
    final prevWeekGoals = [
      WeeklyGoal(name: 'Set up CI/CD pipeline', difficulty: '4', importance: 'High', status: 'Done', week: prevWeek, year: prevYear, dayOfWeek: 2, relatedYearlyGoalId: insertedYearly[4].id),
      WeeklyGoal(name: 'Plan April budget', difficulty: '2', importance: 'Medium', status: 'Done', week: prevWeek, year: prevYear, dayOfWeek: 4),
      WeeklyGoal(name: '10 km long run', difficulty: '3', importance: 'High', status: 'Rescheduled', notes: 'Moved to this week – rain', week: prevWeek, year: prevYear, dayOfWeek: 6, relatedYearlyGoalId: insertedYearly[1].id),
    ];

    for (final g in [...weeklyGoals, ...prevWeekGoals]) {
      await weeklyRepo.insert(g);
    }

    // ── Habits ────────────────────────────────────────────
    final habits = [
      Habit(name: 'Morning meditation', icon: 'meditation', color: 'lavender', timesPerWeek: 7),
      Habit(name: 'Exercise', icon: 'fitness', color: 'mint', timesPerWeek: 5),
      Habit(name: 'Read 20 pages', icon: 'book', color: 'sky', timesPerWeek: 6),
      Habit(name: 'Journal', icon: 'writing', color: 'peach', timesPerWeek: 5),
      Habit(name: 'No social media before noon', icon: 'sleep', color: 'rose', timesPerWeek: 7),
    ];

    final insertedHabits = <Habit>[];
    final habitCreatedAt = now.subtract(const Duration(days: 63)); // ~9 weeks ago
    for (final h in habits) {
      final inserted = await habitRepo.insertHabit(h);
      final backdated = inserted.copy(createdAt: habitCreatedAt);
      await habitRepo.updateHabit(backdated);
      insertedHabits.add(backdated);
    }

    // ── Habit Completions (8 weeks of history) ────────────
    // 56 days of data so per-habit weekly streaks are meaningful.
    // Each list: index 0 = today, index 55 = 55 days ago.
    //
    // Design goals:
    //   - Meditation (7×/wk): current streak 4 weeks, had a 6-week streak earlier → all-time 6
    //   - Exercise (5×/wk):   current streak 3 weeks, best ever is same 3 → all-time 3
    //   - Reading (6×/wk):    current streak 5 weeks (the longest active) → current best card
    //   - Journal (5×/wk):    current streak 2 weeks, had 4-week streak → all-time best card
    //   - No socials (7×/wk): current streak 1 week, had 3-week streak earlier
    //
    // Week boundaries: day 0-6 = current week, 7-13 = last week, etc.

    // Helper: generate a week of booleans (Mon-Sun within that week slice)
    List<bool> full(int n) => List.filled(n, true);
    List<bool> miss(int n) => List.filled(n, false);

    // Build day-by-day patterns (index 0 = today, going backwards)
    // We'll construct week blocks then flatten. Each block is 7 days.
    // "met" = enough trues in the block to meet timesPerWeek.

    // Meditation 7×/wk – current: 4 weeks met, week 5 missed, then 6 weeks met
    // Weeks: [met, met, met, met, MISS, met, met, met, met, met, met]
    //         w0   w1   w2   w3   w4    w5   w6   w7   (only 8 weeks = 56 days)
    final meditation = <bool>[
      // w0 (current, partial – fill up to today's weekday)
      ...full(today), ...miss(7 - today),
      // w1-w3: met (all 7)
      ...full(7), ...full(7), ...full(7),
      // w4: missed (only 4 out of 7)
      true, true, false, true, false, true, false,
      // w5-w7: met (all 7) — gives a 3-week old streak → total before break = 3, but w5-w7 is actually 3 consecutive,
      // Let's reorganise to get all-time=6:
      // w5-w7 = 3 weeks met (but we want 6-week all-time).
      // So let's put the break at w5 instead:
      // Actually let me just lay it out simply for 8 weeks:
    ];

    // Let me use a cleaner approach: build per-week completion counts
    // and then expand to daily patterns.

    // meditation 7×/wk
    // weeks ago: 0  1  2  3  4  5  6  7
    // met?:      Y  Y  Y  Y  N  Y  Y  Y  → current=4, all-time best run of met = max(4, 3) = 4
    // Hmm, need all-time > current. Let's do:
    // weeks ago: 0  1  2  3  4  5  6  7
    // met?:      Y  Y  Y  Y  N  Y  Y  Y  → but 3<4. Need more history.
    // Let me use 10 weeks (70 days):
    final habitCreatedAt2 = now.subtract(const Duration(days: 77)); // 11 weeks ago
    // Update habits createdAt
    for (final h in insertedHabits) {
      await habitRepo.updateHabit(h.copy(createdAt: habitCreatedAt2));
    }

    // Per-habit weekly completion counts (index 0 = current week, increasing = older)
    // Meditation 7×/wk: current 4wk streak; older 6wk streak → all-time=6
    final meditationWeeks =  [7, 7, 7, 7, 3, 7, 7, 7, 7, 7, 7]; // 0-3 met, 4 miss, 5-10 met (6 consecutive)
    // Exercise 5×/wk: current 3wk streak, older had 5wk streak → all-time=5
    final exerciseWeeks =    [5, 5, 5, 2, 5, 5, 5, 5, 5, 3, 1]; // 0-2 met, 3 miss, 4-8 met (5 consecutive)
    // Reading 6×/wk: current 7wk streak (longest active!) → current best=7, all-time=7
    final readingWeeks =     [6, 6, 6, 6, 6, 6, 6, 4, 6, 6, 3]; // 0-6 met (7 weeks), 7 miss
    // Journal 5×/wk: current 2wk, older 4wk → all-time=4
    final journalWeeks =     [5, 5, 3, 5, 5, 5, 5, 2, 1, 5, 5]; // 0-1 met, 2 miss, 3-6 met (4), 7 miss
    // No socials 7×/wk: current 1wk, older 3wk → all-time=3
    final noSocialsWeeks =   [7, 4, 7, 7, 7, 5, 3, 7, 7, 7, 2]; // 0 met, 1 miss, 2-4 met (3), 5 miss

    final allWeeklyPatterns = [meditationWeeks, exerciseWeeks, readingWeeks, journalWeeks, noSocialsWeeks];

    for (var hi = 0; hi < insertedHabits.length; hi++) {
      final habitId = insertedHabits[hi].id!;
      final weekPattern = allWeeklyPatterns[hi];

      for (var wi = 0; wi < weekPattern.length; wi++) {
        final completionsNeeded = weekPattern[wi];
        // Monday of this week-offset
        final monday = _mondayOfWeek(now).subtract(Duration(days: wi * 7));

        // For the current week (wi==0), only generate completions up to today
        final daysInWeek = (wi == 0) ? today : 7;

        // Spread completions across the available days
        for (var d = 0; d < daysInWeek && d < completionsNeeded; d++) {
          final date = monday.add(Duration(days: d));
          final dateStr =
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
          await habitRepo.insertCompletion(
            HabitCompletion(habitId: habitId, date: dateStr),
          );
        }
      }
    }

    // ── Reflections (past 14 days of journal entries) ─────
    final reflectionData = <Map<String, dynamic>>[
      {'daysAgo': 1, 'mood': 4, 'text': 'Finished the project proposal ahead of time. Felt a huge weight off my shoulders. Ready for the weekend.'},
      {'daysAgo': 2, 'mood': 3, 'text': 'Average day. Got through the meetings but felt drained afterwards.'},
      {'daysAgo': 3, 'mood': 5, 'text': 'Had a wonderful coffee walk with Sarah. The autumn air was crisp and refreshing. Realized I need more nature in my life.'},
      {'daysAgo': 4, 'mood': 2, 'text': 'A bit of a slow start today. Didn\'t hit my habits, but that\'s okay. Tomorrow is a new slate.'},
      {'daysAgo': 5, 'mood': 4, 'text': 'Good focus session in the morning. Knocked out two big tasks before lunch.'},
      {'daysAgo': 6, 'mood': 3, 'text': 'Quiet day. Read a few chapters and went for a short walk.'},
      {'daysAgo': 7, 'mood': 5, 'text': 'Best day in a while. Got a compliment from the team lead on the UI work.'},
      {'daysAgo': 9, 'mood': 4, 'text': 'Productive Monday. Set up the week\'s goals and feel organized.'},
      {'daysAgo': 10, 'mood': 1, 'text': 'Rough day. Argument with a friend left me feeling low. Need to sort things out.'},
      {'daysAgo': 12, 'mood': 3, 'text': 'Nothing special but nothing bad either. Sometimes ordinary is fine.'},
      {'daysAgo': 14, 'mood': 4, 'text': 'Great run this morning, personal best for 5K!'},
    ];

    for (final entry in reflectionData) {
      final date = now.subtract(Duration(days: entry['daysAgo'] as int));
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      await reflectionRepo.insert(Reflection(
        mood: entry['mood'] as int,
        text: entry['text'] as String,
        date: dateStr,
      ));
    }
  }

  DateTime _mondayOfWeek(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return d.subtract(Duration(days: d.weekday - 1));
  }
}
