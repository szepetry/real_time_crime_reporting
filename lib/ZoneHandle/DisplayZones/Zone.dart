import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:poly/poly.dart' as virtualZone;

class Zone {
  DocumentSnapshot zone;
  Zone(this.zone);
  double _latitude, _longitude;

  GeoPoint getZonePoint(int k, int index) {
    GeoPoint point = zone.data['Point$k'];
    return point;
  }

  int get getNoOfPoints => zone.data.length;

  String get getDocumentId => zone.documentID;

  String get getZoneColor => zone.data['zoneColor'];

  LatLng parseToCoordinate(int k) {
    _latitude = getZonePoint(k, 0).latitude;
    _longitude = getZonePoint(k, 1).longitude;
    return LatLng(_latitude, _longitude);
  }

  Color ascertainColor(String color) {
    switch (color) {
      case 'Red':
        return Colors.red;
        break;
      case 'Orange':
        return Colors.deepOrange;
        break;
      case 'Green':
        return Colors.green;
        break;
      default:
        return Colors.black;
    }
  }
}

class MathZone {
  String zoneId;
  virtualZone.Polygon mathZone;
  MathZone(this.zoneId, this.mathZone);

  String get getZoneId => this.zoneId;
  virtualZone.Polygon get getMathZone => this.mathZone;

  Map<String, dynamic> toMap() {
    return {'zoneId': zoneId, 'mathZone': mathZone};
  }
}
