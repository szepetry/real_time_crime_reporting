import 'package:flutter/material.dart';
import 'package:instant_reporter/AuthenticationHandle/LandingPage.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:async";
import 'package:flutter/services.dart' show rootBundle;

import 'package:instant_reporter/common_widgets/constants.dart';
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
  FireMapPolice(); //use this uid here
  @override
  _FireMapPoliceState createState() => _FireMapPoliceState();
}

class _FireMapPoliceState extends State<FireMapPolice> {
  String uid;
  GoogleMapController mapController;
  Widget _child;
  StreamSubscription _streamSubscription;//n
  Stream _stream = Firestore.instance.collection("registeredUsers").snapshots(); //n
  double lat, lng;
  BitmapDescriptor myIcon;
  int temp;

  @override
  void initState() {
    rootBundle.loadString('assets/MapStyles/nightMap.json').then((json) {
      _mapStyleNight = json;
    }).then((value) {
      UserDetails u = Provider.of<UserDetails>(context, listen: false);
      uid = u.uid;
      moveCamera();
      BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(128, 128)),
              'assets/images/police.png')
          .then((onValue) {
        myIcon = onValue;
      });

      getCurrentLocation(); //current location of the police official
      _streamSubscription = _stream.listen((event) {
        debugPrint("$event happened?");
      });

      _streamSubscription.onData((data) {
        for (int i = 0; i < data.documents.length; i++) {
          temp = i;
          if (data.documents[i].documentID != uid) {
            if(data.documents[i].data['occupation']=="Police"){
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
          }}
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
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueMagenta),
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
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueMagenta),
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
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
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
            if(docs.documents[i].data["occupation"]=="Police"){
            debugPrint("id$i   ${docs.documents[i].documentID}!=$uid");
            initMarker(docs.documents[i].data, docs.documents[i].documentID);
          }}
        }
      }
    });

    setState(() {
      _child = mapWidget();
    });
  }

  List<Marker> allMarkers = [];

  @override
  Widget build(BuildContext context) {
    UserDetails u = Provider.of<UserDetails>(context, listen: false);
    uid = u.uid;
    return Scaffold(body: _child);
  }

  Widget mapWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      //markers: Set<Marker>.of(markers.values),
      markers: Set<Marker>.of(allMarkers),
      initialCameraPosition:
          CameraPosition(target: LatLng(12.9932732, 77.593868), zoom: 17.0),
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      mapToolbarEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        mapController = controller;
        mapController.setMapStyle(_mapStyleNight);
      },
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
