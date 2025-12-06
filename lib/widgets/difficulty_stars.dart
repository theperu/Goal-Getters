import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import '../utils/goal_helpers.dart';
import '../utils/styles.dart';

/// A widget that displays difficulty as star icons
/// Used in goal_card.dart and goal_details_bottom_sheet.dart
class DifficultyStars extends StatelessWidget {
  final String difficulty;
  final double starSize;
  final Color starColor;
  final double spacing;

  const DifficultyStars({
    super.key,
    required this.difficulty,
    this.starSize = 14,
    this.starColor = difficultyStarColor,
    this.spacing = 2,
  });

  @override
  Widget build(BuildContext context) {
    final level = getDifficultyLevel(difficulty);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        level,
        (index) => Padding(
          padding: EdgeInsets.only(right: index < level - 1 ? spacing : 0),
          child: Icon(
            Icons.star,
            size: starSize,
            color: starColor,
          ),
        ),
      ),
    );
  }
}

/// A chip that displays difficulty stars
/// Used in goal_card.dart
class DifficultyChip extends StatelessWidget {
  final String difficulty;
  final MoonChipSize chipSize;
  final Color? backgroundColor;
  final double starSize;

  const DifficultyChip({
    super.key,
    required this.difficulty,
    this.chipSize = MoonChipSize.sm,
    this.backgroundColor,
    this.starSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return MoonChip(
      chipSize: chipSize,
      backgroundColor: backgroundColor ?? Colors.black.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(radiusSmall),
      gap: 0,
      label: DifficultyStars(
        difficulty: difficulty,
        starSize: starSize,
      ),
    );
  }
}
