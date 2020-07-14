import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instant_reporter/ZoneHandle/ZoneInfo.dart';
import 'package:instant_reporter/ZoneHandle/ZoneUploadHandle/ZoneMaps.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddZone with ChangeNotifier {
  int zoneIndex = 1;
  List<Marker> allMarkers = new List<Marker>();
  List<LatLng> zoneLatLngs = new List<LatLng>();
  Set<Polygon> polygons = HashSet<Polygon>();
  String zoneId;
  String markerId;
  bool uploading;

  void renderZone(LatLng point) {
    markerId = Random().nextDouble().toString();
    zoneLatLngs.add(point);
    allMarkers.add(Marker(
        markerId: MarkerId(markerId), draggable: false, position: point));

    if (zoneLatLngs.length >= 3) {
      final String polyId = '$createZoneId';
      print(polyId);
      polygons.add(Polygon(
          polygonId: PolygonId(polyId),
          points: zoneLatLngs,
          strokeWidth: 2,
          strokeColor: Colors.red,
          fillColor: Colors.red.withOpacity(0.15),
          onTap: (PolygonId polygonId) {
            print(polygonId.value);
          }));
    }
    notifyListeners();
  }

  String get createZoneId {
    double zoneCode =
        DateTime.now().microsecond.toDouble() + Random().nextDouble();
    zoneId = zoneCode.toString();
    //zoneId = timeStamp.toString() + Random().nextDouble().toString();
    return zoneId;
  }

  bool get validateZone => zoneLatLngs.length >= 3;
  bool get isMarkerPresent => allMarkers.isNotEmpty;

  clearLists() {
    allMarkers.clear();
    zoneLatLngs.clear();
    polygons.clear();
    notifyListeners();
  }

  Future<bool> uploadZone(
      int zoneIndex, CollectionReference zones, ZoneInfo infoObtained) async {
    print(zoneId);
    uploading = true;
    notifyListeners();
    for (int i = 0; i < zoneLatLngs.length; i++) {
      print(zoneLatLngs.length);
      await zones
          .document('Zone$zoneId')
          .setData(
              ZoneUpload(zoneLatLngs[i].latitude, zoneLatLngs[i].longitude,
                      infoObtained.zoneColor, i, infoObtained.zoneDetails)
                  .toMap(),
              merge: true)
          .catchError((e) {
        print(e);
        currentState = state.other;
        uploading = false;
        notifyListeners();
        return Future.value(false);
      });
    }
    uploading = false;
    notifyListeners();
    currentState = state.other;
    return Future.value(true);
  }

  void undo() {
    allMarkers.removeLast();
    zoneLatLngs.removeLast();
    notifyListeners();
  }
}

class ZoneUpload {
  ZoneUpload(this.latitude, this.longitude, this.zoneColor, this.i,
      this.notificationMsg);
  final double latitude;
  final double longitude;
  final String zoneColor;
  final String notificationMsg;
  int i;

  Map<String, dynamic> toMap() {
    return {
      'Point$i': GeoPoint(latitude, longitude),
      'zoneColor': zoneColor,
      'notificationMsg': notificationMsg,
    };
  }
}
