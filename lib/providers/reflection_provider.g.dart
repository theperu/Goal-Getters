// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reflection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Reflections)
const reflectionsProvider = ReflectionsProvider._();

final class ReflectionsProvider
    extends $AsyncNotifierProvider<Reflections, List<Reflection>> {
  const ReflectionsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'reflectionsProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$reflectionsHash();

  @$internal
  @override
  Reflections create() => Reflections();
}

String _$reflectionsHash() => r'291ee6245f5db70fb5fcb5f78c2bcf9d17ba03a9';

abstract class _$Reflections extends $AsyncNotifier<List<Reflection>> {
  FutureOr<List<Reflection>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<Reflection>>, List<Reflection>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Reflection>>, List<Reflection>>,
        AsyncValue<List<Reflection>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(todayReflection)
const todayReflectionProvider = TodayReflectionProvider._();

final class TodayReflectionProvider extends $FunctionalProvider<
        AsyncValue<Reflection?>, Reflection?, FutureOr<Reflection?>>
    with $FutureModifier<Reflection?>, $FutureProvider<Reflection?> {
  const TodayReflectionProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'todayReflectionProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$todayReflectionHash();

  @$internal
  @override
  $FutureProviderElement<Reflection?> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Reflection?> create(Ref ref) {
    return todayReflection(ref);
  }
}

String _$todayReflectionHash() => r'dfdc924fb105dc0216591a69cb984523343caca4';

@ProviderFor(recentReflections)
const recentReflectionsProvider = RecentReflectionsProvider._();

final class RecentReflectionsProvider extends $FunctionalProvider<
        AsyncValue<List<Reflection>>,
        List<Reflection>,
        FutureOr<List<Reflection>>>
    with $FutureModifier<List<Reflection>>, $FutureProvider<List<Reflection>> {
  const RecentReflectionsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'recentReflectionsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$recentReflectionsHash();

  @$internal
  @override
  $FutureProviderElement<List<Reflection>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Reflection>> create(Ref ref) {
    return recentReflections(ref);
  }
}

String _$recentReflectionsHash() => r'ed91bbe5b5c6fa9b2e4462e3f2fee37ec1484171';

@ProviderFor(reflectionsForMonth)
const reflectionsForMonthProvider = ReflectionsForMonthFamily._();

final class ReflectionsForMonthProvider extends $FunctionalProvider<
        AsyncValue<List<Reflection>>,
        List<Reflection>,
        FutureOr<List<Reflection>>>
    with $FutureModifier<List<Reflection>>, $FutureProvider<List<Reflection>> {
  const ReflectionsForMonthProvider._(
      {required ReflectionsForMonthFamily super.from,
      required (
        int,
        int,
      )
          super.argument})
      : super(
          retry: null,
          name: r'reflectionsForMonthProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$reflectionsForMonthHash();

  @override
  String toString() {
    return r'reflectionsForMonthProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Reflection>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Reflection>> create(Ref ref) {
    final argument = this.argument as (
      int,
      int,
    );
    return reflectionsForMonth(
      ref,
      argument.$1,
      argument.$2,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ReflectionsForMonthProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reflectionsForMonthHash() =>
    r'7a582eec6e765fb8c1e819946ed9808b4537bb0a';

final class ReflectionsForMonthFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<List<Reflection>>,
            (
              int,
              int,
            )> {
  const ReflectionsForMonthFamily._()
      : super(
          retry: null,
          name: r'reflectionsForMonthProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ReflectionsForMonthProvider call(
    int year,
    int month,
  ) =>
      ReflectionsForMonthProvider._(argument: (
        year,
        month,
      ), from: this);

  @override
  String toString() => r'reflectionsForMonthProvider';
}
