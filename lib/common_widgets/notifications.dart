import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Noti{
   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    showNotification({@required String sentence, @required String heading}) async {
      
   var android= AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios=IOSInitializationSettings();

    var init= new InitializationSettings(android, ios);
     flutterLocalNotificationsPlugin.initialize(init,onSelectNotification: (String payload)async{
      if (payload!=null) {
              debugPrint('notification payload: ' + payload);
       }
    });
    var and =  AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High,importance: Importance.Max
    );

    var iOS =  IOSNotificationDetails();
    var platform =  NotificationDetails(and, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, heading, sentence, platform);
  }
}

