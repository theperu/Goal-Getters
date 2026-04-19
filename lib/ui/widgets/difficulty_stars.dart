import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../constants/style.dart';

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
  final Color? backgroundColor;
  final double starSize;

  const DifficultyChip({
    super.key,
    required this.difficulty,
    this.backgroundColor,
    this.starSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: spacingS, vertical: spacingXS),
      decoration: BoxDecoration(
        color: backgroundColor ?? borderSoft,
        borderRadius: BorderRadius.circular(radiusRound),
      ),
      child: DifficultyStars(
        difficulty: difficulty,
        starSize: starSize,
      ),
    );
  }
}
