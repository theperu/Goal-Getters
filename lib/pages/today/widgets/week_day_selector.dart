import 'package:flutter/material.dart';
import '../../../constants/style.dart';

class WeekDaySelector extends StatelessWidget {
  final DateTime weekStart;
  final DateTime selectedDate;
  final DateTime today;
  final ValueChanged<DateTime> onDaySelected;

  const WeekDaySelector({
    super.key,
    required this.weekStart,
    required this.selectedDate,
    required this.today,
    required this.onDaySelected,
  });

  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (i) {
          final date = weekStart.add(Duration(days: i));
          final isSelected = _isSameDay(date, selectedDate);

          return Expanded(
            child: GestureDetector(
            onTap: () => onDaySelected(date),
            child: Transform.translate(
              offset: Offset(0, isSelected ? -10 : 0),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _dayLabels[i],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? primaryLavender : textMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedContainer(
                      duration: animationFast,
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? lavender.withValues(alpha: 0.35)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? null
                            : Border.all(color: borderSoft, width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? textMain : textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isSelected ? primaryLavender : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                  ),
                ],
              ),
            ),
            ),
          );
        }),
      ),
    );
  }
}
