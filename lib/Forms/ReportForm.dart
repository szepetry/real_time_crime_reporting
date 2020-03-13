import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:sih_app/Forms/AddReportForm.dart';
import 'package:sih_app/Forms/ReportForm.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:sih_app/MainPages/FireMap.dart';
import 'package:sih_app/MainPages/MainBodyStack.dart';
import '../model/infoObject.dart';
import 'dart:core';
import 'package:firebase_database/firebase_database.dart';

bool result = false;

class ReportForm extends StatefulWidget {
  final String id;
  ReportForm(this.id);

  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  bool loadState = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Material(
        type: MaterialType.transparency,
        child: Container(
          //Change the form color here.
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Align(
                      child: Container(
                          child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                "Report page",
                                style: TextStyle(fontSize: 40.0),
                              ))),
                      alignment: Alignment.topCenter),
                  Padding(padding: EdgeInsets.all(1.0)),
                  // Divider(),
                  Expanded(
                    child: Container(
                      child: FirebaseAnimatedList(
                          query: _databaseReference,
                          itemBuilder: (BuildContext context,
                              DataSnapshot snapshot,
                              Animation<double> animation,
                              int index1) {
                            // Map<dynamic,dynamic> tempMap = snapshot.value['infoObject'];
                            return Column(
                              children: <Widget>[
                                Card(
                                  // color: Colors.white30,
                                  elevation: 2.0,
                                  child: Container(
                                    // margin: EdgeInsets.all(10.0),
                                    child: Column(
                                      children: <Widget>[
                                        for (int index2 = 0;
                                            index2 <
                                                snapshot
                                                    .value['infoObject'].length;
                                            index2++)
                                          eachObject(snapshot, index2),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          }),
                    ),
                  )
                ],
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: FloatingActionButton.extended(
                        onPressed: () async {
                          result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return Center(
                                child: Stack(
                                  children: <Widget>[
                                    AddReportForm(result),
                                  ],
                                ),
                              );
                            }),
                          );
                        },
                        backgroundColor: Colors.deepOrange,
                        label: Text("Add to the report"),
                      ))),
            ],
          ),
        ),
      ),
    );
  }

  Column eachObject(DataSnapshot snapshot, int index2) {
    return Column(
      children: <Widget>[
        Text("Location: ${snapshot.value['infoObject'][index2]['location']}}"),
        Text(
            "Description: ${snapshot.value['infoObject'][index2]['description']}"),
        Text(
            "Image: ${snapshot.value['infoObject'][index2]['urlAttachmentPhoto']}"),
        Text(
            "Video: ${snapshot.value['infoObject'][index2]['urlAttachmentVideo']}"),
        Divider(),
      ],
    );
  }
}
