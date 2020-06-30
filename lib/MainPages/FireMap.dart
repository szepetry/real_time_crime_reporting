import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:instant_reporter/common_widgets/constants.dart';

Completer<GoogleMapController> _controller = Completer();

Marker marker;

Position _currentPosition;

String _mapStyleNight;

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

class FireMap extends StatefulWidget {
  @override
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {
  GoogleMapController mapController;
  Position position;
  Widget _child;

  @override
  void initState() {
    rootBundle.loadString('assets/MapStyles/nightMap.json').then((json) {
      _mapStyleNight = json;
    });
    // _child=RippleIndicator("Getting Location");
    getCurrentLocation();

    populateStations();
    super.initState();
  }

  List<Placemark> placemark;
  String _address;
  void getAddress(double latitude, double longitude) async {
    placemark =
        await Geolocator().placemarkFromCoordinates(latitude, longitude);
    _address =
        placemark[0].name.toString() + "," + placemark[0].locality.toString();
    setState(() {
      _child = mapWidget();
    });
  }

  void getCurrentLocation() async {
    Position res = await Geolocator().getCurrentPosition();
    setState(() {
      position = res;
    });

    var _lat = position.latitude;
    var _lng = position.longitude;
    await getAddress(_lat, _lng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(cardColor),
      body: _child,
    );
  }

  Widget mapWidget() {
    var googleMap = GoogleMap(
      mapType: MapType.normal,
      markers: Set<Marker>.of(markers.values),

      //   onMapCreated: onMapCreated,
      //markers: _createMarker(),
      initialCameraPosition: CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 15.0),
      myLocationButtonEnabled: false,
      myLocationEnabled: true,

      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        mapController = controller;
        mapController.setMapStyle(_mapStyleNight);
      },
    );
    return googleMap;
  }

  populateStations() {
//     //stations = [];
    Firestore.instance
        .collection('police_stations')
        .getDocuments()
        .then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
          // stations.add(docs.documents[i].data);
          initMarker(docs.documents[i].data, docs.documents[i].documentID);
        }
      }
    });
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  void initMarker(request, requestId) {
    var markerIdVal = requestId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position:
          LatLng(request['location'].latitude, request['location'].longitude),
      infoWindow: InfoWindow(title: request['name'], snippet: 'address'),
      draggable: false,
    );

    setState(() {
      markers[markerId] = marker;
      print(markerId);
    });
  }
}

// Completer<GoogleMapController> _controller = Completer();

// Marker marker;

// Position _currentPosition;
// var geolocator = Geolocator();

// var locationOptions =
//     LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

// Marker someMarker = Marker(
//     markerId: MarkerId('someMarker1'),
//     position: LatLng(12.8908356, 77.6414201),
//     infoWindow: InfoWindow(title: "SOme place"),
//     icon: BitmapDescriptor.defaultMarkerWithHue(
//       BitmapDescriptor.hueCyan,
//     ));
