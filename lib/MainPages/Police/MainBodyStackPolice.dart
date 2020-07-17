import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:instant_reporter/ZoneHandle/DisplayZones/ZoneRender.dart';
import 'package:instant_reporter/ZoneHandle/ZoneNotificationManager.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:transparent_image/transparent_image.dart';
import 'package:instant_reporter/MainPages/Police/FireMapPolice.dart';
import '../Buttons/ProfileMenu.dart';
import 'package:provider/provider.dart';
import 'package:instant_reporter/MainPages/Drawers.dart';
import '../../Forms/LocationReport.dart';

Marker marker;

// Position _currentPosition;

//TODO:Main body of the application
class MainBodyStackPolice extends StatefulWidget {
  final String uid;
  MainBodyStackPolice(this.uid);

  @override
  _MainBodyStackPoliceState createState() => _MainBodyStackPoliceState();
}

class _MainBodyStackPoliceState extends State<MainBodyStackPolice> {
  /* void initState() {
    super.initState();
    // _getCurrentLocation();

 
  } */

  // Future<void> _getCurrentLocation() async {
  //   // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  //   Position position = await Geolocator()
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  //   setState(() {
  //     _currentPosition = position;
  //   });
  // }

  bool displayZone = false;

  @override
  void initState() {
    super.initState();
    ZoneNotificationsManager.init(widget.uid);
    ZoneNotificationsManager.invokeZoneListener(context);
  }

  void choiceAction(String choice) {
    if (choice == ProfileMenu.signout) {
      print("Sign out");
    }
    // else if(){
    // Add more functions like so.
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FireMapPolice.create(context),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            iconSize: 45,
            tooltip: "Profile",
            icon: Icon(
              Icons.person_pin,
              color: Colors.white,
            ),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ),
        Positioned(
          bottom: 300,
          left: MediaQuery.of(context).size.width - 80,
          child: RawMaterialButton(
            onPressed: () {
              // _getCurrentLocation();
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
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                    child: Text(
                  "Police",
                  style: TextStyle(fontSize: 20, color: Colors.red),
                )),
                Container(
                    child: Text(
                  "level",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                  ),
                )),
              ],
            ),
          ),
        )

        // Align(
        //   alignment: Alignment.topLeft,
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Text(
        //       "Police",
        //       style: TextStyle(color: Colors.white,fontSize: 40),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

/* PopupMenuButton<String>(
            tooltip: "Profile",
            onSelected: choiceAction,
            icon: Icon(Icons.person),
            itemBuilder: (BuildContext context) {
              return ProfileMenu.choices.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            }
          ), */
