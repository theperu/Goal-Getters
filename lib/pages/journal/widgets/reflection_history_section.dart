import 'package:flutter/material.dart';
import '../../../constants/style.dart';
import '../../../model/reflection.dart';
import '../../../ui/extensions.dart';

import '../widgets/mood_selector.dart';

class ReflectionHistorySection extends StatelessWidget {
  final List<Reflection> reflections;
  final void Function(Reflection) onTap;
  final VoidCallback onViewAll;

  const ReflectionHistorySection({
    super.key,
    required this.reflections,
    required this.onTap,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: spacingXXL),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Reflection History', style: headingSmall),
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  'View All',
                  style: bodyMedium.withColor(primaryLavender).semiBold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: spacingL),

        // History list
        ...reflections.take(5).map(
              (r) => _ReflectionHistoryTile(
                reflection: r,
                onTap: () => onTap(r),
              ),
            ),
      ],
    );
  }
}

class _ReflectionHistoryTile extends StatelessWidget {
  final Reflection reflection;
  final VoidCallback onTap;

  const _ReflectionHistoryTile({
    required this.reflection,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icon = moodIcons[reflection.mood] ?? Icons.sentiment_neutral;
    final moodColor = moodColors[reflection.mood] ?? textMuted;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: spacingXXL, vertical: spacingS),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mood badge
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: moodColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 22, color: moodColor),
            ),
            const SizedBox(width: spacingM),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _relativeDay(reflection.date),
                        style: labelMedium.withColor(textSecondary),
                      ),
                      Text(
                        _formatTime(reflection.createdAt),
                        style: caption,
                      ),
                    ],
                  ),
                  if (reflection.text != null &&
                      reflection.text!.isNotEmpty) ...[
                    const SizedBox(height: spacingXS),
                    Text(
                      reflection.text!,
                      style: bodyMedium.withColor(textMain),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _relativeDay(String dateStr) {
    final parts = dateStr.split('-');
    final date = DateTime(
        int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final diff = today.difference(date).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) {
      const days = [
        'Monday', 'Tuesday', 'Wednesday', 'Thursday',
        'Friday', 'Saturday', 'Sunday'
      ];
      return days[date.weekday - 1];
    }
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final h = dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = h >= 12 ? 'PM' : 'AM';
    final hour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '$hour:$m $ampm';
  }
}
