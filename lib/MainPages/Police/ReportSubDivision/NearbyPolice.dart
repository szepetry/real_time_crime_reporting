import 'dart:async';

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:instant_reporter/common_widgets/constants.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'ReportFormPolice.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class NearbyPolice extends StatefulWidget {
  final String userLocation, uid;
  NearbyPolice({@required this.userLocation, this.uid});
  @override
  _NearbyPoliceState createState() =>
      _NearbyPoliceState(userLocation: userLocation);
}

class _NearbyPoliceState extends State<NearbyPolice> {
  Map<String, dynamic> nameAndDistance = Map<String, dynamic>();
  List<dynamic> latitudes = List<dynamic>();
  List<dynamic> longitudes = List<dynamic>();
  List<dynamic> namesOfthePolice = List<dynamic>();
  List<dynamic> distance = List<dynamic>();
  LinkedHashMap sortedMap;

  final String userLocation;
  String uid;
  var dist;
  _NearbyPoliceState({this.userLocation});
  StreamSubscription _streamSubscription; //n
  Stream _stream = Firestore.instance.collection("registeredUsers").snapshots();
  //n

  @override
  void initState() {
    print(userLocation);
    _streamSubscription = _stream.listen((event) {
      debugPrint("$event happened?");
    });
    _streamSubscription.onData((data) async {
      for (int i = 0; i < data.documents.length; i++) {
        if (data.documents[i].documentID != widget.uid) {
          if (data.documents[i].data['occupation'] == "Police") {
            print(data.documents[i].data['location'].latitude.toString() +
                ' fffffffff');
            //  var lat = ;
            //  latitudes.add(data.documents[i].data['location'].latitude);
            //  print(data.documents[i].data['name']);
            print(data.documents[i].data['location'].longitude.toString());
            // var long = ;
            //longitudes.add(data.documents[i].data['location'].longitude);
            //   debugPrint('This one: lat: ${latitudes[i].toString()} , long: ${longitudes[i].toString()}');

            //  namesOfthePolice.add(data.documents[i].data['name']);
            String coordinate = userLocation;
            List<String> coordinateList = coordinate.split(", ");
            await Geolocator()
                .distanceBetween(
                    double.parse(coordinateList[0].split(": ")[1]),
                    double.parse(coordinateList[1].split(": ")[1]),
                    data.documents[i].data['location'].latitude,
                    data.documents[i].data['location'].longitude)
                .then((dist) {
              nameAndDistance[data.documents[i].data['name']] = dist;
            });
          }
        }
      }
      print(nameAndDistance);
      var sortedKeys = nameAndDistance.keys.toList(growable: false)
        ..sort((k1, k2) => nameAndDistance[k1].compareTo(nameAndDistance[k2]));
      setState(() {
        sortedMap = LinkedHashMap.fromIterable(sortedKeys,
            key: (k) => k, value: (k) => nameAndDistance[k]);
      });

      print(sortedMap);
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Color(backgroundColor),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.67,
        width: MediaQuery.of(context).size.width * 0.8,
        child: sortedMap != null
            ? Center(
                child: Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(20.0)),
                    Text(
                      "Police Nearby",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    // color: Color(backgroundColor),
                                    decoration:
                                        BoxDecoration(color: Color(cardColor)),
                                    child: ListTile(
                                      leading: Icon(Icons.person),
                                      contentPadding: EdgeInsets.all(8.0),
                                      onTap: (){
                                        debugPrint("Allo");
                                      },
                                      title: Text(
                                        sortedMap.keys.toList()[index],
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      subtitle: Text(
                                        sortedMap.values
                                            .toList()[index]
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                    ),
                                  ),
                                ),
                              )
                              );
                        },
                        itemCount: sortedMap.length,
                      ),
                    ),

                    // Expanded(
                    //     child: FirebaseAnimatedList(
                    //   query: _databaseReference.child(widget.userLoction + "/multiObject"),
                    //   itemBuilder: (context, snapshot, animation, index) {
                    //     if (snapshot.value["handled"] == "action") {
                    //       return GestureDetector(
                    //         onTap: () {
                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => ReportFormPolice(
                    //                       widget.userLoction + "/multiObject/$index",
                    //                       widget.userLoction)));
                    //         },
                    //         child: Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Card(
                    //             color: Colors.grey,
                    //             elevation: 2.0,
                    //             child: Container(
                    //                 margin: EdgeInsets.all(10.0),
                    //                 child: Row(
                    //                   children: <Widget>[
                    //                     Container(
                    //                       width: 50.0,
                    //                       height: 50.0,
                    //                       decoration: BoxDecoration(
                    //                           shape: BoxShape.circle,
                    //                           color: Colors.black26),
                    //                       child: IconButton(
                    //                         icon: Icon(Icons.check),
                    //                         color: Colors.white,
                    //                         onPressed: () async {
                    //                           await _databaseReference
                    //                               .child(widget.userLoction +
                    //                                   "/multiObject/$index")
                    //                               .update({
                    //                             "handled": "pending"
                    //                           }).then((value) {
                    //                             debugPrint(
                    //                                 "Updated handled reference!");
                    //                           });
                    //                         },
                    //                       ),
                    //                     ),
                    //                     Container(
                    //                       margin: EdgeInsets.all(20.0),
                    //                       child: Column(
                    //                         crossAxisAlignment:
                    //                             CrossAxisAlignment.start,
                    //                         children: <Widget>[
                    //                           Text(
                    //                               "Report made on: ${snapshot.value['infoObject'][0]["timeStamp"]}"),
                    //                         ],
                    //                       ),
                    //                     )
                    //                   ],
                    //                 )),
                    //           ),
                    //         ),
                    //       );
                    //     } else {
                    //       return Container();
                    //     }
                    //   },
                    // ))
                  ],
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
