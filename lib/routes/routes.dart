import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import '../pages/goals/goal_form.dart';
import '../pages/settings/settings_page.dart';

Route<dynamic> makeRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return buildAdaptiveRoute(settings.name, const HomePage());

    case '/settings':
      return buildAdaptiveRoute(settings.name, const SettingsPage());

    case '/add-goal':
      Map<String, dynamic>? args;
      if (settings.arguments is Map<String, dynamic>?) {
        args = settings.arguments as Map<String, dynamic>?;
      }
      return buildAdaptiveRoute(
        settings.name,
        GoalForm(
          weeklyGoal: args?['weeklyGoal'],
          yearlyGoal: args?['yearlyGoal'],
          yearlyGoals: args?['yearlyGoals'] ?? const [],
          initialType: args?['initialType'],
        ),
      );

    default:
      throw 'Route ${settings.name} is not defined';
  }
}

PageRoute buildAdaptiveRoute(String? routeName, Widget viewToShow) {
  if (Platform.isAndroid) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => viewToShow,
    );
  }
  return CupertinoPageRoute(
    settings: RouteSettings(name: routeName),
    builder: (_) => viewToShow,
  );
}
