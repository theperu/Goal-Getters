import 'package:flutter/material.dart';
import '../utils/styles.dart';

/// An animated pill-style tab switcher
/// Used in goals_list.dart for Weekly/Yearly switching
class TabSwitcher extends StatelessWidget {
  final TabController tabController;
  final List<String> tabs;
  final double height;
  final Color backgroundColor;
  final Color pillColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;

  const TabSwitcher({
    super.key,
    required this.tabController,
    required this.tabs,
    this.height = 48,
    this.backgroundColor = bgTertiary,
    this.pillColor = Colors.white,
    this.selectedTextColor = bgPrimary,
    this.unselectedTextColor = textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      padding: const EdgeInsets.all(spacingXS),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / tabs.length;
          return Stack(
            children: [
              // Animated sliding pill
              AnimatedPositioned(
                duration: animationFast,
                curve: Curves.easeOut,
                left: tabController.index * tabWidth,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: pillColor,
                    borderRadius: BorderRadius.circular((height - spacingS) / 2),
                  ),
                ),
              ),
              // Tab buttons
              Row(
                children: List.generate(tabs.length, (index) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => tabController.animateTo(index),
                      child: Container(
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: AnimatedDefaultTextStyle(
                          duration: animationFast,
                          style: TextStyle(
                            color: tabController.index == index
                                ? selectedTextColor
                                : unselectedTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          child: Text(tabs[index]),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
