import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:instant_reporter/model/infoObject.dart';
import 'package:instant_reporter/model/multiInfoObject.dart';
import '../model/multiReportObject.dart';
import 'package:geolocator/geolocator.dart';

List<dynamic> infoObjs = List<dynamic>();
List<dynamic> multiObjs = List<dynamic>();

int count1 = 0, count2 = 0;
Geolocator geolocator = Geolocator();
MultiInfoObject _multiInfoObject;
MultiReportObject _multiReportObject;

class LocationReport {
  String id;
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  String _fName = '';
  String _lName = '';
  String _phone = '';
  String _email = '';
  String _address = '';
  String _urlAttachmentPhoto = '';
  String _urlAttachmentVideo = '';
  String _description = '';

  LocationReport(this.id);

  void saveReport(BuildContext context) async {
    try {
      await geolocator
          .getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
              locationPermissionLevel: GeolocationPermission.locationAlways)
          .then((value) async {
        print("Location from Location report: " + value.toString());
        if (value != null) {
          InfoObject infoObject = InfoObject(
              this._fName,
              this._lName,
              this._phone,
              this._email,
              this._description,
              value.toString(),
              this._urlAttachmentPhoto,
              this._urlAttachmentVideo,
              this._address,
              DateTime.fromMillisecondsSinceEpoch(
                      DateTime.now().millisecondsSinceEpoch)
                  .toString());
          infoObjs.clear();
          infoObjs.add(infoObject.toJson());
          _multiInfoObject = MultiInfoObject(infoObjs, count1);
          multiObjs.clear();
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Location not retrieved"),
                  content: Text(
                      "Location received is null, please check the location settings."),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Close")),
                  ],
                );
              });
        }
      }).then((value) async {
        await _databaseReference.child("$id").once().then((value) async {
          if (value.value == null) {
            _multiReportObject = MultiReportObject(multiObjs, 1);
            await _databaseReference
                .child("$id")
                .set(_multiReportObject.toJson());
            print("The object sent: $multiObjs");
          } else {
            count2 = value.value['count'];
            multiObjs.addAll(value.value['multiObject']);
          }
        }).then((value) async {
          multiObjs.add(_multiInfoObject.toJson());
          if (count2 != null || count2 != 0) {
            _multiReportObject = MultiReportObject(multiObjs, count2);
            await _databaseReference
                .child("$id")
                .set(_multiReportObject.toJson());
            print("The object sent: $multiObjs");
          } else {
            _multiReportObject = MultiReportObject(multiObjs, 0);
            await _databaseReference
                .child("$id")
                .set(_multiReportObject.toJson());
            print("The object sent: $multiObjs");
          }
        });
      });
    } catch (e) {
      print("Caught exceptions: $e");
    }
  }
}
