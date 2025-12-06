import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import '../utils/goal_helpers.dart';
import '../utils/styles.dart';

/// A reusable status selector dropdown
/// Used in goal_card.dart and goal_details_bottom_sheet.dart
class StatusDropdown extends StatefulWidget {
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
  State<StatusDropdown> createState() => _StatusDropdownState();
}

class _StatusDropdownState extends State<StatusDropdown> {
  bool _showDropdown = false;
  final String _dropdownGroupId = 'statusDropdown_${DateTime.now().millisecondsSinceEpoch}';

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor(widget.currentStatus);

    return MoonDropdown(
      show: _showDropdown,
      groupId: _dropdownGroupId,
      constrainWidthToChild: false,
      backgroundColor: bgSecondary,
      onTapOutside: () => setState(() => _showDropdown = false),
      content: SizedBox(
        width: 160,
        child: Column(
          children: kStatusOptions.map((String status) {
            return MoonMenuItem(
              onTap: () {
                setState(() => _showDropdown = false);
                widget.onStatusChanged(status);
              },
              label: Text(
                status,
                style: const TextStyle(
                  fontSize: 13,
                  color: textPrimary,
                ),
              ),
            );
          }).toList(),
        ),
      ),
      child: GestureDetector(
        onTap: () => setState(() => _showDropdown = !_showDropdown),
        child: Container(
          padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: spacingS, vertical: 5),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(spacingS),
            border: Border.all(
              color: statusColor.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.currentStatus,
                style: TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: widget.fontSize,
                ),
              ),
              const SizedBox(width: spacingXS),
              Icon(
                Icons.arrow_drop_down,
                color: textPrimary,
                size: widget.fontSize + 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
