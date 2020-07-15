import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:instant_reporter/AuthenticationHandle/LandingPage.dart';
import 'package:instant_reporter/ZoneHandle/DisplayZones/ZoneRender.dart';
import 'package:instant_reporter/ZoneHandle/ZoneNotify.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:async";
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_database/firebase_database.dart';


Completer<GoogleMapController> _controller = Completer();
String _mapStyleNight;
DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

Stream reportStream = _databaseReference.onChildAdded.asBroadcastStream();
Stream addReportStream = _databaseReference.onChildChanged.asBroadcastStream();

StreamSubscription reportStreamSubscription;
StreamSubscription addReportStreamSubscription;

Future<void> moveCamera() async {
  await Geolocator()
      .getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          locationPermissionLevel: GeolocationPermission.locationAlways)
      .then((value) async {
    GoogleMapController mapController = await _controller.future;

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(value.latitude, value.longitude),
      zoom: 17.0,
    )));
  });
}

class FireMapPolice extends StatefulWidget {
  final ZoneRender renderZone;
  FireMapPolice(this.renderZone); //use this uid here

  static Widget create(BuildContext context) {
    return Provider<ZoneRender>(
      create: (context) => ZoneRender(context),
      child: Consumer<ZoneRender>(
          builder: (context, renderZone, _) => FireMapPolice(renderZone)),
    );
  }

  @override
  _FireMapPoliceState createState() => _FireMapPoliceState();
}

class _FireMapPoliceState extends State<FireMapPolice>
    with SingleTickerProviderStateMixin {
  ZoneRender get renderZone => widget.renderZone;
  String uid;
  GoogleMapController mapController;
  Widget _child;
  StreamSubscription _streamSubscription; //n
  Stream _stream =
      Firestore.instance.collection("registeredUsers").snapshots(); //n
  double lat, lng;
  BitmapDescriptor myIcon;
  bool displayZone = false;
  BitmapDescriptor myIcon1;
  int temp;
  AnimationController rotationController;

  @override
  void initState() {
    rootBundle
        .loadString('assets/MapStyles/nightMapLandmarks.json')
        .then((json) {
      _mapStyleNight = json;
    }).then((value) {
      UserDetails u = Provider.of<UserDetails>(context, listen: false);
      uid = u.uid;
      moveCamera();
      BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(64, 64)),
              'assets/images/police.png')
          .then((onValue) {
        myIcon = onValue;
      });
      BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(64, 64)),
              'assets/images/report.png')
          .then((onValue) {
        myIcon1 = onValue;
      });
      getCurrentLocation(); //current location of the police official
      _streamSubscription = _stream.listen((event) {
        debugPrint("$event happened?");
      });

      _streamSubscription.onData((data) {
        for (int i = 0; i < data.documents.length; i++) {
          temp = i;
          if (data.documents[i].documentID != uid) {
            if (data.documents[i].data['occupation'] == "Police") {
              // debugPrint(
              //     "${data.documents[i].data['location'].latitude}, ${data.documents[i].data['location'].longitude}");
              // debugPrint("${data.documents[i].data['name']}");
              allMarkers.add(new Marker(
                  markerId: MarkerId('${i.toString()}'),
                  position: new LatLng(
                      data.documents[i].data['location'].latitude,
                      data.documents[i].data['location'].longitude),
                  infoWindow: InfoWindow(
                      title: data.documents[i].data['name'],
                      snippet:
                          "${data.documents[i].data['location'].latitude}, ${data.documents[i].data['location'].longitude}"),
                  icon: myIcon,
                  consumeTapEvents: false));
            }
          }
        }
        setState(() {
          _child = mapWidget();
        });
      });
    }).then((value) async {
      await _databaseReference.child("").once().then((snapshot) {
        // debugPrint("Hello "+value.value);

        // if (value.value != null)
        Map<dynamic, dynamic> reportObjects = snapshot.value;
        // print(values.toString());
        reportObjects.forEach((key, value) {
          List<dynamic> multiObjects = value["multiObject"];
          // debugPrint(key.toString());
          // debugPrint(value["name"].toString());
          multiObjects.forEach((infoObject) {
            // debugPrint(value['infoObject'][0]['location'].toString());
            String coordinate = infoObject['infoObject'][0]['location'];
            List<String> coordinateList = coordinate.split(", ");
            // Position position = Position(latitude: ,longitude:);
            debugPrint(
                "The location: ${double.parse(coordinateList[0].split(": ")[1])},${double.parse(coordinateList[1].split(": ")[1])}");
            allMarkers.add(new Marker(
                markerId: MarkerId('${temp.toString()}'),
                position: LatLng(double.parse(coordinateList[0].split(": ")[1]),
                    double.parse(coordinateList[1].split(": ")[1])),
                infoWindow: InfoWindow(
                    title: value['name'].toString(),
                    snippet:
                        "${infoObject['infoObject'][0]['location'].toString()}"),
                icon: myIcon1,
                consumeTapEvents: false));
            temp++;
            setState(() {
              _child = mapWidget();
            });
          });
        });
      }).then((value) {
        reportStreamSubscription = reportStream.listen((event) {
          return event;
        });
        addReportStreamSubscription = addReportStream.listen((event) {
          return event;
        });

        reportStreamSubscription.onData((data) {
          debugPrint("Police maps: Report added: " + data.toString());
        });
        addReportStreamSubscription.onData((data) {
          List<dynamic> multiObjects = data.snapshot.value['multiObject'];
          debugPrint("Police maps: Report modified: " +
              data.snapshot.value['multiObject'].toString());
          multiObjects.forEach((infoObject) {
            // debugPrint(value['infoObject'][0]['location'].toString());
            String coordinate = infoObject['infoObject'][0]['location'];
            List<String> coordinateList = coordinate.split(", ");
            // Position position = Position(latitude: ,longitude:);
            debugPrint(
                "The location: ${double.parse(coordinateList[0].split(": ")[1])},${double.parse(coordinateList[1].split(": ")[1])}");
            allMarkers.add(new Marker(
                markerId: MarkerId('${temp.toString()}'),
                position: LatLng(double.parse(coordinateList[0].split(": ")[1]),
                    double.parse(coordinateList[1].split(": ")[1])),
                infoWindow: InfoWindow(
                    title: data.snapshot.value['name'].toString(),
                    snippet:
                        "${infoObject['infoObject'][0]['location'].toString()}"),
                icon: myIcon1,
                consumeTapEvents: false));
            temp++;
            setState(() {
              _child = mapWidget();
            });
          });
        });
      });
    });

    super.initState();
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
        upperBound: 22 * 6 / 7);
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    rotationController.dispose();
    super.dispose();
  }

  void getCurrentLocation() async {
    await Geolocator()
        .getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            locationPermissionLevel: GeolocationPermission.locationAlways)
        .then((value) {
      lat = value.latitude;
      lng = value.longitude;
      updateData(lat, lng);
    }).then((value) {
      getAddress(lat, lng);
    });
  }

  void getAddress(double latitude, double longitude) async {
    UserDetails u = Provider.of<UserDetails>(context, listen: false);
    uid = u.uid;
    setState(() {
      _child = mapWidget();
    });

    await Firestore.instance
        .collection('registeredUsers')
        .getDocuments()
        .then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
          if (docs.documents[i].documentID != uid) {
            if (docs.documents[i].data["occupation"] == "Police") {
              debugPrint("id$i   ${docs.documents[i].documentID}!=$uid");
              initMarker(docs.documents[i].data, docs.documents[i].documentID);
            }
          }
        }
      }
    });

    setState(() {
      _child = mapWidget();
    });
  }

  List<Marker> allMarkers = [];

  void toggleZoneView() {
    setState(() {
      displayZone = !displayZone;
      _child = mapWidget();
    });
  }

  Future<void> loadZones() async {
    rotationController.forward(from: 0.0);
    await renderZone.renderZonesV2();
  }

  Widget zoneToggleButton() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Positioned(
      top: 0.08 * height,
      left: 0.82 * width,
      height: 0.060 * height,
      width: 0.17 * width,
      child: RaisedButton(
        elevation: 100,
        shape: new CircleBorder(
            // borderRadius: new BorderRadius.circular(30.0),
            ),
        onPressed: toggleZoneView,
        child: Center(
          child: Text(
            !displayZone ? 'Display\n zones' : ' Hide\nzones',
            style: TextStyle(fontSize: 10),
          ),
        ),
        textColor: Colors.white,
        color: displayZone ? Colors.deepOrange[900] : Colors.green[900],
      ),
    );
  }

  Widget refreshButton() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Positioned(
      top: 0.16 * height,
      left: 0.82 * width,
      height: 0.060 * height,
      width: 0.17 * width,
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 2.0).animate(rotationController),
        child: RaisedButton(
          elevation: 100,
          shape: new CircleBorder(),
          onPressed: () async {
            await loadZones();
            setState(() {
              _child = mapWidget();
            });
          },
          child: Padding(
            padding: EdgeInsets.only(right: width * 0.02),
            child: Padding(
              padding: EdgeInsets.only(right: 30),
              child: Icon(Icons.autorenew, size: 40),
            ),
          ),
          textColor: Colors.white,
          color: Colors.blue,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserDetails u = Provider.of<UserDetails>(context, listen: false);
    uid = u.uid;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _child != null
              ? _child
              : Center(
                  child: CircularProgressIndicator(),
                ),
          zoneToggleButton(),
          refreshButton()
        ],
      ),
    );
  }

  Widget mapWidget() {
    print(renderZone.polygonsDB);
    return GoogleMap(
      mapType: MapType.normal,
      //markers: Set<Marker>.of(markers.values),
      markers: Set<Marker>.of(allMarkers),
      initialCameraPosition:
          CameraPosition(target: LatLng(13.018302, 77.508173), zoom: 18.0),
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      mapToolbarEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        mapController = controller;
        mapController.setMapStyle(_mapStyleNight);
      },
      polygons: renderZone.polygonsDB.isNotEmpty
          ? displayZone ? Set.from(renderZone.polygonsDB) : null
          : null,
    );
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  void initMarker(request, requestId) {
    var markerIdVal = requestId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markerId,
        position:
            LatLng(request['location'].latitude, request['location'].longitude),
        infoWindow: InfoWindow(title: request['name'], snippet: markerIdVal),
        draggable: false,
        icon: myIcon,
        consumeTapEvents: false);

    setState(() {
      markers[markerId] = marker;
      print(markerId);
    });
  }

  updateData(latitude, longitude) async {
    UserDetails u = Provider.of<UserDetails>(context, listen: false);
    uid = u.uid;
    await Firestore.instance
        .collection('registeredUsers')
        .document('${u.uid}')
        .updateData({
      "location": GeoPoint(latitude, longitude),
    });
  }
}
