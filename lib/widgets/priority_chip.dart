import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import '../utils/goal_helpers.dart';
import '../utils/styles.dart';

/// A chip that displays priority with a flag icon
/// Used in goal_card.dart and goal_details_bottom_sheet.dart
class PriorityChip extends StatelessWidget {
  final String importance;
  final MoonChipSize chipSize;
  final Color? backgroundColor;
  final double iconSize;
  final double fontSize;

  const PriorityChip({
    super.key,
    required this.importance,
    this.chipSize = MoonChipSize.sm,
    this.backgroundColor,
    this.iconSize = 14,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final color = getPriorityColor(importance);
    final text = getPriorityText(importance);

    return MoonChip(
      chipSize: chipSize,
      backgroundColor: backgroundColor ?? Colors.black.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(radiusSmall),
      gap: spacingXS,
      leading: Icon(
        Icons.flag_rounded,
        size: iconSize,
        color: color,
      ),
      label: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: fontSize,
          color: color,
        ),
      ),
    );
  }
}
