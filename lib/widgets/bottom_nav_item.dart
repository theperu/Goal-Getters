import 'package:flutter/material.dart';
import '../utils/styles.dart';

/// A bottom navigation item with animated selection indicator
/// Used in home_page.dart
class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color unselectedColor;

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.onTap,
    this.selectedColor = primaryCyan,
    this.unselectedColor = textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: paddingVerticalS,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected ? selectedColor : unselectedColor,
                size: iconSizeXL,
              ),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: animationFast,
                width: isSelected ? spacingXL : 0,
                height: 3,
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
