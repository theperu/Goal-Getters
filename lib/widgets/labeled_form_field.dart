import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import '../utils/styles.dart';

/// A form field with a styled label above it
/// Used in goal_form.dart for Goal Name, Notes, etc.
class LabeledTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? hintTextColor;
  final Color? labelColor;
  final TextCapitalization textCapitalization;

  const LabeledTextField({
    super.key,
    required this.label,
    required this.controller,
    this.onChanged,
    this.hintText,
    this.backgroundColor,
    this.textColor,
    this.hintTextColor,
    this.labelColor,
    this.textCapitalization = TextCapitalization.sentences,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: labelLarge.copyWith(color: labelColor ?? textPrimary),
        ),
        const SizedBox(height: spacingS),
        MoonTextInput(
          controller: controller,
          backgroundColor: backgroundColor ?? bgSecondary,
          textColor: textColor ?? textPrimary,
          hintTextColor: hintTextColor ?? textMuted,
          hintText: hintText,
          textCapitalization: textCapitalization,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// A text area with a styled label above it
/// Used in goal_form.dart for Notes field
class LabeledTextArea extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final double height;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? labelColor;
  final TextCapitalization textCapitalization;

  const LabeledTextArea({
    super.key,
    required this.label,
    required this.controller,
    this.onChanged,
    this.hintText,
    this.height = 200,
    this.backgroundColor,
    this.textColor,
    this.labelColor,
    this.textCapitalization = TextCapitalization.sentences,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: labelLarge.copyWith(color: labelColor ?? textPrimary),
        ),
        const SizedBox(height: spacingS),
        MoonTextArea(
          controller: controller,
          backgroundColor: backgroundColor ?? bgSecondary,
          textColor: textColor ?? textPrimary,
          height: height,
          hintText: hintText,
          textCapitalization: textCapitalization,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// A styled label for form sections
class FormLabel extends StatelessWidget {
  final String text;
  final Color? color;

  const FormLabel({
    super.key,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: labelLarge.copyWith(color: color ?? textPrimary),
    );
  }
}
