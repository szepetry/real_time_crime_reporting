import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:instant_reporter/ZoneHandle/DisplayZones/ZoneRender.dart';
import 'package:instant_reporter/ZoneHandle/ZoneNotify.dart';
import 'package:instant_reporter/common_widgets/constants.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';


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
  ZoneRender renderZone;
  FireMap(this.renderZone);

  static Widget create(BuildContext context) {
    return Provider<ZoneRender>(
      create: (context) => ZoneRender(context),
      child: Consumer<ZoneRender>(
          builder: (context, renderZone, _) => FireMap(renderZone)),
    );
  }

  @override
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> with SingleTickerProviderStateMixin {
  ZoneRender get renderZone => widget.renderZone;
  GoogleMapController mapController;
  bool displayZone = false;
  AnimationController rotationController;
  // Position position;
  Widget _child;
  BitmapDescriptor myIcon;
  Set<Polygon> test = Set<Polygon>();
  @override
  void initState() {
    rootBundle.loadString('assets/MapStyles/nightMapLandmarks.json').then((json) {
      _mapStyleNight = json;
    }).then((value) {
      moveCamera();
      BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(64, 64)),
              'assets/images/policestation.png')
          .then((onValue) {
        myIcon = onValue;
      });
      moveCamera();

      getCurrentLocation();
    });
    super.initState();
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
        upperBound: 22 * 6 / 7);
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

    initMarker(placemark[0], j.toString(), name);

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

  void trial(ZoneRender renderZone) {}

  Widget mapWidget() {
    //Set<Polygon> test = Set<Polygon>();
    //ZoneRender renderZone = Provider.of<ZoneRender>(context, listen: false);
    /*   renderZone.polygonsDB.forEach((element) {
      test.add(element);
    }); */
    print(widget.renderZone.polygonsDB);
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
      polygons: widget.renderZone.polygonsDB.isNotEmpty
          ? displayZone ? Set.from(widget.renderZone.polygonsDB) : null
          : null,
      initialCameraPosition:
          CameraPosition(target: LatLng(13.018302, 77.508173), zoom: 18.0),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);

        mapController = controller;
        mapController.setMapStyle(_mapStyleNight);
      },
    );
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void initMarker(request, requestId, name) {
    var markerIdVal = requestId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(request.position.latitude, request.position.longitude),
        infoWindow: InfoWindow(
            title: "$name, ${request.subLocality}",
            snippet: "(${request.position})"),
        draggable: false,
        icon: myIcon);

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
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }

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
            !displayZone ? 'Display\n Zones' : '  Hide\nZones',
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
            padding: EdgeInsets.only(right: 30),
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
    return Scaffold(
        body: Stack(children: <Widget>[
      _child != null
          ? _child
          : Center(
              child: CircularProgressIndicator(),
            ),
      zoneToggleButton(),
      refreshButton()
    ]));
  }
}
