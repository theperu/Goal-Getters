import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calendar_sync_provider.g.dart';

/// No-op — calendar sync is not needed with intent-based calendar integration.
@riverpod
Future<void> syncCalendarEvents(Ref ref, int year, int week) async {}
