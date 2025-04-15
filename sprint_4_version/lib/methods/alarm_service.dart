import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  // Initialize time zones
  tz.initializeTimeZones();

  // Request permissions on Android 13+
  final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  final bool? granted =
      await androidImplementation?.requestNotificationsPermission();
  if (granted != true) {
    debugPrint('❌ Notification permission not granted!');
    return;
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      final String? payload = response.payload;
      if (response.notificationResponseType ==
              NotificationResponseType.selectedNotification &&
          payload != null) {
        debugPrint('🔔 Notification tapped with payload: $payload');
        // Handle your navigation or logic here
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  // Create a notification channel (recommended)
  await androidImplementation?.createNotificationChannel(
    const AndroidNotificationChannel(
      'alarm_channel', // Must match the one used in AndroidNotificationDetails
      'Alarm Notifications',
      description: 'This channel is used for alarm notifications',
      importance: Importance.max,
    ),
  );
}

// Required for background taps
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  debugPrint('🔙 Background notification tapped: ${response.payload}');
}

Future<void> scheduleAlarm(DateTime dateTime,
    {String? title, String? body}) async {
  // Convert DateTime to TZDateTime
  final tz.TZDateTime scheduledDate = tz.TZDateTime.from(dateTime, tz.local);

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    title ?? 'Hello!',
    body ?? 'This is a scheduled notification.',
    scheduledDate,
    platformChannelSpecifics,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    payload: 'alarm_payload',
    matchDateTimeComponents: DateTimeComponents.dateAndTime, // optional
    // uiLocalNotificationDateInterpretation:
    //     UILocalNotificationDateInterpretation.absoluteTime,
  );
}
