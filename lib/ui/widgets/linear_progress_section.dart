import 'package:flutter/material.dart';
import '../../constants/style.dart';

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
        ClipRRect(
          borderRadius: BorderRadius.circular(radiusSmall),
          child: LinearProgressIndicator(
            value: _completionRate,
            minHeight: 10,
            backgroundColor: backgroundColor ?? bgInput,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
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
