import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:instant_reporter/AuthenticationHandle/LandingPage.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:async";
import 'package:flutter/services.dart' show rootBundle;
import 'package:instant_reporter/common_widgets/constants.dart';

Completer<GoogleMapController> _controller = Completer();
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

class FireMapPolice extends StatefulWidget {
  FireMapPolice(); //use this uid here
  @override
  _FireMapPoliceState createState() => _FireMapPoliceState();
}

// UserDetails user = Provider.of<UserDetails>(context, listen: false);
StreamSubscription _streamSubscription = Firestore.instance
    .collection("registeredUsers")
    .snapshots()
    .listen((querySnapshot) {
  querySnapshot.documentChanges.forEach((element) {});
});
// StreamSubscription subscription;

class _FireMapPoliceState extends State<FireMapPolice> {
  String uid;
  GoogleMapController mapController;
  Position position;
  Widget _child;

  @override
  void initState() {
        rootBundle.loadString('assets/MapStyles/nightMap.json').then((json) {
      _mapStyleNight = json;
    });
    getCurrentLocation(); //current location of the police official
    print("hello " + position.toString());
    Future.delayed(Duration(seconds: 3)).then((value) {
      updateData(); //updates location in the database
    });
    Future.delayed(Duration(seconds: 3)).then((value) {
      populateOfficials(); // accesses the database
    });

    super.initState();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    /*  Navigator.push(
        context, MaterialPageRoute(builder: (context) => EmailSignInPage())); */
    //just uncomment the above if u wnt signout to work
    //copy same code in user.dart if u want signout there
    //need to make more changes for sign out..uid u can use for now
    //il delete useless files later
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
    Position res = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        locationPermissionLevel: GeolocationPermission.locationAlways);
    setState(() {
      position = res;
    });

    var _lat = position.latitude;
    var _lng = position.longitude;
    getAddress(_lat, _lng);
  }

  @override
  Widget build(BuildContext context) {
    UserDetails u = Provider.of<UserDetails>(context, listen: false);
    uid = u.uid;
    return Scaffold(body: _child);
    // return Container(
    //   child: Center(
    //     child: FlatButton(onPressed: signOut, child: Text('\tPolice\Touch to Log Out'),color: Colors.indigo[200],),
    //   ),
    // );
  }

  Widget mapWidget() {
    var googleMap = GoogleMap(
      mapType: MapType.normal,
      markers: Set<Marker>.of(markers.values),
      initialCameraPosition: CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 12.0),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);        
        mapController = controller;
        mapController.setMapStyle(_mapStyleNight);
      },
    );
    return googleMap;
  }

  populateOfficials() {
    Firestore.instance
        .collection('registeredUsers')
        .getDocuments()
        .then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
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
      infoWindow: InfoWindow(title: request['name']),
      draggable: false,
    );

    setState(() {
      markers[markerId] = marker;
      print(markerId);
    });
  }

  updateData() async {
    UserDetails u = Provider.of<UserDetails>(context, listen: false);
    print("location in updateData: $position");
    await Firestore.instance
        .collection('registeredUsers')
        .document(u.uid)
        .updateData({
      "location": GeoPoint(position.latitude, position.longitude),
    });
  }
}
