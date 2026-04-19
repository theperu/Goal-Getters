// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_getters_database.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(database)
const databaseProvider = DatabaseProvider._();

final class DatabaseProvider extends $FunctionalProvider<
    GoalGettersDatabase,
    GoalGettersDatabase,
    GoalGettersDatabase> with $Provider<GoalGettersDatabase> {
  const DatabaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'databaseProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$databaseHash();

  @$internal
  @override
  $ProviderElement<GoalGettersDatabase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoalGettersDatabase create(Ref ref) {
    return database(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoalGettersDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoalGettersDatabase>(value),
    );
  }
}

String _$databaseHash() => r'5ad754ea08c4f67183e4d1c71b905c67e81ad4fe';
