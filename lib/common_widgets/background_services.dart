import 'package:flutter/cupertino.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:io';
import '../Forms/LocationReport.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:instant_reporter/model/infoObject.dart';
import 'package:instant_reporter/model/multiInfoObject.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// const simpleTaskKey = 'simpleTask';
// const simpleDelayedTask = 'simpleDelayedTask';
// const simplePeriodicTask = 'simplePeriodicTask';
// const simplePeriodic1HourTask = 'simplePeriodic1HourTask';

const platform = const EventChannel("com.renegades.miniproject/voldown");

PanelController panelController = PanelController();

void instantReportExecuter() {
  print('Instant Report Executer');
  Workmanager.executeTask((backgroundTask, data) async {
    Geolocator geolocator = Geolocator();
    String uid = data["uid"];
    List<dynamic> infoObjs = List<dynamic>();
    MultiInfoObject _multiInfoObject;
    DatabaseReference _databaseReference =
        FirebaseDatabase.instance.reference();

    String _fName = '';
    String _lName = '';
    String _phone = '';
    String _email = '';
    String _address = '';
    String _urlAttachmentPhoto = '';
    String _urlAttachmentVideo = '';
    String _description = '';

    try {
      await _databaseReference.child(uid).remove().then((value) async {
        await geolocator
            .getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high,
                locationPermissionLevel: GeolocationPermission.locationAlways)
            .then((value) async {
          if (value != null && value.latitude != null) {
            InfoObject infoObject = InfoObject(
                _fName,
                _lName,
                _phone,
                _email,
                _description,
                value.toString(),
                _urlAttachmentPhoto,
                _urlAttachmentVideo,
                _address,
                DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch).toString());
            infoObjs.clear();
            infoObjs.add(infoObject.toJson());
            _multiInfoObject = MultiInfoObject(infoObjs, count);
            await _databaseReference
                .child("$uid")
                .set(_multiInfoObject.toJson());
            print("The object sent: $infoObjs");
          }
        });
      });
    } catch (e) {
      debugPrint(
          "This is the exception inside background service: ${e.toString()}");
    }
    return true;
  });
}

void startServiceInPlatform() async {
  if (Platform.isAndroid) {
    var methodChannel = MethodChannel("com.renegades.miniproject/report");
    String data = await methodChannel.invokeMethod("startReportService");
    debugPrint(data);
  }
}
