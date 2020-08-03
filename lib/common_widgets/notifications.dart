import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


Priority priority = Priority.High;
Importance importance = Importance.High;

class NotificationManager {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  showNotification(
      {@required String sentence, @required String heading, @required Priority priority, @required Importance importance}) async {
    var androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSSettings = IOSInitializationSettings();

    var init = new InitializationSettings(androidSettings, iOSSettings);
    flutterLocalNotificationsPlugin.initialize(init,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
    });
    var androidDetails = AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: priority, importance: importance);

    var iOSDetails = IOSNotificationDetails();
    var platform = NotificationDetails(androidDetails, iOSDetails);
    await flutterLocalNotificationsPlugin.show(0, heading, sentence, platform);
  }
}
