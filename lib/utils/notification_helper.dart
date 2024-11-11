import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'alarm_service_channel', // 채널 ID
    'Alarm Service Channel', // 채널 이름
    channelDescription: 'This channel is used for important notifications.',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  await flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.data['title'] ?? 'Default Title',
    message.data['body'] ?? 'Default Body',
    notificationDetails,
  );
}
