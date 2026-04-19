// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habits_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Habits)
const habitsProvider = HabitsProvider._();

final class HabitsProvider extends $AsyncNotifierProvider<Habits, List<Habit>> {
  const HabitsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'habitsProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$habitsHash();

  @$internal
  @override
  Habits create() => Habits();
}

String _$habitsHash() => r'2fb8251cc94cb606633db2c3af567ba26918983a';

abstract class _$Habits extends $AsyncNotifier<List<Habit>> {
  FutureOr<List<Habit>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Habit>>, List<Habit>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Habit>>, List<Habit>>,
        AsyncValue<List<Habit>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(habitCompletionsForWeek)
const habitCompletionsForWeekProvider = HabitCompletionsForWeekFamily._();

final class HabitCompletionsForWeekProvider extends $FunctionalProvider<
        AsyncValue<List<HabitCompletion>>,
        List<HabitCompletion>,
        FutureOr<List<HabitCompletion>>>
    with
        $FutureModifier<List<HabitCompletion>>,
        $FutureProvider<List<HabitCompletion>> {
  const HabitCompletionsForWeekProvider._(
      {required HabitCompletionsForWeekFamily super.from,
      required (
        String,
        String,
      )
          super.argument})
      : super(
          retry: null,
          name: r'habitCompletionsForWeekProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$habitCompletionsForWeekHash();

  @override
  String toString() {
    return r'habitCompletionsForWeekProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<HabitCompletion>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<HabitCompletion>> create(Ref ref) {
    final argument = this.argument as (
      String,
      String,
    );
    return habitCompletionsForWeek(
      ref,
      argument.$1,
      argument.$2,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HabitCompletionsForWeekProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$habitCompletionsForWeekHash() =>
    r'd178b23ec7173edcd975089e20fb63fb1a1e4ee1';

final class HabitCompletionsForWeekFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<List<HabitCompletion>>,
            (
              String,
              String,
            )> {
  const HabitCompletionsForWeekFamily._()
      : super(
          retry: null,
          name: r'habitCompletionsForWeekProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  HabitCompletionsForWeekProvider call(
    String startDate,
    String endDate,
  ) =>
      HabitCompletionsForWeekProvider._(argument: (
        startDate,
        endDate,
      ), from: this);

  @override
  String toString() => r'habitCompletionsForWeekProvider';
}
