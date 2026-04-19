# Goal Getters

A mindful productivity app built with Flutter for setting weekly and yearly goals, building habits, and reflecting on your progress through journaling.

> This project is 100% vibecoded — every line of code, architecture decision, and design choice was generated through AI-assisted development.

## Features

### Goals
- **Yearly goals** — define high-level objectives for the year with icons, difficulty, and importance ratings
- **Weekly goals** — break yearly goals into actionable weekly tasks, linked to their parent yearly goal
- **Status tracking** — move goals through To Do, In Progress, and Done states
- **Auto-archiving** — old open weekly goals are automatically archived at the start of each new week

### Habits
- **Daily habit tracking** — create recurring habits and check them off each day
- **Streak tracking** — see current and best streaks at a glance
- **Weekly consistency** — visual bar charts showing completion across the week
- **Flexible scheduling** — assign habits to specific days of the week

### Journal
- **Weekly reflections** — guided prompts to review wins, challenges, and intentions
- **Mood tracking** — capture how your week felt with a simple mood selector
- **Reflection history** — browse past entries on a calendar view

### Today View
- The home screen surfaces your weekly goals and habit check-ins for the current day, with a swipeable week selector to look ahead or back

### Vision Board
- A dedicated screen for your yearly goals with progress indicators and detail sheets

### Settings
- Light and dark theme toggle
- Calendar sync (add goals to device calendar)
- Data backup and restore (JSON export/import)
- Notification reminders
- Test data seeder for development

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter (Dart) |
| State management | Riverpod with code generation |
| Database | SQLite via `sqflite` with a sequential migration system |
| Routing | Centralized `onGenerateRoute` with platform-adaptive transitions |
| Theming | Token-based design system with light/dark support (Plus Jakarta Sans / Poppins) |
| Notifications | `flutter_local_notifications` + `flutter_timezone` |
| Calendar | `add_2_calendar` + `device_calendar` |

## Project Structure

```
lib/
├── main.dart                  # Bootstrap: DB init, data migration, ProviderScope
├── constants/                 # Style tokens, color palettes, goal/habit constants
├── model/                     # Data entities (BaseEntity subclasses)
│   ├── base_entity.dart
│   ├── weekly_goal.dart
│   ├── yearly_goal.dart
│   ├── habit.dart
│   ├── habit_completion.dart
│   └── reflection.dart
├── pages/                     # UI screens grouped by feature
│   ├── today/                 # Daily view with goals + habit check-ins
│   ├── goals/                 # Goal creation/editing form
│   ├── habits/                # Habit list, form, and widgets
│   ├── journal/               # Reflections, mood, calendar
│   ├── vision/                # Yearly goal board
│   └── settings/              # App preferences
├── providers/                 # Riverpod state (goals, habits, reflections, theme)
├── routes/                    # Route table and adaptive page builder
├── services/
│   ├── database/              # DB singleton, migration system, repositories
│   │   ├── migrations/        # Sequential schema migrations (0001–0007)
│   │   └── repositories/      # CRUD per entity
│   ├── notification_service.dart
│   ├── calendar_service.dart
│   ├── backup_service.dart
│   ├── goal_archiver.dart
│   └── data_migration.dart    # One-time SharedPreferences → SQLite migration
└── ui/                        # Theme, responsive utilities, reusable widgets
    ├── theme/
    ├── device.dart
    ├── extensions.dart
    └── widgets/
```

## Getting Started

### Prerequisites
- Flutter SDK `^3.5.4`
- Dart SDK `^3.5.4`

### Run
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### Build
```bash
flutter build apk --release    # Android
flutter build ios --release     # iOS
```

## Database Migrations

Schema changes are handled by numbered migration files in `lib/services/database/migrations/`. To add a new migration:

1. Create `lib/services/database/migrations/NNNN_description.dart`
2. Extend `Migration` with the next version number
3. Register it in `migration_registry.dart`
4. Run `dart run build_runner build --delete-conflicting-outputs`

Never modify an existing migration — existing users may have already run it.

## Future Enhancements

- Goal completion analytics and historical trends
- Onboarding flow for first-time users
- Biometric app lock
- Cloud sync