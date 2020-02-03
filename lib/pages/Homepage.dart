import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:transparent_image/transparent_image.dart';
// import 'package:flutter/services.dart';

Completer<GoogleMapController> _controller = Completer();

Marker marker;

Position _currentPosition;
// var geolocator = Geolocator();

// var locationOptions =
//     LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: _FloatingActionButtonWidget(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SlidingUpPanel(
            maxHeight: 600,
            minHeight: 100,
            isDraggable: true,
            backdropEnabled: true,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0)),
            panel: _BottomPanelView(),
            body: _MainBodyStack()));
  }
}

//TODO:Main body of the application
class _MainBodyStack extends StatefulWidget {
  @override
  __MainBodyStackState createState() => __MainBodyStackState();
}

class __MainBodyStackState extends State<_MainBodyStack> {

  void initState(){
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FireMap(),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            tooltip: "Profile",
            icon: Icon(Icons.person),
            onPressed: () {},
          ),
        ),
        Positioned(
          bottom: 150,
          left: MediaQuery.of(context).size.width - 80,
          child: RawMaterialButton(
            onPressed: () {
              _getCurrentLocation();
            },
            child: Icon(
              Icons.gps_fixed,
            ),
            shape: CircleBorder(),
            elevation: 4.0,
            fillColor: Colors.red,
            padding: EdgeInsets.all(15.0),
          ),
        ),
        _currentPosition != null
            ? Text(
                "LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}")
            : CircularProgressIndicator(),
      ],
    );
  }
}

class _FloatingActionButtonWidget extends StatelessWidget {
  const _FloatingActionButtonWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.red,
      onPressed: () {},
      child: Icon(Icons.offline_bolt),
    );
  }
}

//TODO: Make it ask for permissions properly
class _BottomPanelView extends StatefulWidget {
  const _BottomPanelView({
    Key key,
  }) : super(key: key);

  @override
  __BottomPanelViewState createState() => __BottomPanelViewState();
}

class __BottomPanelViewState extends State<_BottomPanelView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(5.0),
        ),
        Divider(
          thickness: 4.0,
          indent: 150,
          endIndent: 150,
        ),
        Padding(
          padding: EdgeInsets.all(5.0),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 5,
            padding: EdgeInsets.all(20.0),
            itemBuilder: (BuildContext context, int i){
              return Card(
                child: ListTile(
                  trailing: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1200px-Cat03.jpg"),
                  title: Text("List number $i"),
                  // selected: true,
                  subtitle: Text("Test fill"),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

//TODO: Make bottom panel

//TODO: Integrate maps
class FireMap extends StatefulWidget {
  @override
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {

  CameraPosition _userLocation = CameraPosition(
    // Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
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
  // _addMarker(){
  //   var Marker = Marker(
  //     position: mapController.cameraPosition.target,

  //   );
  // }

  // Future <GoogleMapController> googleOnMapCreated

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _userLocation,

        onMapCreated: (GoogleMapController controller1) async{
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

// Marker someMarker = Marker(
//     markerId: MarkerId('someMarker1'),
//     position: LatLng(12.8908356, 77.6414201),
//     infoWindow: InfoWindow(title: "SOme place"),
//     icon: BitmapDescriptor.defaultMarkerWithHue(
//       BitmapDescriptor.hueCyan,
//     ));
