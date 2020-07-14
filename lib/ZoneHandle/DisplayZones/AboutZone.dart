import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instant_reporter/ZoneHandle/ZoneInfo.dart';
import 'package:flutter/material.dart';


class AboutZone extends StatelessWidget {
  final String polygonId;
  final CollectionReference zones;
  AboutZone(this.polygonId, this.zones);

  @override
  Widget build(BuildContext context) {
    ZoneInfo info;
    String documentId = zones.document('$polygonId').documentID;
    return StreamBuilder<DocumentSnapshot>(
      stream: zones.document(documentId).get().asStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          info = ZoneInfo(
              snapshot.data['zoneColor'], snapshot.data['notificationMsg']);
          return buildDetails(context, info);
        } else
          return Center(
            child:CircularProgressIndicator(),
          );
      },
    );
  }

  Widget buildDetails(BuildContext context, ZoneInfo info) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Card(
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0)),
      margin: isPortrait
          ? EdgeInsets.only(left: 60.0, right: 60.0, top: 270, bottom: 410)
          : EdgeInsets.only(left: 200.0, right: 200.0, top: 120, bottom: 140),
      child: Padding(
        padding:
            EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0, bottom: 15.0),
        child: Column(
          children: <Widget>[
            buildZoneColorText(info),
            SizedBox(height: 15.0, child: Divider(color: Colors.black)),
            buildZoneDetailsText(info),
          ],
        ),
      ),
    );
  }

  Widget buildZoneColorText(ZoneInfo info) {
    return Text(
      '${info.zoneColor} Zone',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: ascertainColor(info.zoneColor),
      ),
    );
  }

  Widget buildZoneDetailsText(ZoneInfo info) {
    return Text(
      '${info.zoneDetails}',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
    );
  }

  Color ascertainColor(String color) {
    switch (color) {
      case 'Red':
        return Colors.red;
        break;
      case 'Orange':
        return Colors.orange;
        break;
      case 'Green':
        return Colors.green;
        break;
      default:
        return Colors.black;
    }
  }
}
