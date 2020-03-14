import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sih_app/model/infoObject.dart';
import 'package:sih_app/model/multiInfoObject.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../Database/databaseNormal.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
// import 'package:transparent_image/transparent_image.dart';
import 'package:sih_app/MainPages/FireMap.dart';
import '../model/userObject.dart';

Marker marker;
String id = "1234";
Position _currentPosition;
InfoObject infoObject;
MultiInfoObject multiInfoObject;
UserObject userObj;

//TODO:Main body of the application
class MainBodyStack extends StatefulWidget {
  @override
  _MainBodyStackState createState() => _MainBodyStackState();
}

class _MainBodyStackState extends State<MainBodyStack> {
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FireMap(),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            tooltip: "Profile",
            icon: Icon(Icons.person),
            onPressed: () {},
          ),
        ),
        Positioned(
          bottom: 150,
          left: MediaQuery.of(context).size.width - 80,
          child: RawMaterialButton(
            onPressed: () {
              _getCurrentLocation();
              moveCamera();
            },
            child: Icon(
              Icons.gps_fixed,
            ),
            shape: CircleBorder(),
            elevation: 4.0,
            fillColor: Colors.red,
            padding: EdgeInsets.all(15.0),
          ),
        ),
        _currentPosition != null
            ? Text(
                "LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}")
            : CircularProgressIndicator(),
      ],
    );
  }
}

class FloatingActionButtonWidget extends StatefulWidget {
  @override
  _FloatingActionButtonWidgetState createState() =>
      _FloatingActionButtonWidgetState();
}

class _FloatingActionButtonWidgetState
    extends State<FloatingActionButtonWidget> {
  @override
  void initState() {
    super.initState();
    // _getCurrentLocation().then((value) {
      // infoObject = InfoObject(location: _currentPosition.toString());
      // List<dynamic> map1 = List<dynamic>();
      // map1.add(infoObject);
      // multiInfoObject = MultiInfoObject(infoMap: map1);
      // List<dynamic> map2 = List<dynamic>();
      // map2.add(multiInfoObject);
      // userObj = UserObject(multiMap: map2);
    // });
        _getCurrentLocation();
    // sleep(Duration(seconds: 1));
  }

  Future<void> _getCurrentLocation() async {
    // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = position;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    DocumentReference ref = Firestore.instance.collection("normalUsers/$id").reference().document();
    // if(_currentPosition)
      infoObject = InfoObject(location: _currentPosition.toString());
      List<dynamic> map1 = List<dynamic>();
      map1.add(infoObject);
      multiInfoObject = MultiInfoObject(infoMap: map1);
      
      // List<dynamic> map2 = List<dynamic>();
      // map2.add(multiInfoObject);
      // userObj = UserObject(multiMap: map2);
      userObj.multiMapFunc.add(multiInfoObject);
    print(_currentPosition);
    print(infoObject.location.toString());
    print(userObj.multiMap.toString());
  // ref.setData(data)
    return FloatingActionButton(
      backgroundColor: Colors.red,
      onPressed: () async {
        if (_currentPosition != null) {
          Firestore.instance
              .collection('normalUsers/$id')
              .reference()
              .document()
              .setData({"multiInfoObject": userObj.multiMap})
              .then((result) => {
                
              })
              .catchError((err) => print("offline bolt error: $err"));
        }
        // await DatabaseService(uid: "1234").updateUserData();
      },
      child: Icon(Icons.offline_bolt),
    );
  }
}
