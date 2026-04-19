// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reflection_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reflectionRepository)
const reflectionRepositoryProvider = ReflectionRepositoryProvider._();

final class ReflectionRepositoryProvider extends $FunctionalProvider<
    ReflectionRepository,
    ReflectionRepository,
    ReflectionRepository> with $Provider<ReflectionRepository> {
  const ReflectionRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'reflectionRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$reflectionRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReflectionRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ReflectionRepository create(Ref ref) {
    return reflectionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReflectionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReflectionRepository>(value),
    );
  }
}

String _$reflectionRepositoryHash() =>
    r'157d6b5cda9173dd6ec33aa3f9c3ce66d8982add';
