import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:async';
// import 'package:geolocator/geolocator.dart';
// import 'package:transparent_image/transparent_image.dart';
// import 'package:instant_reporter/pages/FireMap.dart';
import 'package:instant_reporter/MainPages/MainBodyStack.dart';
import 'package:instant_reporter/MainPages/BottomPanelView.dart';

// import 'package:flutter/services.dart';


class HomepageUser extends StatefulWidget {
  @override
  _HomepageUserState createState() => _HomepageUserState();
}

class _HomepageUserState extends State<HomepageUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButtonWidget(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SlidingUpPanel(
            maxHeight: 600,
            minHeight: 100,
            isDraggable: true,
            backdropEnabled: true,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0)),
            panel: BottomPanelView(),
            body: MainBodyStack(),
            collapsed: Container(
              child: Divider(thickness: 4.0,
              endIndent: MediaQuery.of(context).size.width-200,
              indent: MediaQuery.of(context).size.width-300,),
            ),),);
  }
}


//TODO: Make bottom panel
