import 'package:flutter/material.dart';
import '../../constants/style.dart';

/// A form field with a styled label above it
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
        TextField(
          controller: controller,
          style: TextStyle(color: textColor ?? textPrimary),
          textCapitalization: textCapitalization,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: hintTextColor ?? textMuted),
            filled: true,
            fillColor: backgroundColor ?? surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
              borderSide: const BorderSide(color: borderSoft, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
              borderSide: const BorderSide(color: borderSoft, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
              borderSide: const BorderSide(color: primaryLavender, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: spacingL, vertical: spacingM),
          ),
        ),
      ],
    );
  }
}

/// A text area with a styled label above it
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
        SizedBox(
          height: height,
          child: TextField(
            controller: controller,
            style: TextStyle(color: textColor ?? textPrimary),
            textCapitalization: textCapitalization,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: textMuted),
              filled: true,
              fillColor: backgroundColor ?? surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radiusMedium),
                borderSide: const BorderSide(color: borderSoft, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radiusMedium),
                borderSide: const BorderSide(color: borderSoft, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radiusMedium),
                borderSide: const BorderSide(color: primaryLavender, width: 2),
              ),
              contentPadding: const EdgeInsets.all(spacingM),
            ),
          ),
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
