import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/style.dart';
import '../../model/reflection.dart';
import '../../providers/reflection_provider.dart';
import '../../ui/extensions.dart';
import 'widgets/mood_selector.dart';
import 'widgets/journal_prompt_card.dart';
import 'widgets/reflection_history_section.dart';
import 'reflection_calendar_page.dart';

class JournalPage extends ConsumerStatefulWidget {
  const JournalPage({super.key});

  @override
  ConsumerState<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends ConsumerState<JournalPage> {
  int _selectedMood = 0; // 0 = none selected
  final _textController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _loadExistingReflection(Reflection reflection) {
    _selectedMood = reflection.mood;
    _textController.text = reflection.text ?? '';
  }

  Future<void> _saveReflection() async {
    if (_selectedMood == 0) return;

    setState(() => _isSaving = true);

    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final todayReflection =
        await ref.read(todayReflectionProvider.future);

    final reflection = Reflection(
      id: todayReflection?.id,
      mood: _selectedMood,
      text: _textController.text.trim().isEmpty
          ? null
          : _textController.text.trim(),
      date: dateStr,
      createdAt: todayReflection?.createdAt,
    );

    await ref.read(reflectionsProvider.notifier).saveReflection(reflection);

    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(todayReflection != null
              ? 'Reflection updated'
              : 'Reflection saved'),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _onHistoryReflectionTap(Reflection reflection) {
    _showEditSheet(reflection);
  }

  void _showEditSheet(Reflection reflection) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditReflectionSheet(
        reflection: reflection,
        onSave: (updated) async {
          await ref
              .read(reflectionsProvider.notifier)
              .updateReflection(updated);
          if (mounted) Navigator.pop(context);
          // Reload today's reflection if it was the one edited
          final now = DateTime.now();
          final todayStr =
              '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
          if (updated.date == todayStr) {
            final fresh = await ref.read(todayReflectionProvider.future);
            if (fresh != null) {
              setState(() => _loadExistingReflection(fresh));
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todayAsync = ref.watch(todayReflectionProvider);
    final recentAsync = ref.watch(recentReflectionsProvider);

    // Pre-fill from today's reflection
    todayAsync.whenData((reflection) {
      if (reflection != null && _selectedMood == 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() => _loadExistingReflection(reflection));
          }
        });
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: spacingL),
          // ── Header ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: spacingXXL),
            child: Row(
              children: [
                ClipOval(
                  child: Container(
                    width: 44,
                    height: 44,
                    color: lavender.withValues(alpha: 0.2),
                    child: Transform.scale(
                      scale: 2.0,
                      child: Image.asset(
                        'assets/icon.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Daily Reflection', style: headingLarge),
                      const SizedBox(height: spacingXS),
                      Text(
                        'How are you feeling right now?',
                        style: bodyMedium.withColor(textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: spacingXXL),

          // ── Mood Selector ───────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: spacingXXL),
            child: MoodSelector(
              selected: _selectedMood,
              onChanged: (mood) => setState(() => _selectedMood = mood),
            ),
          ),

          const SizedBox(height: spacingXXL),

          // ── Journal prompt + text input ─────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: spacingXXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What is one highlight from today?',
                  style: bodyLarge.withColor(textSecondary),
                ),
                const SizedBox(height: spacingS),
                JournalPromptCard(
                  controller: _textController,
                ),
              ],
            ),
          ),

          const SizedBox(height: spacingXXL),

          // ── Save button ─────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: spacingXXL),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed:
                    _selectedMood == 0 || _isSaving ? null : _saveReflection,
                icon: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.auto_awesome, size: 20),
                label: Text(
                  todayAsync.hasValue && todayAsync.value != null
                      ? 'Update Reflection'
                      : 'Save Reflection',
                  style: bodyLarge.withColor(Colors.white).bold,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryLavender,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: primaryLavender.withValues(alpha: 0.4),
                  disabledForegroundColor: Colors.white70,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radiusLarge),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),

          const SizedBox(height: spacingXXXL),

          // ── Reflection History ──────────────────────
          recentAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (reflections) {
              // Exclude today's reflection from history
              final now = DateTime.now();
              final todayStr =
                  '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
              final history =
                  reflections.where((r) => r.date != todayStr).toList();
              if (history.isEmpty) return const SizedBox.shrink();
              return ReflectionHistorySection(
                reflections: history,
                onTap: _onHistoryReflectionTap,
                onViewAll: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReflectionCalendarPage(),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Edit reflection bottom sheet
// =============================================================================

class _EditReflectionSheet extends StatefulWidget {
  final Reflection reflection;
  final Future<void> Function(Reflection) onSave;

  const _EditReflectionSheet({
    required this.reflection,
    required this.onSave,
  });

  @override
  State<_EditReflectionSheet> createState() => _EditReflectionSheetState();
}

class _EditReflectionSheetState extends State<_EditReflectionSheet> {
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
    return Container(
      margin: const EdgeInsets.only(top: 80),
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
        child: Column(
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
                decoration: const InputDecoration(
                  hintText: 'Capture your thoughts here...',
                  hintStyle: TextStyle(color: textMuted),
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
                        await widget.onSave(updated);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryLavender,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radiusLarge),
                  ),
                  elevation: 0,
                ),
                child: Text('Save Changes',
                    style: bodyLarge.withColor(Colors.white).bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    final parts = dateStr.split('-');
    final date = DateTime(
        int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
