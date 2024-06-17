import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        GoRouter.of(context).pushNamed(AppRoute.chat.name, pathParameters: {
          'flowString': response.payload!
        });
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

  Future<void> scheduleCheckIn() async {
    // Schedule for one day
    await _notificationPlugin.zonedSchedule(
      0, // Unique id for each notification
      'Reminder',
      'It’s time for your check-in! 1 MINUTE CHECK IN',
     _nextInstanceOfSunday(),
      const NotificationDetails(
        android:
            AndroidNotificationDetails('checkin_reminder', 'Check-In Reminder'),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents:
          DateTimeComponents.time, // Only match the time component
      payload: 'check_in', // payload for check-in flow
    );
  }

  Future<void> checkAndScheduleNotification() async {
  final prefs = await SharedPreferences.getInstance();
  final isNotificationScheduled = prefs.getBool('isNotificationScheduled') ?? false;

  if (!isNotificationScheduled) {
    await scheduleCheckIn();
    await prefs.setBool('isNotificationScheduled', true);
  }
}


  tz.TZDateTime _nextInstanceInMinutes(int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    return now.add(Duration(seconds: minutes * 10));
  }

  tz.TZDateTime _nextInstanceOfSunday() {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  int daysToAdd = (DateTime.sunday - now.weekday) % DateTime.daysPerWeek;
  final tz.TZDateTime nextSunday = now.add(Duration(days: daysToAdd));
  return tz.TZDateTime(tz.local, nextSunday.year, nextSunday.month, nextSunday.day, 9, 0);
}
}

@Riverpod(keepAlive: true)
NotificationService notificationService(NotificationServiceRef ref) {
  return NotificationService();
}
