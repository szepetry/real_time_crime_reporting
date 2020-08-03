import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instant_reporter/ZoneHandle/DisplayZones/AboutZone.dart';
import 'package:instant_reporter/ZoneHandle/ZoneDetailsInputHandle/ZoneDetails.dart';
import 'package:instant_reporter/ZoneHandle/ZoneDetailsInputHandle/ZoneDetailsNotifier.dart';
import 'package:instant_reporter/ZoneHandle/ZoneInfo.dart';
import 'package:flutter/material.dart';
import 'package:instant_reporter/ZoneHandle/ZoneUploadHandle/ZoneMaps.dart';
import 'package:provider/provider.dart';

class ZoneTapOptions extends StatelessWidget {
  final String polygonId;
  final CollectionReference zones;
  ZoneTapOptions(this.zones, this.polygonId);
  ZoneDetails infoObtained;

  @override
  Widget build(BuildContext context) {
    return Center(
      //Padding(
      //padding: MediaQuery.of(context).viewInsets,
      child: _buildCard(context),
    );
  }

  EdgeInsetsGeometry setMarginsTapOptions(
      BuildContext context, bool isPortrait) {
    return isPortrait
        ? EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.3,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            bottom: MediaQuery.of(context).size.height * 0.35,
          )
        : EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.1,
            left: MediaQuery.of(context).size.width * 0.3,
            right: MediaQuery.of(context).size.width * 0.3,
            bottom: MediaQuery.of(context).size.height * 0.2,
          );
  }

  Widget _buildCard(BuildContext context) {
    return Card(
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0)),
      margin: setMarginsTapOptions(
          context, MediaQuery.of(context).orientation == Orientation.portrait),
      child: Padding(
        padding:
            EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
        child: _buildChildren(context),
      ),
    );
  }

  Widget _buildChildren(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0, bottom: 10.0),
          child: Text(
            'Select an option',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 10.0, child: Divider(color: Colors.black)),
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              viewZoneDetails(context),
              zoneDeleteButton(context),
              updateZoneDetailsButton(context),
              cancelButton(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget zoneDeleteButton(context) {
    return SizedBox(
      width: double.infinity,
      child: FlatButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0)),
        onPressed: () async {
          await deleteZone(context);
        },
        child: Text('Delete Zone', style: TextStyle(fontSize: 20)),
        color: Colors.blue,
        textColor: Colors.white,
      ),
    );
  }

  Future<void> deleteZone(BuildContext context) async {
    String documentId = zones.document('$polygonId').documentID;
    await zones.document(documentId).delete().then((value) {
      generateDialog(context, 'Zone Delete Successful');
    }).catchError((onError) {
      generateDialog(context, 'Zone Delete Failed');
    });
  }

  Widget viewZoneDetails(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FlatButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0)),
        onPressed: () {
          displayZoneDetails(context);
        },
        child: Text('View details', style: TextStyle(fontSize: 20)),
        color: Colors.blue,
        textColor: Colors.white,
      ),
    );
  }

///////////////////////
  Widget updateZoneDetailsButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FlatButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0)),
        onPressed: () async {
          await generateZoneUpdateDialog(context);
          if (infoObtained.submitPressed)
            await updateZone(zones, infoObtained.zoneInfo, context);
        },
        child: Text('Update details', style: TextStyle(fontSize: 20)),
        color: Colors.blue,
        textColor: Colors.white,
      ),
    );
  }

  Future<void> generateDialog(BuildContext context, [String message]) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Card(
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
          margin:
              EdgeInsets.only(left: 80.0, right: 80.0, top: 320, bottom: 400),
          child: Padding(
            padding: EdgeInsets.only(
                left: 10.0, right: 10.0, top: 10.0, bottom: 0.0),
            child: messageDialog(context, message),
          ),
        ),
      ),
    );
  }

  Widget messageDialog(BuildContext context, String message) {
    return Column(
      children: <Widget>[
        Text(
          message,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8.0),
        FlatButton(
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          onPressed: () => Navigator.of(context).pop(),
          child: Text('OK', style: TextStyle(fontSize: 20)),
          color: Colors.blue,
          textColor: Colors.white,
        )
      ],
    );
  }

  Future<void> generateZoneUpdateDialog(BuildContext context,
      [String message]) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        child: createZoneDetailsDialog(context));
  }

  Widget createZoneDetailsDialog(BuildContext context) {
    ZoneInfo zoneInfo = new ZoneInfo('', '');
    return ChangeNotifierProvider<ZoneDetailsNotifier>(
      create: (context) => ZoneDetailsNotifier(),
      child: Consumer<ZoneDetailsNotifier>(
          builder: (context, zoneDetails, properties) =>
              infoObtained = ZoneDetails(zoneInfo, zoneDetails)),
    );
  }

  updateZone(CollectionReference zones, ZoneInfo zoneInfo,
      BuildContext context) async {
    String documentId = zones.document('$polygonId').documentID;
    await zones
        .document(documentId)
        .updateData(zoneInfo.zoneUpdateObject)
        .then((doc) {
      generateDialog(context, 'Zone Update Successful');
    }).catchError((onError) {
      generateDialog(context, 'Zone Update Failed');
    });
  }
  ////////////////

  Widget cancelButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FlatButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0)),
        onPressed: () => Navigator.of(context).pop(),
        child: Text('Cancel', style: TextStyle(fontSize: 20)),
        color: Colors.blue,
        textColor: Colors.white,
      ),
    );
  }

  Future<void> displayZoneDetails(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        child: AboutZone(polygonId, zones));
  }

  Widget buildDisplay(BuildContext context) {
    ZoneInfo info;
    String documentId = zones.document('$polygonId').documentID;
    return StreamBuilder(
      stream: zones.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) async {
              await zones.document(documentId).get().then(
                    (value) => info = ZoneInfo(
                        value.data['zoneColor'], value.data['notificationMsg']),
                  );
            },
          );
          return buildDetails(context, info);
        } else
          return Center(
            child:CircularProgressIndicator()
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
            SizedBox(height: 15.0, child: Divider(color: Colors.black)),
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
