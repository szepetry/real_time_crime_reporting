//import 'dart:html';


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
// StreamSubscription subscription;

class _FireMapPoliceState extends State<FireMapPolice> {
  String uid;
  GoogleMapController mapController;
  Widget _child;
  StreamSubscription _streamSubscription;
  Stream _stream = Firestore.instance.collection("registeredUsers").snapshots();
  double lat, lng;
  BitmapDescriptor myIcon;

  @override
  void initState() {
      rootBundle.loadString('assets/MapStyles/nightMap.json').then((json) {
      _mapStyleNight = json;
    }).then((value) {

    UserDetails u = Provider.of<UserDetails>(context, listen: false);
    uid = u.uid;
      moveCamera();
      BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(128,128)),'assets/images/police.png')
    .then((onValue){
      myIcon=onValue;
    });

    getCurrentLocation(); //current location of the police official
        _streamSubscription = _stream.listen((event) {
      debugPrint("$event happened?");});
    //print("hello " + position.toString());

    _streamSubscription.onData((data) {

      for (int i = 0; i < data.documents.length; i++) {
        if(data.documents[i].documentID!=uid){
        debugPrint(
            "${data.documents[i].data['location'].latitude}, ${data.documents[i].data['location'].longitude}");
        debugPrint("${data.documents[i].data['name']}");
        allMarkers.add(new Marker(
          markerId: MarkerId('${i.toString()}'),
          position: new LatLng(data.documents[i].data['location'].latitude,
              data.documents[i].data['location'].longitude),
          infoWindow: InfoWindow(
              title: data.documents[i].data['name'],
              snippet:
                  "${data.documents[i].data['location'].latitude}, ${data.documents[i].data['location'].longitude}"),
              icon: myIcon
        ));}
      }
      setState(() {
        _child = mapWidget();
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
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    /*  Navigator.push(
        context, MaterialPageRoute(builder: (context) => EmailSignInPage())); */
    //just uncomment the above if u wnt signout to work
    //copy same code in user.dart if u want signout there
    //need to make more changes for sign out..uid u can use for now
    //il delete useless files later
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
          if(docs.documents[i].documentID!=uid){
            debugPrint("id$i   ${docs.documents[i].documentID}!=$uid");
            initMarker(docs.documents[i].data, docs.documents[i].documentID);}
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
    // return Container(
    //   child: Center(
    //     child: FlatButton(onPressed: signOut, child: Text('\tPolice\Touch to Log Out'),color: Colors.indigo[200],),
    //   ),
    // );
  }

   Widget mapWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      //markers: Set<Marker>.of(markers.values),
      markers: Set<Marker>.of(allMarkers),
      initialCameraPosition:
          CameraPosition(target: LatLng(12.9932732,77.593868), zoom: 17.0),
          myLocationButtonEnabled: false,
          myLocationEnabled: true,          
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
              icon: myIcon
    );

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
/*       StreamBuilder(
      stream: Firestore.instance.collection('registeredUsers').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          for (var i = 0; i < snapshot.data.documents.length; i++) {
            initMarker(
                snapshot.data.documents[i]);
        //  you have to add return here 
          }
        }
      },
    ); */

/* StreamBuilder(
        stream: Firestore.instance.collection('registeredUsers').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green)));
          } else {
            return ListView.builder(
              itemBuilder: (_, var i){
                  return Card(
                    child: ListTile(
                      title: Text(snapshot.data.documents[i].data[ ]),
                    ),
                  );
              });
          }
        }); */

/* for (var i = 0; i < snapshot.data.documents.length; i++) {
              initMarker(snapshot.data.documents[i]);
            } */