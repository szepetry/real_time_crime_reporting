import 'package:flutter/cupertino.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:instant_reporter/model/infoObject.dart';
import 'package:instant_reporter/model/multiInfoObject.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/material.dart';
import '../model/multiReportObject.dart';
import '../AuthenticationHandle/StateNotifiers/FirestoreService.dart';
import 'package:intl/intl.dart';

const platform = const EventChannel("com.renegades.miniproject/voldown");

PanelController panelController = PanelController();

void instantReportExecuter() {
  print('Instant Report Executer');
  Workmanager.executeTask((backgroundTask, data) async {
    List<dynamic> multiObjs = List<dynamic>();

    int count1 = 0, count2 = 0;

    Geolocator geolocator = Geolocator();
    String uid = data["uid"];
    List<dynamic> infoObjs = List<dynamic>();
    MultiInfoObject _multiInfoObject;
    MultiReportObject _multiReportObject;

    DatabaseReference _databaseReference =
        FirebaseDatabase.instance.reference();

    String _urlAttachmentPhoto = '';
    String _urlAttachmentVideo = '';
    String _description = '';
    String aadhar;
    String name;
    String phone;
    DateTime now = DateTime.now();

    try {
      await geolocator
          .getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
              locationPermissionLevel: GeolocationPermission.locationAlways)
          .then((value) async {
        print("Location from Location report: " + value.toString());
        if (value != null) {
          InfoObject infoObject = InfoObject(
              _description,
              value.toString(),
              _urlAttachmentPhoto,
              _urlAttachmentVideo,
              DateFormat('yyyy-MM-dd kk:mm:ss').format(now).toString());
          infoObjs.clear();
          infoObjs.add(infoObject.toJson());
          _multiInfoObject = MultiInfoObject(infoObjs, count1);
          multiObjs.clear();
        }
      }).then((value) async {
        await FirestoreService.registeredUserDocument(uid).get().then((value) {
          aadhar = value.data['aadhar'];
          name = value.data['name'];
          phone = value.data['phoneNo'];
        }).then((value) async {
          await _databaseReference.child("$uid").once().then((value) async {
            if (value.value == null) {
              _multiReportObject =
                  MultiReportObject(multiObjs, 1, aadhar, name, phone);
              await _databaseReference
                  .child("$uid")
                  .set(_multiReportObject.toJson());
              print("The object sent: $multiObjs");
            } else {
              count2 = value.value['count'];
              multiObjs.addAll(value.value['multiObject']);
            }
          }).then((value) async {
            multiObjs.add(_multiInfoObject.toJson());
            if (count2 != null || count2 != 0) {
              _multiReportObject =
                  MultiReportObject(multiObjs, count2, aadhar, name, phone);
              await _databaseReference
                  .child("$uid")
                  .set(_multiReportObject.toJson());
              print("The object sent: $multiObjs");
            } else {
              _multiReportObject =
                  MultiReportObject(multiObjs, 0, aadhar, name, phone);
              await _databaseReference
                  .child("$uid")
                  .set(_multiReportObject.toJson());
              print("The object sent: $multiObjs");
            }
          });
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
