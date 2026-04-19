// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_goal_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(weeklyGoalRepository)
const weeklyGoalRepositoryProvider = WeeklyGoalRepositoryProvider._();

final class WeeklyGoalRepositoryProvider extends $FunctionalProvider<
    WeeklyGoalRepository,
    WeeklyGoalRepository,
    WeeklyGoalRepository> with $Provider<WeeklyGoalRepository> {
  const WeeklyGoalRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'weeklyGoalRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$weeklyGoalRepositoryHash();

  @$internal
  @override
  $ProviderElement<WeeklyGoalRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WeeklyGoalRepository create(Ref ref) {
    return weeklyGoalRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeeklyGoalRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeeklyGoalRepository>(value),
    );
  }
}

String _$weeklyGoalRepositoryHash() =>
    r'369c70769da5ec5bfc02c764c77e2ea53e77e776';
