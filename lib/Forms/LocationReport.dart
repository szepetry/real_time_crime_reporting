import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:instant_reporter/model/infoObject.dart';
import 'package:instant_reporter/model/multiInfoObject.dart';
import 'package:geolocator/geolocator.dart';

List<dynamic> infoObjs = List<dynamic>();
int count = 0;
Geolocator geolocator = Geolocator();
MultiInfoObject _multiInfoObject;

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
      await _databaseReference.child(id).remove().then((value) async {
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
              this._address);
          infoObjs.clear();
          infoObjs.add(infoObject.toJson());
          _multiInfoObject = MultiInfoObject(infoObjs, count);

          await _databaseReference.child("$id").set(_multiInfoObject.toJson());
          print("The object sent: $infoObjs");

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
            });
      });


    } catch (e) {
      print("Caught exceptions: $e");
    }
  }
}
