import 'package:flutter/material.dart';
import 'package:instant_reporter/Forms/ReportForm.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:instant_reporter/MainPages/FireMap.dart';
import 'package:instant_reporter/MainPages/MainBodyStack.dart';
import '../model/infoObject.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'dart:async';
import 'package:flutter/services.dart';

//TODO: Make it ask for permissions properly
class BottomPanelView extends StatefulWidget {
  final String uid;
  BottomPanelView(this.uid);

  @override
  _BottomPanelViewState createState() => _BottomPanelViewState();
}

class _BottomPanelViewState extends State<BottomPanelView> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  static const platform = const EventChannel("com.renegades.miniproject/voldown");

  //Takes the app to report form
  navigateToReportForm(id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ReportForm(id);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
            margin: EdgeInsets.only(top: 20.0),
            child: FirebaseAnimatedList(
                query: _databaseReference,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  if (snapshot.key == widget.uid) //TODO: Janky way still
                    return GestureDetector(
                      onTap: () {
                        navigateToReportForm(widget.uid);
                      },
                      child: Card(
                        color: Colors.grey,
                        elevation: 2.0,
                        child: Container(
                            margin: EdgeInsets.all(10.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    // image: DecorationImage(
                                    //   fit: BoxFit.cover,
                                    //   image: snapshot.value['photoUrl'] == "empty"
                                    //       ? AssetImage("assets/logo.png")
                                    //       : NetworkImage(snapshot.value['photoUrl']),
                                  ),
                                ),
                                // ),
                                Container(
                                  margin: EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("${snapshot.key}"),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      ),
                    );
                  else
                    return Container();
                }));
        // SizedBox(
        //   height: 50,
        //   width: 50,
        // ),
        // StreamBuilder(
        //   stream: platform.receiveBroadcastStream(),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       return Text("Vol: ${snapshot.data}");
        //     }
        //     return Text("No data");
        //   },
        // )
    
  }
}
