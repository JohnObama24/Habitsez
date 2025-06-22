import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // 1. Initialize timezone database
    tz.initializeTimeZones();

    // 2. Define settings for each platform
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // 3. Initialize the plugin
    await _notificationsPlugin.initialize(settings);
  }

  Future<void> scheduleDaily8pmReminder() async {
    await _notificationsPlugin.zonedSchedule(
      0, // Notification ID
      'Your Daily Habit Reminder', // Title
      'Don\'t forget to complete your habits today! 👋', // Body
      _nextInstanceOf8PM(), // When to show (calculated below)
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder_channel', // Channel ID
          'Daily Reminders', // Channel Name
          channelDescription: 'A channel for daily habit reminders.',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(sound: 'default'),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents:
          DateTimeComponents.time, // Repeat daily at this time
    );
  }

  tz.TZDateTime _nextInstanceOf8PM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    // Schedule for 8 PM today
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      20,
    );
    // If 8 PM has already passed today, schedule for 8 PM tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
