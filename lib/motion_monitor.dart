import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

class MotionMonitor {
  final DatabaseReference motionSensorRef =
      FirebaseDatabase.instance.ref("flame/motion_sensor");
  final DatabaseReference motionDetectedRef =
      FirebaseDatabase.instance.ref("flame/motion_detected");
  final DatabaseReference statusRef =
      FirebaseDatabase.instance.ref("flame/status");

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  int? lastMotionTime;

  void init() {
    final initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    notificationsPlugin.initialize(initializationSettings);
    motionSensorRef.onValue.listen((event) {
      final enabled = event.snapshot.value.toString().toLowerCase() == 'true';
      print("Motion sensor enabled: $enabled");
      if (enabled) {
        startMonitoring();
      }
    });

    motionDetectedRef.onValue.listen((event) {
      final value = event.snapshot.value;
      if (value is int) {
        lastMotionTime = value;
        final readableTime =
            DateTime.fromMillisecondsSinceEpoch(lastMotionTime!);
        print("Motion detected at: $readableTime");
      } else if (value == false) {
        print('No motion detected(value false)');
      } else {
        lastMotionTime = DateTime.now().millisecondsSinceEpoch;
        final readableTime =
            DateTime.fromMillisecondsSinceEpoch(lastMotionTime!);
        print("Motion detected at current time: $readableTime");
      }
    });
  }

  void startMonitoring() {
    lastMotionTime = DateTime.now().millisecondsSinceEpoch;
    final readableStart = DateTime.fromMillisecondsSinceEpoch(lastMotionTime!);
    print("Started motion monitoring at: $readableStart");

    Timer.periodic(Duration(seconds: 10), (timer) async {
      final enabledSnapshot = await motionSensorRef.get();
      if (enabledSnapshot.value.toString().toLowerCase() != 'true') {
        print("Motion sensor disabled, stopping monitor");
        timer.cancel();
        return;
      }

      final now = DateTime.now().millisecondsSinceEpoch;
      final diff = now - (lastMotionTime ?? now);
      print("No motion for: ${(diff / 60000).toStringAsFixed(1)} minutes");

      if (diff >= 20 * 1000 && diff < 25 * 1000) {
        await showNotification(
          "Secure Flame",
          "No movement detected for 20 minutes.",
        );
        print("Notification sent: No motion for 20 minutes");
      } else if (diff >= 25 * 1000) {
        await showNotification(
          "Secure Flame",
          "Still no movement. Turning off the stove.",
        );
        print("Auto shutdown triggered");
        await statusRef.set(false);
        timer.cancel();
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
