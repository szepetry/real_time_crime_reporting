import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instant_reporter/AuthenticationHandle/LandingPage.dart';
import 'package:instant_reporter/AuthenticationHandle/StateNotifiers/FirestoreService.dart';
import 'package:instant_reporter/ZoneHandle/DisplayZones/AboutZone.dart';
import 'package:instant_reporter/ZoneHandle/DisplayZones/Zone.dart';
import 'package:instant_reporter/ZoneHandle/DisplayZones/ZoneTapOptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ZoneRender {
  BuildContext context;
  bool isAdding;
  ZoneRender(this.context, [this.isAdding]);
  final CollectionReference zones = Firestore.instance.collection('Zones');
  Set<Polygon> polygonsDB = HashSet<Polygon>();
  List<LatLng> zoneListDB = [];
  Set<Polygon> displayZones = HashSet<Polygon>();
  bool isZoneLoading = false;
  /* bool displayZonev2 = false;
  set setDisplayZone(bool value) {
    this.displayZonev2 = value;
    notifyListeners();
  } */

  Future<void> renderZonesV2() async {
    polygonsDB.clear();
    await zones.getDocuments().then((zoneList) {
      for (int i = 0; i < zoneList.documents.length; i++) {
        Zone zone = new Zone(zoneList.documents.elementAt(i));

        for (int k = 0; k < zone.getNoOfPoints - 2; k++)
          zoneListDB.add(zone.parseToCoordinate(k));

        addZoneToPolygon(zone);
        zoneListDB = [];
      }
    });
    polygonsDB.forEach((element) {
      print(element.polygonId.value);
    });
  }

  void addZoneToPolygon(Zone zone) {
    final String zoneId = zone.getDocumentId;
    final String color = zone.getZoneColor;
    Color zoneColor = zone.ascertainColor(color);
    polygonsDB.add(Polygon(
      polygonId: PolygonId(zoneId),
      points: zoneListDB,
      strokeWidth: 2,
      strokeColor: zoneColor,
      fillColor: zoneColor.withOpacity(0.15),
      consumeTapEvents: true,
      onTap: (PolygonId polygonId) async {
        if (isAdding != true) {
          UserDetails user = Provider.of<UserDetails>(context, listen: false);
          await zoneTapDialog(polygonId.value, user.getUid);
        }
      },
    ));
    //  notifyListeners();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {  notifyListeners();});
  }

  Future<void> zoneTapDialog(String polygonId, String uid) async {
    return showDialog(
      context: this.context,
      barrierDismissible: false,
      child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirestoreService.registeredUserStream(uid),
            builder: (context, firestoreSnapshot) {
              if (firestoreSnapshot.hasData) {
                if (firestoreSnapshot.data['occupation'] != 'Police')
                  return AboutZone(polygonId, zones);
                else
                  return ZoneTapOptions(zones, polygonId);
              } else
                return Center(child: SpinKitSquareCircle(
                color: Colors.grey,
                   size: 50.0,
            ));
            },
          ) // ZoneTapOptions(zones, polygonId),
          ),
    );
  }
}

/*

void renderZones(List<DocumentChange> zonesDB) {
    // polygonsDB.clear();
    for (int i = 0; i < zonesDB.length; i++) {
      isAdded = zonesDB[i].type == DocumentChangeType.added;
      isDeleted = zonesDB[i].type == DocumentChangeType.removed;
      isUpdated = zonesDB[i].type == DocumentChangeType.modified;
      //print('sssssssssssssssssssssssssss');print(isDeleted);
      Zone zone = new Zone(zonesDB[i]);
      if (isAdded) {
        for (int k = 0; k < zone.getNoOfPoints - 2; k++)
          zoneListDB.add(zone.parseToCoordinate(k));
        if(isUpdated){
        polygonsDB.removeWhere((element) => element.polygonId.value == zone.getDocumentId);
        }
        addZoneToPolygon(zone);
        zoneListDB = [];
      } 
       if (isDeleted) {
        polygonsDB.removeWhere(
            (element) {
              print(element.polygonId.value);
              print(zone.getDocumentId);
              return element.polygonId.value.contains(zone.getDocumentId) || zone.getDocumentId.contains(element.polygonId.value);}  );
        displayZones.removeWhere(
            (element) {
              print(element.polygonId.value);
              print(zone.getDocumentId);
              return element.polygonId.value.contains(zone.getDocumentId) || zone.getDocumentId.contains(element.polygonId.value);}  );
       // refreshZones();
      }
    }
  
  
  }

StreamBuilder<DocumentSnapshot>(
          stream: FirestoreService.registeredUserStream(uid),
          builder: (context, firestoreSnapshot) {
            if (firestoreSnapshot.hasData) {
              if (firestoreSnapshot.data['occupation'] != 'police')
                return AboutZone(polygonId, zones);
              else
                return ZoneTapOptions(zones, polygonId);
            }
            else
                return Center(child: CircularProgressIndicator());
          },
        )

  bool isPointInside(LatLng point){
    List<ply.Point<num>> polyList = [];
    points.forEach((element) =>polyList.add(ply.Point(point.latitude, point.longitude) );
    ply.Polygon test = ply.Polygon(polyList);
      if(test.contains(point.latitude, point.longitude))
      return true;
      else
      return false;
      /*  ZoneUpload(){
    
  var geolocator = Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  List<Point<num>> polyList = [];
    points.forEach((element) =>polyList.add(Point(element.latitude, element.longitude) ));
Zone test = Zone(polyList);
  StreamSubscription<Position> positionStream =
      geolocator.getPositionStream(locationOptions).listen((Position position) {
        test.contains(position.latitude, position.longitude);
       // _checkIfPointInside(position);
  });
  } */
    // polygonsDB.forEach((element) { print(element.isPointInside(point));});
    /* List<ply.Point<num>> polyList = [];
    polygonsDB.forEach((element) {
      element.points.forEach((element) {
        polyList.add(ply.Point(point.latitude, point.longitude));
      });
      ply.Polygon test = ply.Polygon(polyList);
      if(test.contains(point.latitude, point.longitude))
      print(element.polygonId);
    });
    ply.Point in1 = ply.Point(point.latitude, point.longitude); */
  } */
