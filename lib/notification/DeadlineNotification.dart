import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');

  const settings = InitializationSettings(android: android);

  await flutterLocalNotificationsPlugin.initialize(settings: settings);
}

void deadline(String date) async {
  if ((DateTime.parse(date).day - DateTime.now().day) == 7) {
    await flutterLocalNotificationsPlugin.show(
      title: '締切日通知',
      body: "締切一週間前です！",
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          '締切日通知',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      id: 0,
    );
  } else if ((DateTime.parse(date).day - DateTime.now().day) < 7) {
    await flutterLocalNotificationsPlugin.show(
      id: 1,
      title: "締切日通知",
      body: "締切日まで→${(DateTime.parse(date).day - DateTime.now().day)}日です",
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id2',
          '締切日通知',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}
