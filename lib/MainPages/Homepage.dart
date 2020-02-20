import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:async';
// import 'package:geolocator/geolocator.dart';
// import 'package:transparent_image/transparent_image.dart';
// import 'package:sih_app/pages/FireMap.dart';
import 'package:sih_app/MainPages/MainBodyStack.dart';
import 'package:sih_app/MainPages/BottomPanelView.dart';

// import 'package:flutter/services.dart';


class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
            body: MainBodyStack()));
  }
}


//TODO: Make bottom panel
