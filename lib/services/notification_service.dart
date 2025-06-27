import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

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

    final bool? granted = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestExactAlarmsPermission();

    if (granted != true) {
      print("Exact alarm permission not granted.");
    }

    await _notificationsPlugin.initialize(settings);
  }

  Future<void> scheduleDaily8pmReminder() async {
    await _notificationsPlugin.zonedSchedule(
      0,
      'Your Daily Habit Reminder',
      'Don\'t forget to complete your habits today! 👋',
      _nextInstanceOf8PM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder_channel',
          'Daily Reminders',
          channelDescription: 'A channel for daily habit reminders.',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(sound: 'default'),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Future<void> showReminderNotification() async {
  //   await _notificationsPlugin.zonedSchedule(
  //     0,
  //     'Your Daily Habit Reminder',
  //     'Don\'t forget to complete your habits today! 👋',
  //     _nextInstanceOf8PM(),
  //     const NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'daily_reminder_channel',
  //         'Daily Reminders',
  //         channelDescription: 'A channel for daily habit reminders.',
  //         importance: Importance.max,
  //         priority: Priority.high,
  //       ),
  //       iOS: DarwinNotificationDetails(sound: 'default'),
  //     ),
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     matchDateTimeComponents: DateTimeComponents.time,
  //   );
  // }

  Future<void> showReminderNotification() async {
    await _notificationsPlugin.show(1, 'Your Daily Reminder', 'It\'s been 30 minutes, don\'t forget to complete your habit',NotificationDetails(
  android: AndroidNotificationDetails(
    'daily_reminder_channel',
    'Daily Reminders',
    channelDescription: 'A channel for daily habit reminders.',
    importance: Importance.max,
    priority: Priority.high,
  ),
 iOS: DarwinNotificationDetails(sound: 'default'),
)
);
  }

  tz.TZDateTime _nextInstanceOf8PM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      20,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
