import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../constants/style.dart';

/// A reusable status selector dropdown
/// Used in goal_card.dart and goal_details_bottom_sheet.dart
class StatusDropdown extends StatelessWidget {
  final String currentStatus;
  final ValueChanged<String> onStatusChanged;
  final double fontSize;
  final EdgeInsetsGeometry? padding;

  const StatusDropdown({
    super.key,
    required this.currentStatus,
    required this.onStatusChanged,
    this.fontSize = 12,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor(currentStatus);

    return PopupMenuButton<String>(
      onSelected: onStatusChanged,
      color: surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
      ),
      offset: const Offset(0, 40),
      itemBuilder: (context) => kStatusOptions.map((String status) {
        return PopupMenuItem<String>(
          value: status,
          child: Text(
            status,
            style: const TextStyle(fontSize: 13, color: textPrimary),
          ),
        );
      }).toList(),
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: spacingS, vertical: 5),
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(radiusRound),
          border: Border.all(
            color: statusColor.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentStatus,
              style: TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: fontSize,
              ),
            ),
            const SizedBox(width: spacingXS),
            Icon(
              Icons.arrow_drop_down,
              color: textPrimary,
              size: fontSize + 6,
            ),
          ],
        ),
      ),
    );
  }
}
