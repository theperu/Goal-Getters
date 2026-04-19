import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'shared_preferences_provider.dart';

part 'theme_mode_provider.g.dart';

@Riverpod(keepAlive: true)
class AppThemeMode extends _$AppThemeMode {
  static const _key = 'dark_mode_enabled';

  @override
  bool build() {
    final prefs = ref.watch(sharedPrefProvider);
    return prefs.getBool(_key) ?? true; // dark by default
  }

  Future<void> toggle() async {
    final prefs = ref.read(sharedPrefProvider);
    final newValue = !state;
    await prefs.setBool(_key, newValue);
    state = newValue;
  }

  bool get isDarkMode => state;

  ThemeMode get themeMode => state ? ThemeMode.dark : ThemeMode.light;
}
