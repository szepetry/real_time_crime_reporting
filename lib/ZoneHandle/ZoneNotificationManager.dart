import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ZoneNotificationsManager {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static bool _initialized = false;

  static void invokeZoneListener(BuildContext context) {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print(message);
        Scaffold.of(context).showSnackBar(createSnackbar(message, context));
      },
      onResume: (Map<String, dynamic> message) async {},
      onLaunch: (Map<String, dynamic> message) async {},
    );
  }

  static createSnackbar(Map<String, dynamic> message, BuildContext context) {
    String title = message['notification']['title'];
    String body = message['notification']['body'];
    return SnackBar(
        duration: const Duration(seconds: 8),
        content: ListTile(
          onTap: () => Scaffold.of(context).hideCurrentSnackBar(),
          leading: Icon(
            Icons.info_outline,
            size: 50,
          ),
          title: body == 'Tap to check it out'
              ? Text('$title')
              : Text('$title\n$body'),
          subtitle: Text('Press the refresh button to view zones'),
        ));
  }

  static Future<void> init(String uid) async {
    if (!_initialized) {
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure();
      String token = await _firebaseMessaging
          .getToken()
          .then<String>((value) => value)
          .catchError((e) => print(e));
      await Firestore.instance
          .collection('tokens')
          .document('devtoken')
          .updateData({
        'tokenList': FieldValue.arrayUnion([token])
      }).catchError((e) => print(e));
      print(uid);
      await Firestore.instance
          .collection('registeredUsers')
          .document(uid)
          .updateData({'token': token}).catchError((e) => print(e));
      _initialized = true;
    }
  }
}
