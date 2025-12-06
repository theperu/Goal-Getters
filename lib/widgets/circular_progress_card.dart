import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import '../utils/styles.dart';
import 'styled_container.dart';

/// A card with a circular progress indicator
/// Used in dashboard.dart for the Week Progress Header
class CircularProgressCard extends StatelessWidget {
  final String title;
  final double progressValue;
  final int completed;
  final int total;
  final double size;
  final double strokeWidth;
  final Color progressColor;
  final Color? backgroundColor;
  final Color? progressBackgroundColor;

  const CircularProgressCard({
    super.key,
    required this.title,
    required this.progressValue,
    required this.completed,
    required this.total,
    this.size = 140,
    this.strokeWidth = 12,
    this.progressColor = primaryCyan,
    this.backgroundColor,
    this.progressBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return StyledContainer(
      width: double.infinity,
      borderRadius: radiusLarge,
      backgroundColor: backgroundColor,
      padding: paddingAllXXL,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: accentTitle.copyWith(fontSize: 24, color: progressColor),
          ),
          const SizedBox(height: spacingXL),
          SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                MoonCircularProgress(
                  value: progressValue,
                  sizeValue: size,
                  strokeWidth: strokeWidth,
                  backgroundColor: progressBackgroundColor ?? bgInput,
                  color: progressColor,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(progressValue * 100).toInt()}%',
                      style: progressPercentageLarge,
                    ),
                    Text(
                      '$completed/$total goals',
                      style: labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
