import 'package:flutter/material.dart';
import '../../../constants/style.dart';
import '../../../ui/extensions.dart';

class JournalPromptCard extends StatelessWidget {
  final TextEditingController controller;

  const JournalPromptCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 3,
      maxLength: 500,
      decoration: InputDecoration(
        hintText: 'Capture your thoughts here...',
        hintStyle: bodyMedium.withColor(textMuted),
        counterStyle: caption.withColor(textMuted),
        filled: true,
        fillColor: surface,
        contentPadding: paddingAllL,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
          borderSide: const BorderSide(color: borderSoft, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
          borderSide: const BorderSide(color: primaryLavender, width: 2),
        ),
      ),
      style: bodyMedium,
    );
  }
}
