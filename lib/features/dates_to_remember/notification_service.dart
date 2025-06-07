// // lib/features/dates_to_remember/services/notification_service.dart
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:merge_app/features/dates_to_remember/event_model.dart';
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();

//   final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> init() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');
//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     await _notificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> scheduleNotification(EventModel event) async {
//     if (event.notifyBeforeMinutes == 0) return;

//     final scheduledTime = tz.TZDateTime.from(
//       event.eventDateTime.subtract(Duration(minutes: event.notifyBeforeMinutes)),
//       tz.local,
//     );

//     await _notificationsPlugin.zonedSchedule(
//       event.id.hashCode,
//       event.title,
//       'Event in ${event.notifyBeforeMinutes} minutes',
//       scheduledTime,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'event_channel',
//           'Event Notifications',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     );
//   }

//   Future<void> cancelNotification(String eventId) async {
//     await _notificationsPlugin.cancel(eventId.hashCode);
//   }
// }

// lib/features/dates_to_remember/services/notification_service.dart

import 'package:merge_app/features/dates_to_remember/event_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> init() async {
    // Placeholder: No-op
  }

  Future<void> scheduleNotification(EventModel event) async {
    // Placeholder: No notification scheduled
  }

  Future<void> cancelNotification(String eventId) async {
    // Placeholder: No notification canceled
  }
}