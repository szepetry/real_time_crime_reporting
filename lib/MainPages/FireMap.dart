import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:instant_reporter/common_widgets/constants.dart';
import 'package:google_maps_webservice/places.dart';

Completer<GoogleMapController> _controller = Completer();

Marker marker;

// Position _currentPosition;

String _mapStyleNight;

final places =
    new GoogleMapsPlaces(apiKey: "AIzaSyBjda17Zi7B4rKjHRGDDRjojs6DSeb-VDg");

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
  // Position position;
  Widget _child;

  @override
  void initState() {
    rootBundle.loadString('assets/MapStyles/nightMap.json').then((json) {
      _mapStyleNight = json;
    }).then((value) {
      moveCamera();

      getCurrentLocation();
    });
    super.initState();
  }

  void getCurrentLocation() async {
    await Geolocator()
        .getCurrentPosition(
            locationPermissionLevel: GeolocationPermission.locationAlways,
            desiredAccuracy: LocationAccuracy.high)
        .then((value) async {
      await places
          .searchByText("Police stations",
              location: Location(value.latitude, value.longitude),
              opennow: true,
              type: "police",
              radius: 2000)
          .then((response) async {
        for (int i = 0; i < response.results.length; i++) {
          debugPrint("Name $i: " + response.results[i].name);
          // await takeAddress(
          //     response.results[i].name,
          //     i,
          //     response.results[i].name);
          await takeAddress(
              response.results[i].name +
                  ", " +
                  response.results[i].formattedAddress,
              i,
              response.results[i].name);
        }

        if (response.hasNoResults ||
            response.isDenied ||
            response.isInvalid ||
            response.isNotFound) print("Here err: " + response.errorMessage);
      });
    });
  }

  List<Placemark> placemark;

  void takeAddress(String address, int j, String name) async {
    setState(() {
      _child = mapWidget();
    });

    debugPrint("Address of police station $j " + address);
    placemark = await Geolocator().placemarkFromAddress(address);
    debugPrint("Name " + placemark[0].locality);

    initMarker(placemark[0], j.toString(), name,
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));

    // await Firestore.instance
    //     .collection('registeredHospitals')
    //     .getDocuments()
    //     .then((doc) {
    //   if (doc.documents.isNotEmpty) {
    //     for (int i = 0; i < doc.documents.length; ++i) {
    //       if (doc.documents[i].data['name'].toString() == name) {
    //         if (doc.documents[i].data['beds'] == '0') {
    //           initFireMarker(
    //               placemark[0],
    //               j.toString(),
    //               name,
    //               BitmapDescriptor.defaultMarkerWithHue(
    //                   BitmapDescriptor.hueYellow),
    //               "Beds available: ${doc.documents[i].data['beds']} ;  Facilities: ${doc.documents[i].data['facilities'].toString()}");
    //         } else if (doc.documents[i].data['beds'] != '0') {
    //           initFireMarker(
    //               placemark[0],
    //               j.toString(),
    //               name,
    //               BitmapDescriptor.defaultMarkerWithHue(
    //                   BitmapDescriptor.hueGreen),
    //               "Beds available: ${doc.documents[i].data['beds']} ;  Facilities: ${doc.documents[i].data['facilities'].toString()}");
    //         }
    //       }
    //     }
    //   }
    // });

    setState(() {
      _child = mapWidget();
    });
  }

  Widget mapWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      markers: Set<Marker>.of(markers.values),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      buildingsEnabled: false,
      compassEnabled: true,
      indoorViewEnabled: false,
      // liteModeEnabled: true,
      trafficEnabled: false,

      initialCameraPosition:
          CameraPosition(target: LatLng(12.9538477, 77.3507442), zoom: 15.0),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);

        mapController = controller;
        mapController.setMapStyle(_mapStyleNight);
      },
    );
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void initMarker(request, requestId, name, BitmapDescriptor icon) {
    var markerIdVal = requestId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(request.position.latitude, request.position.longitude),
        infoWindow: InfoWindow(
            title: "$name, ${request.subLocality}",
            snippet: "(${request.position})"),
        draggable: false,
        icon: icon);

    setState(() {
      markers[markerId] = marker;
      print(markerId);
    });
  }

  // void initFireMarker(
  //     request, requestId, name, BitmapDescriptor icon, String aval) {
  //   var markerIdVal = requestId;
  //   final MarkerId markerId = MarkerId(markerIdVal);
  //   final Marker marker = Marker(
  //       markerId: markerId,
  //       position: LatLng(request.position.latitude, request.position.longitude),
  //       infoWindow: InfoWindow(
  //           title: "$name, ${request.subLocality}, ${request.locality}",
  //           snippet: aval),
  //       draggable: false,
  //       icon: icon);

  //   setState(() {
  //     markers[markerId] = marker;
  //     print(markerId);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _child != null ? _child : mapWidget());
  }
}
