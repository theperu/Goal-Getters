import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static const _kReminderEnabledKey = 'daily_reminder_enabled';
  static const _kReminderHourKey = 'daily_reminder_hour';
  static const _kReminderMinuteKey = 'daily_reminder_minute';
  static const _channelId = 'daily_reminder';
  static const _notificationId = 1001;

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(settings);
  }

  static Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }

    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }

    return true;
  }

  static Future<void> scheduleDailyReminder(TimeOfDay time) async {
    await cancelReminder();

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      'Daily Reminder',
      channelDescription: 'Daily reminder for reflections and habits',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      _notificationId,
      'Goal Getters',
      'Time to check in on your habits and reflections!',
      scheduledDate,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancelReminder() async {
    await _plugin.cancel(_notificationId);
  }

  /// Re-schedules the daily reminder if it was previously enabled.
  /// Call this on every app startup to survive reboots and force-stops.
  static Future<void> restoreScheduledReminder(SharedPreferences prefs) async {
    if (!isReminderEnabled(prefs)) return;
    final time = getReminderTime(prefs);
    await scheduleDailyReminder(time);
  }

  // SharedPreferences helpers
  static bool isReminderEnabled(SharedPreferences prefs) {
    return prefs.getBool(_kReminderEnabledKey) ?? false;
  }

  static TimeOfDay getReminderTime(SharedPreferences prefs) {
    final hour = prefs.getInt(_kReminderHourKey) ?? 20;
    final minute = prefs.getInt(_kReminderMinuteKey) ?? 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  static Future<void> saveReminderPrefs(
    SharedPreferences prefs, {
    required bool enabled,
    required TimeOfDay time,
  }) async {
    await prefs.setBool(_kReminderEnabledKey, enabled);
    await prefs.setInt(_kReminderHourKey, time.hour);
    await prefs.setInt(_kReminderMinuteKey, time.minute);
  }
}
