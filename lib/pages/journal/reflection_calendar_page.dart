import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/style.dart';
import '../../model/reflection.dart';
import '../../providers/reflection_provider.dart';
import '../../ui/extensions.dart';
import 'widgets/mood_selector.dart';

const _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December'
];

class ReflectionCalendarPage extends ConsumerStatefulWidget {
  const ReflectionCalendarPage({super.key});

  @override
  ConsumerState<ReflectionCalendarPage> createState() =>
      _ReflectionCalendarPageState();
}

class _ReflectionCalendarPageState
    extends ConsumerState<ReflectionCalendarPage> {
  late int _year;
  late int _month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _year = now.year;
    _month = now.month;
  }

  void _previousMonth() {
    setState(() {
      _month--;
      if (_month < 1) {
        _month = 12;
        _year--;
      }
    });
  }

  void _nextMonth() {
    final now = DateTime.now();
    // Don't go past current month
    if (_year == now.year && _month >= now.month) return;
    setState(() {
      _month++;
      if (_month > 12) {
        _month = 1;
        _year++;
      }
    });
  }

  void _showReflectionDetail(Reflection reflection) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ReflectionDetailSheet(
        reflection: reflection,
        onEdit: (updated) async {
          await ref
              .read(reflectionsProvider.notifier)
              .updateReflection(updated);
          if (mounted) Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reflectionsAsync =
        ref.watch(reflectionsForMonthProvider(_year, _month));

    return Scaffold(
      backgroundColor: bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // ── App bar ────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  spacingS, spacingL, spacingXXL, spacingL),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: textMain,
                  ),
                  const SizedBox(width: spacingS),
                  Text('Reflection History', style: headingMedium),
                ],
              ),
            ),

            // ── Month navigator ────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: spacingXXL),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _previousMonth,
                    icon: const Icon(Icons.chevron_left_rounded, size: 28),
                    color: textMain,
                  ),
                  Text(
                    '${_monthNames[_month - 1]} $_year',
                    style: headingSmall,
                  ),
                  IconButton(
                    onPressed: _nextMonth,
                    icon: const Icon(Icons.chevron_right_rounded, size: 28),
                    color: (() {
                      final now = DateTime.now();
                      return (_year == now.year && _month >= now.month)
                          ? textMuted
                          : textMain;
                    })(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: spacingL),

            // ── Day-of-week headers ────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: spacingXXL),
              child: Row(
                children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                    .map((d) => Expanded(
                          child: Center(
                            child: Text(d,
                                style: caption.withColor(textMuted)),
                          ),
                        ))
                    .toList(),
              ),
            ),

            const SizedBox(height: spacingS),

            // ── Calendar grid ──────────────────
            Expanded(
              child: reflectionsAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (reflections) {
                  final reflectionMap = {
                    for (final r in reflections) r.date: r
                  };
                  return _CalendarGrid(
                    year: _year,
                    month: _month,
                    reflections: reflectionMap,
                    onDayTap: (reflection) {
                      if (reflection != null) {
                        _showReflectionDetail(reflection);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Calendar Grid
// =============================================================================

class _CalendarGrid extends StatelessWidget {
  final int year;
  final int month;
  final Map<String, Reflection> reflections;
  final void Function(Reflection?) onDayTap;

  const _CalendarGrid({
    required this.year,
    required this.month,
    required this.reflections,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    // Monday = 1, so offset = weekday - 1
    final startOffset = firstDay.weekday - 1;

    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: spacingXXL),
      child: GridView.builder(
        itemCount: startOffset + daysInMonth,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: spacingXS,
          crossAxisSpacing: spacingXS,
        ),
        itemBuilder: (context, index) {
          if (index < startOffset) return const SizedBox.shrink();

          final day = index - startOffset + 1;
          final dateStr =
              '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
          final reflection = reflections[dateStr];
          final isToday = dateStr == todayStr;
          final isFuture = DateTime(year, month, day).isAfter(today);

          return GestureDetector(
            onTap: reflection != null ? () => onDayTap(reflection) : null,
            child: Container(
              decoration: BoxDecoration(
                color: reflection != null
                    ? (moodColors[reflection.mood] ?? textMuted)
                        .withValues(alpha: 0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(radiusSmall),
                border: isToday
                    ? Border.all(color: primaryLavender, width: 2)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$day',
                    style: bodySmall.withColor(
                      isFuture ? textMuted : textMain,
                    ),
                  ),
                  if (reflection != null) ...[
                    const SizedBox(height: 2),
                    Icon(
                      moodIcons[reflection.mood] ?? Icons.sentiment_neutral,
                      size: 16,
                      color: moodColors[reflection.mood] ?? textMuted,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// =============================================================================
// Reflection Detail Sheet
// =============================================================================

class _ReflectionDetailSheet extends StatefulWidget {
  final Reflection reflection;
  final Future<void> Function(Reflection) onEdit;

  const _ReflectionDetailSheet({
    required this.reflection,
    required this.onEdit,
  });

  @override
  State<_ReflectionDetailSheet> createState() =>
      _ReflectionDetailSheetState();
}

class _ReflectionDetailSheetState extends State<_ReflectionDetailSheet> {
  bool _editing = false;
  late int _mood;
  late TextEditingController _textController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _mood = widget.reflection.mood;
    _textController = TextEditingController(text: widget.reflection.text ?? '');
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moodIcon = moodIcons[widget.reflection.mood] ?? Icons.sentiment_neutral;
    final moodColor = moodColors[widget.reflection.mood] ?? textMuted;

    return Container(
      margin: const EdgeInsets.only(top: 120),
      decoration: const BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXL)),
      ),
      padding: EdgeInsets.only(
        left: spacingXXL,
        right: spacingXXL,
        top: spacingXXL,
        bottom: MediaQuery.of(context).viewInsets.bottom + spacingXXL,
      ),
      child: SingleChildScrollView(
        child: _editing ? _buildEditView() : _buildReadView(moodIcon, moodColor),
      ),
    );
  }

  Widget _buildReadView(IconData moodIcon, Color moodColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: borderSoft,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: spacingL),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_formatDate(widget.reflection.date), style: headingSmall),
            GestureDetector(
              onTap: () => setState(() => _editing = true),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: spacingM, vertical: spacingXS),
                decoration: BoxDecoration(
                  color: lavender.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(radiusRound),
                ),
                child: Text('Edit',
                    style: labelSmall.withColor(primaryLavender).semiBold),
              ),
            ),
          ],
        ),
        const SizedBox(height: spacingXXL),
        // Mood display
        Row(
          children: [
            Icon(moodIcon, size: 32, color: moodColor),
            const SizedBox(width: spacingM),
            Text(widget.reflection.moodLabel, style: headingMedium),
          ],
        ),
        if (widget.reflection.text != null &&
            widget.reflection.text!.isNotEmpty) ...[
          const SizedBox(height: spacingXXL),
          Text(widget.reflection.text!, style: bodyLarge),
        ],
        const SizedBox(height: spacingL),
      ],
    );
  }

  Widget _buildEditView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: borderSoft,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: spacingL),
        Text('Edit Reflection', style: headingMedium),
        const SizedBox(height: spacingXS),
        Text(
          _formatDate(widget.reflection.date),
          style: bodyMedium.withColor(textMuted),
        ),
        const SizedBox(height: spacingXXL),
        MoodSelector(
          selected: _mood,
          onChanged: (m) => setState(() => _mood = m),
        ),
        const SizedBox(height: spacingXXL),
        Container(
          decoration: inputDecoration,
          padding: paddingAllL,
          child: TextField(
            controller: _textController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Capture your thoughts here...',
              hintStyle: bodyMedium.withColor(textMuted),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            style: bodyMedium,
          ),
        ),
        const SizedBox(height: spacingXXL),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _saving
                ? null
                : () async {
                    setState(() => _saving = true);
                    final updated = widget.reflection.copy(
                      mood: _mood,
                      text: _textController.text.trim().isEmpty
                          ? null
                          : _textController.text.trim(),
                      clearText: _textController.text.trim().isEmpty,
                    );
                    await widget.onEdit(updated);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryLavender,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radiusLarge),
              ),
              elevation: 0,
            ),
            child:
                Text('Save Changes', style: bodyLarge.withColor(Colors.white).bold),
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    final parts = dateStr.split('-');
    final date = DateTime(
        int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
    return '${_monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }
}
