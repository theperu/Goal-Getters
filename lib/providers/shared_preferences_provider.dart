import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider that holds the pre-initialized SharedPreferences instance.
/// Must be overridden in ProviderScope at app startup.
final sharedPrefProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPrefProvider must be overridden at startup');
});
