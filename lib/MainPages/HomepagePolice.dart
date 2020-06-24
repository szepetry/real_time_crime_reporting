import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instant_reporter/AuthenticationHandle/LandingPage.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:async";

class HomepagePolice extends StatefulWidget {
  HomepagePolice(); //use this uid here
  @override
  _HomepagePoliceState createState() => _HomepagePoliceState();
}

class _HomepagePoliceState extends State<HomepagePolice> {
  String uid;
  GoogleMapController mapController;
  Position position;
  Widget _child;

  @override
  void initState() {
    getCurrentLocation(); //current location of the police official
    populateOfficials();  // accesses the database 
    print("hello "+position.toString());
    Future.delayed(Duration(seconds: 5)).then((value) {
    updateData(); //updates location in the database 
    
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
    Position res =  await Geolocator().getCurrentPosition(
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
    return Container(
      child: Center(
        child: FlatButton(onPressed: signOut, child: Text('\tPolice\Touch to Log Out'),color: Colors.indigo[200],),
      ),
    );
  }
    Widget mapWidget() {
    var googleMap = GoogleMap(
      mapType: MapType.normal,
      markers: Set<Marker>.of(markers.values),
      initialCameraPosition: CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 12.0),
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
      },
    );
    return googleMap;
  }
  populateOfficials() {
    Firestore.instance
        .collection('police data')
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
    var markerIdVal=requestId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker=Marker(
      markerId: markerId,
      position:
          LatLng(request['location'].latitude, request['location'].longitude),
      infoWindow: InfoWindow(title: request['name'],snippet: markerIdVal),
      draggable: false,);
    
    setState(() {
      markers[markerId] = marker;
      print(markerId);
    
    });

  }
  

  updateData() async {  
    print("location in updateData: $position");
    await Firestore.instance
        .collection('registeredUsers')
        .document(u.)
        .updateData({
      "location": GeoPoint(position.latitude, position.longitude),
    });

  }
}
