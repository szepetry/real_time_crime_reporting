import 'package:flutter/cupertino.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:async';
import 'dart:io';
import '../Forms/LocationReport.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:instant_reporter/model/infoObject.dart';
import 'package:instant_reporter/model/multiInfoObject.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const simpleTaskKey = 'simpleTask';
const simpleDelayedTask = 'simpleDelayedTask';
const simplePeriodicTask = 'simplePeriodicTask';
const simplePeriodic1HourTask = 'simplePeriodic1HourTask';
const platform = const EventChannel("com.renegades.miniproject/voldown");

void instantReportExecuter() {
  print('Instant Report Executer');
  Workmanager.executeTask((backgroundTask, data) async {
    Geolocator geolocator = Geolocator();
    String uid = data["uid"];
    List<dynamic> infoObjs = List<dynamic>();
    Position _currentPosition;
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
    LatLng _location;
    String _description = '';

    try {
      await _databaseReference.child(uid).remove();
      _currentPosition = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          locationPermissionLevel: GeolocationPermission.locationAlways);
      if (_currentPosition != null && _currentPosition.latitude != null) {
        _location =
            LatLng(_currentPosition.latitude, _currentPosition.longitude);
        // print("Location from Location report: "+_currentPosition.toString());
        InfoObject infoObject = InfoObject(
            _fName,
            _lName,
            _phone,
            _email,
            _description,
            _currentPosition.toString(),
            _urlAttachmentPhoto,
            _urlAttachmentVideo,
            _address);
        infoObjs.clear();
        infoObjs.add(infoObject.toJson());
        _multiInfoObject = MultiInfoObject(infoObjs, count);
        // //Sleep statement
        // print("sleeping for 2 now\n");
        // sleep(Duration(seconds: 2));=
        await _databaseReference.child("$uid").set(_multiInfoObject.toJson());
        print("The object sent: $infoObjs");
      }
    } catch (e) {
      print("This is the exception inside background service: ${e.toString()}");
    }

    // print("uid background: $uid");
    // LocationReport(uid).saveInstantReport();
    // print("Location reporter from background task");

// StreamBuilder(
//   stream: platform.receiveBroadcastStream(),
//   builder: (context, snapshot) {
//     if (snapshot.hasData) {

//       return Text("${snapshot.data}");
//     }
//     return Text("No data");
//   },
// );

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

// Stream _stream = platform.receiveBroadcastStream();
// var subscription = _stream.listen(actionTaken);

// void actionTaken(dynamic data){
//   print("Data: $data");
// }

class BackgroundServices {}
