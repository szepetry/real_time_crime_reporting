import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:instant_reporter/ZoneHandle/DisplayZones/ZoneRender.dart';
import 'package:instant_reporter/ZoneHandle/ZoneUploadHandle/AddZone.dart';
import 'package:instant_reporter/ZoneHandle/ZoneDetailsInputHandle/ZoneDetailsNotifier.dart';
import 'package:instant_reporter/ZoneHandle/ZoneInfo.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:instant_reporter/ZoneHandle/ZoneDetailsInputHandle/ZoneDetails.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum state { getDetails, other }
state currentState;
String _mapStyleNight;

class ZoneMap extends StatefulWidget {
  ZoneMap(this.addZone, this.renderZone);
  final AddZone addZone;
  final ZoneRender renderZone;

  static Widget create(BuildContext context) {
    return Provider<ZoneInfo>(
      create: (context) => ZoneInfo('', ''),
      child: ChangeNotifierProvider<AddZone>(
        create: (context) => AddZone(),
        child: Provider<ZoneRender>(
          create: (context) => ZoneRender(context, true),
          child: Consumer2<AddZone, ZoneRender>(
            builder: (context, addZone, renderZone, _) =>
                ZoneMap(addZone, renderZone),
          ),
        ),
      ),
    );
  }

  @override
  _ZoneMapState createState() => _ZoneMapState();
}

class _ZoneMapState extends State<ZoneMap> {
  AddZone get addZone => widget.addZone;
  ZoneRender get renderZone => widget.renderZone;
  Set<Polygon> tempZones = Set<Polygon>();
  bool displayZone = false;
  int zoneIndex = 1;
  List zoneDetailsResult;
  final CollectionReference zones = Firestore.instance.collection('Zones');
  ZoneDetails infoObtained;
  Position pos;
  Size get getSize => MediaQuery.of(context).size;
  ZoneInfo get getZoneInfo => infoObtained.zoneInfo;

  final notifications = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    rootBundle
        .loadString('assets/MapStyles/nightMapLandmarks.json')
        .then((json) {
      _mapStyleNight = json;
    }).then((value) => getLocation());
  }

  Future<void> getLocation() async {
    Position positionTemp =
        await Geolocator().getCurrentPosition().then<Position>((value) {
      return value;
    });
    setState(() {
      pos = positionTemp;
    });
  }

  void toggleZoneView() {
    renderZone.renderZonesV2();
    setState(() {
      displayZone = !displayZone;
      widget.renderZone.polygonsDB.forEach((element) {
        tempZones.add(element);
      });
    });
  }

  Widget zoneToggleButton() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Positioned(
      top: 0.08 * height,
      left: 0.82 * width,
      height: 0.071 * height,
      width: 0.17 * width,
      child: RaisedButton(
        elevation: 100,
        shape: new CircleBorder(
            // borderRadius: new BorderRadius.circular(30.0),
            ),
        onPressed: toggleZoneView,
        child: Center(
          child: Text(
            !displayZone ? 'Display\n Zones' : '  Hide\nZones',
            style: TextStyle(fontSize: 10),
          ),
        ),
        textColor: Colors.white,
        color: displayZone ? Colors.deepOrange[900] : Colors.green[900],
      ),
    );
  }

  Future<void> loadZones() async {}

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: pos != null
                ? GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(pos.latitude, pos.longitude),
                        zoom: 19.0),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                    markers: Set.from(addZone.allMarkers),
                    onMapCreated: (controller) {
                      controller.setMapStyle(_mapStyleNight);
                    },
                    polygons:
                        !displayZone ? addZone.polygons : renderZone.polygonsDB,
                    onTap: (point) {
                      addZone.renderZone(point);
                    })
                : Center(child: CircularProgressIndicator())),
        //  refreshButton(),
        zoneToggleButton(),
        listOfButtons(),
      ],
    );
  }

  EdgeInsetsGeometry generateDialogMargins() {
    return EdgeInsets.only(
        left: getSize.width * 0.18,
        right: getSize.width * 0.18,
        top: getSize.height * 0.3,
        bottom: getSize.height * 0.56);
  }

  Future<void> generateDialog([String message]) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        child: (currentState == state.getDetails)
            ? createZoneDetailsDialog()
            : Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Card(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  margin: generateDialogMargins(),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10.0, bottom: 0.0),
                    child: messageDialog(message),
                  ),
                ),
              ));
  }

  Widget createZoneDetailsDialog() {
    ZoneInfo zoneInfo = Provider.of<ZoneInfo>(context, listen: false);
    return ChangeNotifierProvider<ZoneDetailsNotifier>(
      create: (context) => ZoneDetailsNotifier(),
      child: Consumer<ZoneDetailsNotifier>(
        builder: (context, zoneDetails, properties) =>
            infoObtained = ZoneDetails(zoneInfo, zoneDetails),
      ),
    );
  }

  Widget messageDialog(String message) {
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

  Future<void> uploadZone() async {
    if (addZone.validateZone) {
      currentState = state.getDetails;
      await generateDialog();
      if (getZoneInfo.cancel != true)
        await addZone.uploadZone(zoneIndex, zones, getZoneInfo)
            ? await generateDialog('Zone upload successful')
            : await generateDialog('Zone upload failed');
    } else
      generateDialog('Minimum 3 points required');
  }

  Widget listOfButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            addZone.uploading != true
                ? FlatButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    onPressed: !displayZone
                        ? () async {
                            uploadZone();
                          }
                        : null,
                    child: Text('Upload Zone', style: TextStyle(fontSize: 10)),
                    textColor: Colors.white,
                    color: Colors.blue[400],
                    disabledColor: Colors.grey[400],
                    disabledTextColor: Colors.white,
                  )
                : CircularProgressIndicator(),
            SizedBox(height: 8.0),
            FlatButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              onPressed: addZone.isMarkerPresent
                  ? () async {
                      addZone.undo();
                    }
                  : null,
              child: Text('Undo', style: TextStyle(fontSize: 10)),
              textColor: Colors.white,
              color: Colors.blue[400],
              disabledColor: Colors.grey[400],
              disabledTextColor: Colors.white,
            ),
            SizedBox(height: 8.0),
            FlatButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              onPressed: addZone.isMarkerPresent
                  ? () {
                      addZone.clearLists();
                    }
                  : null,
              child:
                  Text('Cancel the Set Zone', style: TextStyle(fontSize: 10)),
              textColor: Colors.white,
              color: Colors.blue[400],
              disabledColor: Colors.grey[400],
              disabledTextColor: Colors.white,
            ),
            SizedBox(height: 8.0),
            FlatButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Back to Homepage', style: TextStyle(fontSize: 10)),
              textColor: Colors.white,
              color: Colors.blue[400],
              disabledTextColor: Colors.white,
            ),
          ]),
    );
  }
}

/* 
  Future<void> getZones() async {
    var zoneData = [];
    await zones.getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((zones) => zoneData.add(zones.data));
    });

    convertToLatLng(zoneData);
  }

  void convertToLatLng(List zoneData) {
    double latitude, longitude;
    List<List<LatLng>> listOfZones = new List<List<LatLng>>();
    for (int k = 0; k < zoneData.length; k++) {
      for (int i = 0; i < zoneData[k].length; i++) {
        latitude = double.parse(zoneData[k]['Point$i'][0].toString());
        longitude = double.parse(zoneData[k]['Point$i'][1].toString());
        polygonLatLngsDB.add(LatLng(latitude, longitude));
      }
      print('------------------------------');
      print(polygonLatLngsDB);
      listOfZones.add(polygonLatLngsDB);
    }
    setZonesFromDB(listOfZones);
  }

  void setZonesFromDB(List<List<LatLng>> listOfZones) {
    final String polygonIdVal = 'polygon_id_${_polygonIdCounterDB++}';
    setState(() {
      for (int i = 0; i < listOfZones.length; i++) {
        _polygonsFromDB.add(Polygon(
          polygonId: PolygonId('polygon_id_${_polygonIdCounterDB++}'),
          points: listOfZones[i],
          strokeWidth: 2,
          strokeColor: Colors.red,
          fillColor: Colors.green.withOpacity(0.15),
        ));
      }
      //finished=true;
    });
    Future confirmZoneUpload() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Upload Confirmation'),
            content: Text('Are you sure you want to upload this Zone'),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              new FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    updateZone = true;
                  }),
              FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    updateZone = false;
                  }),
            ],
          );
        });
  }

  } */
