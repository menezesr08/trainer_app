import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:trainer_app/routing/app_router.dart';

part 'providers.g.dart';

class NotificationService {
  static final _notificationPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveBackgroundNotificationResponse(
      NotificationResponse details) async {
    if (details.payload != null) {}
  }

  Future<void> initialize(BuildContext context) async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        GoRouter.of(context).pushNamed(AppRoute.chat.name);
      }
    },
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveBackgroundNotificationResponse);
  }

  static Future<void> showNotification(String payload) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _notificationPlugin.show(
      0,
      'New Notification',
      'You have a new message',
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> scheduleNotificationsEvery5Minutes() async {
    for (int i = 0; i < 5; i++) {
      // Schedule for one day
      await _notificationPlugin.zonedSchedule(
        i, // Unique id for each notification
        'Reminder',
        'It’s time for your check-in! 1 MINUTE CHECK IN',
        _nextInstanceInMinutes(i * 1),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'checkin_reminder', 'Check-In Reminder'),
        ),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents:
            DateTimeComponents.time, // Only match the time component
        payload: 'check_in', // payload for check-in flow
      );
    }
  }

  tz.TZDateTime _nextInstanceInMinutes(int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    return now.add(Duration(seconds: minutes * 10));
  }
}

@Riverpod(keepAlive: true)
NotificationService notificationService(NotificationServiceRef ref) {
  return NotificationService();
}
