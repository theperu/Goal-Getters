// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yearly_goal_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(yearlyGoalRepository)
const yearlyGoalRepositoryProvider = YearlyGoalRepositoryProvider._();

final class YearlyGoalRepositoryProvider extends $FunctionalProvider<
    YearlyGoalRepository,
    YearlyGoalRepository,
    YearlyGoalRepository> with $Provider<YearlyGoalRepository> {
  const YearlyGoalRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'yearlyGoalRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$yearlyGoalRepositoryHash();

  @$internal
  @override
  $ProviderElement<YearlyGoalRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  YearlyGoalRepository create(Ref ref) {
    return yearlyGoalRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(YearlyGoalRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<YearlyGoalRepository>(value),
    );
  }
}

String _$yearlyGoalRepositoryHash() =>
    r'40a98602ff0ce9d51d1d85aef2087009dd38955a';
