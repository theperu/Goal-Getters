// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goals_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WeeklyGoals)
const weeklyGoalsProvider = WeeklyGoalsProvider._();

final class WeeklyGoalsProvider
    extends $AsyncNotifierProvider<WeeklyGoals, List<WeeklyGoal>> {
  const WeeklyGoalsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'weeklyGoalsProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$weeklyGoalsHash();

  @$internal
  @override
  WeeklyGoals create() => WeeklyGoals();
}

String _$weeklyGoalsHash() => r'1e6aa73b13418d07eea34de338a6ba8596b4453d';

abstract class _$WeeklyGoals extends $AsyncNotifier<List<WeeklyGoal>> {
  FutureOr<List<WeeklyGoal>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<WeeklyGoal>>, List<WeeklyGoal>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<WeeklyGoal>>, List<WeeklyGoal>>,
        AsyncValue<List<WeeklyGoal>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(YearlyGoals)
const yearlyGoalsProvider = YearlyGoalsProvider._();

final class YearlyGoalsProvider
    extends $AsyncNotifierProvider<YearlyGoals, List<YearlyGoal>> {
  const YearlyGoalsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'yearlyGoalsProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$yearlyGoalsHash();

  @$internal
  @override
  YearlyGoals create() => YearlyGoals();
}

String _$yearlyGoalsHash() => r'cc3e245c9fd1fa1601467485551b5282b816f4d4';

abstract class _$YearlyGoals extends $AsyncNotifier<List<YearlyGoal>> {
  FutureOr<List<YearlyGoal>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<YearlyGoal>>, List<YearlyGoal>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<YearlyGoal>>, List<YearlyGoal>>,
        AsyncValue<List<YearlyGoal>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SelectedDate)
const selectedDateProvider = SelectedDateProvider._();

final class SelectedDateProvider
    extends $NotifierProvider<SelectedDate, DateTime> {
  const SelectedDateProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'selectedDateProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$selectedDateHash();

  @$internal
  @override
  SelectedDate create() => SelectedDate();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$selectedDateHash() => r'becf5d37c74f2bdaf180fc18012d22fd165659f4';

abstract class _$SelectedDate extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<DateTime, DateTime>, DateTime, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SelectedGoalType)
const selectedGoalTypeProvider = SelectedGoalTypeProvider._();

final class SelectedGoalTypeProvider
    extends $NotifierProvider<SelectedGoalType, String> {
  const SelectedGoalTypeProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'selectedGoalTypeProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$selectedGoalTypeHash();

  @$internal
  @override
  SelectedGoalType create() => SelectedGoalType();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$selectedGoalTypeHash() => r'e794e20c8d75a4ce6fe9e05d3c129ebbbaf76e6c';

abstract class _$SelectedGoalType extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SelectedNavIndex)
const selectedNavIndexProvider = SelectedNavIndexProvider._();

final class SelectedNavIndexProvider
    extends $NotifierProvider<SelectedNavIndex, int> {
  const SelectedNavIndexProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'selectedNavIndexProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$selectedNavIndexHash();

  @$internal
  @override
  SelectedNavIndex create() => SelectedNavIndex();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$selectedNavIndexHash() => r'4f1b984c8a04cd645c3aab6408c50f91f99a5dd3';

abstract class _$SelectedNavIndex extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int, int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(weeklyGoalsByWeek)
const weeklyGoalsByWeekProvider = WeeklyGoalsByWeekFamily._();

final class WeeklyGoalsByWeekProvider extends $FunctionalProvider<
        AsyncValue<List<WeeklyGoal>>,
        List<WeeklyGoal>,
        FutureOr<List<WeeklyGoal>>>
    with $FutureModifier<List<WeeklyGoal>>, $FutureProvider<List<WeeklyGoal>> {
  const WeeklyGoalsByWeekProvider._(
      {required WeeklyGoalsByWeekFamily super.from,
      required (
        int,
        int,
      )
          super.argument})
      : super(
          retry: null,
          name: r'weeklyGoalsByWeekProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$weeklyGoalsByWeekHash();

  @override
  String toString() {
    return r'weeklyGoalsByWeekProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<WeeklyGoal>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<WeeklyGoal>> create(Ref ref) {
    final argument = this.argument as (
      int,
      int,
    );
    return weeklyGoalsByWeek(
      ref,
      argument.$1,
      argument.$2,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WeeklyGoalsByWeekProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$weeklyGoalsByWeekHash() => r'd1b3814116ae4bd50320389d72de537d7b7112d8';

final class WeeklyGoalsByWeekFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<List<WeeklyGoal>>,
            (
              int,
              int,
            )> {
  const WeeklyGoalsByWeekFamily._()
      : super(
          retry: null,
          name: r'weeklyGoalsByWeekProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  WeeklyGoalsByWeekProvider call(
    int year,
    int week,
  ) =>
      WeeklyGoalsByWeekProvider._(argument: (
        year,
        week,
      ), from: this);

  @override
  String toString() => r'weeklyGoalsByWeekProvider';
}

@ProviderFor(yearlyGoalsByYear)
const yearlyGoalsByYearProvider = YearlyGoalsByYearFamily._();

final class YearlyGoalsByYearProvider extends $FunctionalProvider<
        AsyncValue<List<YearlyGoal>>,
        List<YearlyGoal>,
        FutureOr<List<YearlyGoal>>>
    with $FutureModifier<List<YearlyGoal>>, $FutureProvider<List<YearlyGoal>> {
  const YearlyGoalsByYearProvider._(
      {required YearlyGoalsByYearFamily super.from,
      required int super.argument})
      : super(
          retry: null,
          name: r'yearlyGoalsByYearProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$yearlyGoalsByYearHash();

  @override
  String toString() {
    return r'yearlyGoalsByYearProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<YearlyGoal>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<YearlyGoal>> create(Ref ref) {
    final argument = this.argument as int;
    return yearlyGoalsByYear(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is YearlyGoalsByYearProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$yearlyGoalsByYearHash() => r'b6100659632a1143b72b672e13ded34728a0f299';

final class YearlyGoalsByYearFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<YearlyGoal>>, int> {
  const YearlyGoalsByYearFamily._()
      : super(
          retry: null,
          name: r'yearlyGoalsByYearProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  YearlyGoalsByYearProvider call(
    int year,
  ) =>
      YearlyGoalsByYearProvider._(argument: year, from: this);

  @override
  String toString() => r'yearlyGoalsByYearProvider';
}

@ProviderFor(archivedWeeklyGoals)
const archivedWeeklyGoalsProvider = ArchivedWeeklyGoalsProvider._();

final class ArchivedWeeklyGoalsProvider extends $FunctionalProvider<
        AsyncValue<List<WeeklyGoal>>,
        List<WeeklyGoal>,
        FutureOr<List<WeeklyGoal>>>
    with $FutureModifier<List<WeeklyGoal>>, $FutureProvider<List<WeeklyGoal>> {
  const ArchivedWeeklyGoalsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'archivedWeeklyGoalsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$archivedWeeklyGoalsHash();

  @$internal
  @override
  $FutureProviderElement<List<WeeklyGoal>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<WeeklyGoal>> create(Ref ref) {
    return archivedWeeklyGoals(ref);
  }
}

String _$archivedWeeklyGoalsHash() =>
    r'16b2542d848a93890ed0ac5ef8dde673f15683e2';

@ProviderFor(archivedYearlyGoals)
const archivedYearlyGoalsProvider = ArchivedYearlyGoalsProvider._();

final class ArchivedYearlyGoalsProvider extends $FunctionalProvider<
        AsyncValue<List<YearlyGoal>>,
        List<YearlyGoal>,
        FutureOr<List<YearlyGoal>>>
    with $FutureModifier<List<YearlyGoal>>, $FutureProvider<List<YearlyGoal>> {
  const ArchivedYearlyGoalsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'archivedYearlyGoalsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$archivedYearlyGoalsHash();

  @$internal
  @override
  $FutureProviderElement<List<YearlyGoal>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<YearlyGoal>> create(Ref ref) {
    return archivedYearlyGoals(ref);
  }
}

String _$archivedYearlyGoalsHash() =>
    r'346760a7e7c59a149576d681165035efffb65bc9';

@ProviderFor(allWeeklyForYear)
const allWeeklyForYearProvider = AllWeeklyForYearFamily._();

final class AllWeeklyForYearProvider extends $FunctionalProvider<
        AsyncValue<List<WeeklyGoal>>,
        List<WeeklyGoal>,
        FutureOr<List<WeeklyGoal>>>
    with $FutureModifier<List<WeeklyGoal>>, $FutureProvider<List<WeeklyGoal>> {
  const AllWeeklyForYearProvider._(
      {required AllWeeklyForYearFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'allWeeklyForYearProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$allWeeklyForYearHash();

  @override
  String toString() {
    return r'allWeeklyForYearProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<WeeklyGoal>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<WeeklyGoal>> create(Ref ref) {
    final argument = this.argument as int;
    return allWeeklyForYear(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AllWeeklyForYearProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$allWeeklyForYearHash() => r'7b824ca399fed2407f21704f0e4ab90d88d27c5b';

final class AllWeeklyForYearFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<WeeklyGoal>>, int> {
  const AllWeeklyForYearFamily._()
      : super(
          retry: null,
          name: r'allWeeklyForYearProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  AllWeeklyForYearProvider call(
    int year,
  ) =>
      AllWeeklyForYearProvider._(argument: year, from: this);

  @override
  String toString() => r'allWeeklyForYearProvider';
}
