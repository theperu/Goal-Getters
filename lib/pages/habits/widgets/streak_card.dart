import 'package:flutter/material.dart';
import '../../../constants/style.dart';

/// Streak stat card (Current Best / All-time Best).
class StreakCard extends StatelessWidget {
  final String label;
  final int weeks;
  final String? habitName;

  const StreakCard({
    super.key,
    required this.label,
    required this.weeks,
    this.habitName,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: cardDecoration,
        child: Column(
          children: [
            Text(
              label.toUpperCase(),
              style: caption.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$weeks',
                    style: headingXL.copyWith(color: primaryLavender),
                  ),
                  TextSpan(
                    text: weeks == 1 ? '  week' : '  weeks',
                    style: bodySmall.copyWith(color: textMuted),
                  ),
                ],
              ),
            ),
            if (habitName != null) ...[
              const SizedBox(height: 4),
              Text(
                habitName!,
                style: caption.copyWith(color: textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
