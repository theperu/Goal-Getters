import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import '../utils/styles.dart';

/// A linear progress section with label, count, progress bar, and percentage
/// Used in dashboard Year Overview section
class LinearProgressSection extends StatelessWidget {
  final String label;
  final int completed;
  final int total;
  final Color progressColor;
  final Color? backgroundColor;

  const LinearProgressSection({
    super.key,
    required this.label,
    required this.completed,
    required this.total,
    required this.progressColor,
    this.backgroundColor,
  });

  double get _completionRate => total > 0 ? (completed / total) : 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: bodyLarge,
            ),
            Text(
              '$completed/$total',
              style: labelSmall,
            ),
          ],
        ),
        const SizedBox(height: spacingS),
        MoonLinearProgress(
          value: _completionRate,
          height: 10,
          borderRadius: BorderRadius.circular(radiusSmall),
          backgroundColor: backgroundColor ?? bgInput,
          color: progressColor,
        ),
        const SizedBox(height: spacingXS),
        Text(
          '${(_completionRate * 100).toInt()}% complete',
          style: caption,
        ),
      ],
    );
  }
}
