import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MotionMonitor {
  final DatabaseReference motionSensorRef =
      FirebaseDatabase.instance.ref("flame/motion_sensor");
  final DatabaseReference motionDetectedRef =
      FirebaseDatabase.instance.ref("flame/motion_detected");
  final DatabaseReference statusRef =
      FirebaseDatabase.instance.ref("flame/status");

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void init() {
    final initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    notificationsPlugin.initialize(initializationSettings);

    motionSensorRef.onValue.listen((event) {
      final enabled = event.snapshot.value.toString().toLowerCase() == 'true';
      print("Motion sensor enabled: $enabled");
    });

    motionDetectedRef.onValue.listen((event) async {
      final value = event.snapshot.value;

      print("motion_detected changed: $value");

      if (value == 1) {
        await showNotification(
          "Secure Flame",
          "No movement detected for 20 mins.",
        );
        print("Notification sent: No motion for 20 mins");
      } else if (value == 2) {
        await showNotification(
          "Secure Flame",
          "Still no movement. Turning off the stove.",
        );
        print("Auto shutdown triggered");

        await statusRef.set(false);

        await motionDetectedRef.set(0);
      }
    });
  }

  Future<void> showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'motion_channel',
      'Motion Monitoring',
      importance: Importance.max,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);
    await notificationsPlugin.show(0, title, body, notificationDetails);
  }
}
