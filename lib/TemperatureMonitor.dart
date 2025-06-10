import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TemperatureMonitor {
  final databaseReference = FirebaseDatabase.instance.ref("flame/temperature");
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void init() {
    // تهيئة الإشعارات المحلية
    final initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // مراقبة درجة الحرارة
    databaseReference.onValue.listen((event) {
      final temp = event.snapshot.value;
      print("درجة الحرارة: $temp");
      if (temp != null && temp is num && temp >= 100) {
        showNotification("Warning", "Be careful, it's boiling over!");
      }
    });
  }

  void showNotification(String? title, String? body) async {
    // تأكد من أن القيم ليست null
    final validTitle = title ?? "Warning";
    final validBody = body ?? 'High temperature.';

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_temp_channel', // channelId
      'High Temperature', // channelName
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
        0, validTitle, validBody, platformDetails);
  }
}
