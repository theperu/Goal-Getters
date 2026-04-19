import 'package:flutter/material.dart';
import '../../constants/style.dart';

/// A small stat card with title, value, and colored indicator
/// Used in dashboard for showing Todo, In Progress, Done, Blocked counts
class MiniStatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final Color? backgroundColor;

  const MiniStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? surface,
        boxShadow: [shadowSm],
        borderRadius: BorderRadius.circular(radiusMedium),
        border: Border.all(color: borderSoft, width: 2),
      ),
      padding: paddingAllL,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: labelSmall,
          ),
          const SizedBox(height: spacingS),
          Row(
            children: [
              Container(
                width: spacingS,
                height: spacingS,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: spacingS),
              Text(
                value,
                style: headingLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
