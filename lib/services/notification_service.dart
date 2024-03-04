import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _notification = FlutterLocalNotificationsPlugin();
  static Future _notificationDetail() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails("channelId", "channelName",
            importance: Importance.max,
            playSound: true,
            priority: Priority.max));
  }

  static Future showPeriodicNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required RepeatInterval? repeatInterval}) async {
    return await _notification.periodicallyShow(
        id, title, body, repeatInterval!, await _notificationDetail(),
        payload: payload);
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime dateTime,
  }) async {
    return await _notification.zonedSchedule(id, title, body,
        tz.TZDateTime.from(dateTime, tz.local), await _notificationDetail(),
        payload: payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  static Future init({bool inti = false}) async {
    AndroidInitializationSettings android =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    final setting = InitializationSettings(android: android);

    await _notification.initialize(setting);
  }
}
