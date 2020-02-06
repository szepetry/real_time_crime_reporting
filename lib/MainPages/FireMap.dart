import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

Completer<GoogleMapController> _controller = Completer();

Marker marker;

Position _currentPosition;


Future<void> moveCamera() async {
    GoogleMapController mapController = await _controller.future;

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
      zoom: 17.0,
    )));
  }

//TODO: Integrate maps
class FireMap extends StatefulWidget {
  @override
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {
  CameraPosition _userLocation = CameraPosition(
    target: LatLng(12.9747141, 77.6071635),
    zoom: 20,
  );

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    //double distanceInMeters = await Geolocator().distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);

    setState(() {
      _currentPosition = position;
    });

    GoogleMapController mapController = await _controller.future;

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
      zoom: 17.0,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _userLocation,
        myLocationButtonEnabled: false,
        myLocationEnabled: true,

        onMapCreated: (GoogleMapController controller1) async {
          _controller.complete(controller1);
          // controller1 = await _controller.future;
          // mapController = controller;
        },

        // markers: {
        //   // marker,
        // },
      ),
    );
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
