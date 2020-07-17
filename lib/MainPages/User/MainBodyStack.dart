import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:instant_reporter/ZoneHandle/ZoneNotificationManager.dart';
import 'package:instant_reporter/MainPages/User/FireMap.dart';
import '../Buttons/ProfileMenu.dart';

Marker marker;


class MainBodyStack extends StatefulWidget {
  final String uid;
  MainBodyStack(this.uid);

  @override
  _MainBodyStackState createState() => _MainBodyStackState();
}

class _MainBodyStackState extends State<MainBodyStack> {
  bool displayZone = false;

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
        FireMap.create(context),
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
          bottom: 150,
          left: MediaQuery.of(context).size.width - 80,
          child: RawMaterialButton(
            onPressed: () {
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
