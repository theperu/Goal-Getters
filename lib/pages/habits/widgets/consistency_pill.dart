import 'package:flutter/material.dart';
import '../../../constants/style.dart';

/// Consistency pill badge (e.g., "85% Consistent").
class ConsistencyPill extends StatelessWidget {
  final double percentage;

  const ConsistencyPill({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(radiusRound),
        border: Border.all(color: borderSoft, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 16, color: primaryLavender),
          const SizedBox(width: 6),
          Text(
            '${percentage.round()}% Consistent',
            style: bodySmall.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
