import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/style.dart';
import '../../providers/shared_preferences_provider.dart';
import '../../services/backup_service.dart';
import '../../services/notification_service.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  late bool _reminderEnabled;
  late TimeOfDay _reminderTime;
  bool _isExporting = false;
  bool _isImporting = false;

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(sharedPrefProvider);
    _reminderEnabled = NotificationService.isReminderEnabled(prefs);
    _reminderTime = NotificationService.getReminderTime(prefs);
  }

  Future<void> _toggleReminder(bool enabled) async {
    if (enabled) {
      final granted = await NotificationService.requestPermission();
      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Notification permission is required')),
          );
        }
        return;
      }
      try {
        await NotificationService.scheduleDailyReminder(_reminderTime);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to schedule reminder: $e')),
          );
        }
        return;
      }
    } else {
      await NotificationService.cancelReminder();
    }

    final prefs = ref.read(sharedPrefProvider);
    await NotificationService.saveReminderPrefs(
      prefs,
      enabled: enabled,
      time: _reminderTime,
    );
    setState(() => _reminderEnabled = enabled);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked == null) return;

    setState(() => _reminderTime = picked);

    final prefs = ref.read(sharedPrefProvider);
    await NotificationService.saveReminderPrefs(
      prefs,
      enabled: _reminderEnabled,
      time: picked,
    );

    if (_reminderEnabled) {
      await NotificationService.scheduleDailyReminder(picked);
    }
  }

  Future<void> _exportData() async {
    setState(() => _isExporting = true);
    try {
      final success = await BackupService.exportDatabase();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Database exported successfully'
                : 'Export failed'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _importData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Import data?'),
        content: const Text(
          'This will replace all existing data with the imported backup. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Import')),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isImporting = true);
    try {
      final success = await BackupService.importDatabase();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Data imported successfully. Please restart the app.'
                : 'Import failed — invalid file or no file selected.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Import error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Settings', style: headingLarge),
        backgroundColor: background,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          // --- Notifications Section ---
          Text('Notifications',
              style: headingSmall.copyWith(color: textSecondary)),
          const SizedBox(height: spacingS),
          Container(
            decoration: cardDecoration,
            padding: const EdgeInsets.all(spacingL),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: lavender.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(radiusSmall),
                      ),
                      child: const Icon(Icons.notifications_outlined,
                          color: primaryLavender, size: 22),
                    ),
                    const SizedBox(width: spacingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Daily Reminder', style: bodyLarge),
                          Text(
                            'Remind me to check habits & reflect',
                            style: caption.copyWith(color: textMuted),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: _reminderEnabled,
                      onChanged: _toggleReminder,
                      activeColor: primaryLavender,
                    ),
                  ],
                ),
                if (_reminderEnabled) ...[
                  const Divider(height: 24),
                  InkWell(
                    onTap: _pickTime,
                    borderRadius: BorderRadius.circular(radiusSmall),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time,
                              color: textSecondary, size: 20),
                          const SizedBox(width: spacingM),
                          const Expanded(
                            child: Text('Reminder Time', style: bodyLarge),
                          ),
                          Text(
                            _formatTime(_reminderTime),
                            style: bodyLarge.copyWith(color: primaryLavender),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.chevron_right,
                              color: textMuted, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: spacingXXL),

          // --- Data Section ---
          Text('Data', style: headingSmall.copyWith(color: textSecondary)),
          const SizedBox(height: spacingS),
          Container(
            decoration: cardDecoration,
            padding: const EdgeInsets.all(spacingL),
            child: Column(
              children: [
                _DataAction(
                  icon: Icons.upload_outlined,
                  iconColor: mint,
                  label: 'Export Data',
                  subtitle: 'Share a backup of your database',
                  isLoading: _isExporting,
                  onTap: _exportData,
                ),
                const Divider(height: 24),
                _DataAction(
                  icon: Icons.download_outlined,
                  iconColor: peach,
                  label: 'Import Data',
                  subtitle: 'Restore from a backup file',
                  isLoading: _isImporting,
                  onTap: _importData,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DataAction extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String subtitle;
  final bool isLoading;
  final VoidCallback onTap;

  const _DataAction({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(radiusSmall),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(radiusSmall),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: bodyLarge),
                Text(subtitle, style: caption.copyWith(color: textMuted)),
              ],
            ),
          ),
          if (isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            const Icon(Icons.chevron_right, color: textMuted, size: 20),
        ],
      ),
    );
  }
}
