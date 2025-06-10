import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

class GasLeakMonitor {
  final DatabaseReference gasLeakRef =
      FirebaseDatabase.instance.ref("flame/gas_leak");
  final DatabaseReference statusRef =
      FirebaseDatabase.instance.ref("flame/status");

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool gasLeakDetected = false;

  void init() {
    final initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    notificationsPlugin.initialize(initializationSettings);

    gasLeakRef.onValue.listen((event) {
      final detected = event.snapshot.value.toString().toLowerCase() == 'true';
      print("Gas leak detected: $detected");

      if (detected && gasLeakDetected == false) {
        gasLeakDetected = true;
        showNotification(
          "Secure Flame",
          "Gas leak detected! Turning off the stove.",
        );
        statusRef.set(false);
      } else if (!detected) {
        gasLeakDetected = false;
      }
    });
  }

  Future<void> showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'gas_channel',
      'Gas Leak Monitoring',
      importance: Importance.max,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);
    await notificationsPlugin.show(0, title, body, notificationDetails);
  }
}
