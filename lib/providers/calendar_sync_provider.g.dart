// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_sync_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// No-op — calendar sync is not needed with intent-based calendar integration.

@ProviderFor(syncCalendarEvents)
const syncCalendarEventsProvider = SyncCalendarEventsFamily._();

/// No-op — calendar sync is not needed with intent-based calendar integration.

final class SyncCalendarEventsProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// No-op — calendar sync is not needed with intent-based calendar integration.
  const SyncCalendarEventsProvider._(
      {required SyncCalendarEventsFamily super.from,
      required (
        int,
        int,
      )
          super.argument})
      : super(
          retry: null,
          name: r'syncCalendarEventsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$syncCalendarEventsHash();

  @override
  String toString() {
    return r'syncCalendarEventsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as (
      int,
      int,
    );
    return syncCalendarEvents(
      ref,
      argument.$1,
      argument.$2,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SyncCalendarEventsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$syncCalendarEventsHash() =>
    r'670b0960a35dd046bb09a0a28abd4120afd47245';

/// No-op — calendar sync is not needed with intent-based calendar integration.

final class SyncCalendarEventsFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<void>,
            (
              int,
              int,
            )> {
  const SyncCalendarEventsFamily._()
      : super(
          retry: null,
          name: r'syncCalendarEventsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// No-op — calendar sync is not needed with intent-based calendar integration.

  SyncCalendarEventsProvider call(
    int year,
    int week,
  ) =>
      SyncCalendarEventsProvider._(argument: (
        year,
        week,
      ), from: this);

  @override
  String toString() => r'syncCalendarEventsProvider';
}
