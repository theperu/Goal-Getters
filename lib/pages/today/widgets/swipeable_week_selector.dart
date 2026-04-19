import 'package:flutter/material.dart';
import 'week_day_selector.dart';

class SwipeableWeekSelector extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;

  const SwipeableWeekSelector({
    super.key,
    required this.selectedDate,
    required this.onDaySelected,
  });

  @override
  State<SwipeableWeekSelector> createState() => _SwipeableWeekSelectorState();
}

class _SwipeableWeekSelectorState extends State<SwipeableWeekSelector> {
  late PageController _pageController;
  final _today = DateTime.now();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 500);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DateTime _weekStartForPage(int page) {
    final todayWeekStart = _today.subtract(Duration(days: _today.weekday - 1));
    final offset = page - 500;
    return todayWeekStart.add(Duration(days: 7 * offset));
  }

  void _onPageChanged(int page) {
    final weekStart = _weekStartForPage(page);
    final newDate = weekStart.add(Duration(days: widget.selectedDate.weekday - 1));
    widget.onDaySelected(newDate);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, page) {
          final weekStart = _weekStartForPage(page);
          return WeekDaySelector(
            weekStart: weekStart,
            selectedDate: widget.selectedDate,
            today: _today,
            onDaySelected: widget.onDaySelected,
          );
        },
      ),
    );
  }
}
