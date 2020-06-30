import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:instant_reporter/Forms/ReportForm.dart';
import 'package:path/path.dart';
import 'package:instant_reporter/model/infoObject.dart';
import 'package:instant_reporter/model/multiInfoObject.dart';
import '../MainPages/FireMap.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

List<dynamic> infoObjs = List<dynamic>();
Position _currentPosition;
//TODO: change count to 1
int count = 0;
// bool isLoading = true;
MultiInfoObject _multiInfoObject;

// class LocationReport extends StatefulWidget {
//   bool firstLoad;
//   final String id;
//   LocationReport(this.firstLoad, this.id);

//   @override
//   _LocationReportState createState() {
//     print("hello first load: " + firstLoad.toString());
//     return _LocationReportState(firstLoad, id);
//   }
// }

// class _LocationReportState extends State<LocationReport> {

// }

class LocationReport {
  // Timer _timer;
  // bool firstLoad;
  String id;
  // _LocationReportState(this.firstLoad, this.id);
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  String _fName = '';
  String _lName = '';
  String _phone = '';
  String _email = '';
  String _address = '';
  String _urlAttachmentPhoto = '';
  String _urlAttachmentVideo = '';
  LatLng _location;
  String _description = '';

  LocationReport(this.id);

  Future<void> _getCurrentLocation() async {
    _currentPosition = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  // PanelController _panelController = PanelController();
  // onPressed: () => _pc.open(),

  // @override
  // void initState() {
  //   super.initState();
  //   // infoObjs.clear();
  //   print("hello first load init state: " + firstLoad.toString());
  //   _getLocation();
  //   _databaseReference.child(id).onValue.listen((event) {
  //     count = event.snapshot.value['count'];
  //     print("Count value init: " + count.toString());
  //   });
  //   // if(count!=0){
  //   //   firstLoad=true;
  //   // }
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   // _timer.cancel();
  // }

  // Future<void> _getLocation() async {
  //   Position position = await Geolocator()
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   setState(() {
  //     _currentPosition = position;
  //     // _location = LatLng(_currentPosition.latitude, _currentPosition.longitude);
  //   });
  // }

  // void getReport(id, BuildContext context) {
  //   try {
  //     _databaseReference.child(id).once().then((DataSnapshot snapshot) {
  //       // count = 0;
  //       print("Firstload in getReport: " + this.firstLoad.toString());
  //       print("count value getReport: " + count.toString());
  //       if (count >= 0) {
  //         // count = event.snapshot.value['count'];
  //         for (int index = 0; index < snapshot.value['count']; index++) {
  //           // print(infoObjs);
  //           infoObjs.add(snapshot.value['infoObject'][index]);
  //         }
  //       }
  //     });
  //   } catch (e) {
  //     print("Get report exception: $e");
  //   }
  // }

  void saveReport(BuildContext context) async {
    await _databaseReference.child(id).remove();
    _getCurrentLocation();
    
    try {
      // bool loadStat = this.firstLoad;
      // print("save report state check: $loadStat");
      Future.delayed(Duration(seconds: 3)).then((value) async{
    _location = LatLng(_currentPosition.latitude,_currentPosition.longitude);
    print("Location from Location report: "+_currentPosition.toString());
      if (_location != null) {
        print("1st $count");

        // if (loadStat == false) {
        //   print("1st load count: $count");

        //   //TODO: make 0 -> 1 here
        //   // if (count >= 1) {
        //   getReport(id, context);
        //   setState(() {
        //     loadStat = true;
        //     // isLoading = false;
        //   });
        //   // }
        // }

        print(_location);

        // navigateToReport(context);

        InfoObject infoObject = InfoObject(
            this._fName,
            this._lName,
            this._phone,
            this._email,
            this._description,
            _currentPosition.toString(),
            this._urlAttachmentPhoto,
            this._urlAttachmentVideo,
            this._address);
        infoObjs.clear();
        infoObjs.add(infoObject.toJson());
        _multiInfoObject = MultiInfoObject(infoObjs, count);
        // //Sleep statement
        // print("sleeping for 2 now\n");
        // sleep(Duration(seconds: 2));=
        await _databaseReference.child("$id").set(_multiInfoObject.toJson());
        print("The object sent: $infoObjs");

        // await _databaseReference.child("$id").set(_multiInfoObject.toJson());
        // print("The object sent: $infoObjs");

        // infoObjs.clear();
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

    } catch (e) {
      print("Caught exceptions: $e");
    }
  }

    void saveInstantReport() async {
    await _databaseReference.child(id).remove();
    _getCurrentLocation();
    _location = LatLng(_currentPosition.latitude,_currentPosition.longitude);
    print("Location from Location report: "+_currentPosition.toString());
    try {
      if (_location != null) {
        print("1st $count");

        print(_location);

        // navigateToReport(context);

        InfoObject infoObject = InfoObject(
            this._fName,
            this._lName,
            this._phone,
            this._email,
            this._description,
            _currentPosition.toString(),
            this._urlAttachmentPhoto,
            this._urlAttachmentVideo,
            this._address);
        infoObjs.clear();
        infoObjs.add(infoObject.toJson());
        _multiInfoObject = MultiInfoObject(infoObjs, count);
        await _databaseReference.child("$id").set(_multiInfoObject.toJson());
        print("The object sent: $infoObjs");
      } else {
        print("save instant report function did not work.");
      }
    } catch (e) {
      print("Caught exceptions: $e");
    }
  }

  // navigateToBottomPanel(BuildContext context) {
  //   UserDetails u = Provider.of<UserDetails>(context, listen: false);

  // }
}
