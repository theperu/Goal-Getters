import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/reflection.dart';
import '../services/database/repositories/reflection_repository.dart';

part 'reflection_provider.g.dart';

// =============================================================================
// Reflections CRUD
// =============================================================================

@Riverpod(keepAlive: true)
class Reflections extends _$Reflections {
  @override
  Future<List<Reflection>> build() async {
    return await ref.read(reflectionRepositoryProvider).selectAll();
  }

  Future<void> saveReflection(Reflection reflection) async {
    state = await AsyncValue.guard(() async {
      final repo = ref.read(reflectionRepositoryProvider);
      final existing = await repo.selectByDate(reflection.date);
      if (existing != null) {
        await repo.update(reflection.copy(id: existing.id));
      } else {
        await repo.insert(reflection);
      }
      return _refresh();
    });
  }

  Future<void> updateReflection(Reflection reflection) async {
    state = await AsyncValue.guard(() async {
      await ref.read(reflectionRepositoryProvider).update(reflection);
      return _refresh();
    });
  }

  Future<void> removeReflection(int id) async {
    state = await AsyncValue.guard(() async {
      await ref.read(reflectionRepositoryProvider).deleteById(id);
      return _refresh();
    });
  }

  Future<List<Reflection>> _refresh() async {
    ref.invalidate(todayReflectionProvider);
    ref.invalidate(recentReflectionsProvider);
    ref.invalidate(reflectionsForMonthProvider);
    return await ref.read(reflectionRepositoryProvider).selectAll();
  }
}

// =============================================================================
// Today's reflection
// =============================================================================

@riverpod
Future<Reflection?> todayReflection(Ref ref) async {
  ref.watch(reflectionsProvider);
  final now = DateTime.now();
  final dateStr =
      '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  return await ref.read(reflectionRepositoryProvider).selectByDate(dateStr);
}

// =============================================================================
// Recent reflections (for history list)
// =============================================================================

@riverpod
Future<List<Reflection>> recentReflections(Ref ref) async {
  ref.watch(reflectionsProvider);
  return await ref.read(reflectionRepositoryProvider).selectRecent(limit: 10);
}

// =============================================================================
// Reflections for a given month (for calendar view)
// =============================================================================

@riverpod
Future<List<Reflection>> reflectionsForMonth(
    Ref ref, int year, int month) async {
  ref.watch(reflectionsProvider);
  return await ref.read(reflectionRepositoryProvider).selectByMonth(year, month);
}
