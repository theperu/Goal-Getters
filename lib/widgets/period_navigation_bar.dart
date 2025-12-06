import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import '../utils/styles.dart';

/// A navigation bar with left/right arrows and centered content
/// Used for week/year navigation in goals_list.dart
class PeriodNavigationBar extends StatelessWidget {
  final Widget centerContent;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final Color? backgroundColor;
  final Color arrowColor;
  final Color arrowBackgroundColor;

  const PeriodNavigationBar({
    super.key,
    required this.centerContent,
    required this.onPrevious,
    required this.onNext,
    this.backgroundColor,
    this.arrowColor = primaryCyan,
    this.arrowBackgroundColor = bgInput,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: backgroundColor ?? bgSecondary,
        shape: MoonSquircleBorder(
          borderRadius: BorderRadius.circular(radiusMedium).squircleBorderRadius(context),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: spacingM, vertical: spacingS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MoonButton.icon(
            buttonSize: MoonButtonSize.sm,
            backgroundColor: arrowBackgroundColor,
            icon: Icon(
              MoonIcons.controls_chevron_left_24_light,
              color: arrowColor,
              size: iconSizeMedium,
            ),
            onTap: onPrevious,
          ),
          Expanded(child: centerContent),
          MoonButton.icon(
            buttonSize: MoonButtonSize.sm,
            backgroundColor: arrowBackgroundColor,
            icon: Icon(
              MoonIcons.controls_chevron_right_24_light,
              color: arrowColor,
              size: iconSizeMedium,
            ),
            onTap: onNext,
          ),
        ],
      ),
    );
  }
}

/// Helper widget for weekly navigation content
class WeekNavigationContent extends StatelessWidget {
  final int week;
  final int year;
  final String weekRange;

  const WeekNavigationContent({
    super.key,
    required this.week,
    required this.year,
    required this.weekRange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Week $week, $year',
          style: bodyLarge,
        ),
        Text(
          weekRange,
          style: labelSmall,
        ),
      ],
    );
  }
}

/// Helper widget for yearly navigation content
class YearNavigationContent extends StatelessWidget {
  final int year;

  const YearNavigationContent({
    super.key,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$year',
      textAlign: TextAlign.center,
      style: headingSmall,
    );
  }
}
