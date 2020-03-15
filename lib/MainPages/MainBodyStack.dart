import 'package:flutter/material.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
// import 'package:transparent_image/transparent_image.dart';
import 'package:instant_reporter/MainPages/FireMap.dart';

Marker marker;

Position _currentPosition;

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

class FloatingActionButtonWidget extends StatelessWidget {
  const FloatingActionButtonWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.red,
      onPressed: () {},
      child: Icon(Icons.offline_bolt),
    );
  }
}