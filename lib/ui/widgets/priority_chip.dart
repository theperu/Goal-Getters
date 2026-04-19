import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../constants/style.dart';

/// A chip that displays priority with a flag icon
/// Used in goal_card.dart and goal_details_bottom_sheet.dart
class PriorityChip extends StatelessWidget {
  final String importance;
  final Color? backgroundColor;
  final double iconSize;
  final double fontSize;

  const PriorityChip({
    super.key,
    required this.importance,
    this.backgroundColor,
    this.iconSize = 14,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final color = getPriorityColor(importance);
    final text = getPriorityText(importance);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: spacingS, vertical: spacingXS),
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(radiusRound),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.flag_rounded,
            size: iconSize,
            color: color,
          ),
          const SizedBox(width: spacingXS),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
