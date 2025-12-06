import 'package:flutter/material.dart';
import '../utils/styles.dart';

/// A circular floating add button
/// Used in home_page.dart
class CircularAddButton extends StatelessWidget {
  final VoidCallback onTap;
  final double size;
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;

  const CircularAddButton({
    super.key,
    required this.onTap,
    this.size = 52,
    this.backgroundColor = primaryCyan,
    this.iconColor = bgPrimary,
    this.icon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [glowShadow],
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: size * 0.54,
        ),
      ),
    );
  }
}
