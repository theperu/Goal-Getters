import 'package:flutter/material.dart';
import '../../constants/style.dart';

/// A styled section header text widget
/// Used for section titles like "This Week", "Year Overview", etc.
class SectionHeader extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry? padding;

  const SectionHeader({
    super.key,
    required this.text,
    this.fontSize = 20,
    this.color = textPrimary,
    this.fontWeight = FontWeight.bold,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );

    if (padding != null) {
      return Padding(padding: padding!, child: textWidget);
    }
    return textWidget;
  }
}
