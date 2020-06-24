import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:instant_reporter/Forms/AddReportForm.dart';
import 'package:instant_reporter/Forms/ReportForm.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:instant_reporter/MainPages/FireMap.dart';
import 'package:instant_reporter/MainPages/MainBodyStack.dart';
import '../model/infoObject.dart';
import 'dart:core';
import 'package:instant_reporter/common_widgets/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../common_widgets/video_player_widget.dart';

bool result = false;

class ReportForm extends StatefulWidget {
  final String id;
  ReportForm(this.id);

  @override
  _ReportFormState createState() => _ReportFormState(id);
}

class _ReportFormState extends State<ReportForm> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  bool loadState = false;
  String id;
  _ReportFormState(this.id);
  VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          //Change the form color here.
          color: Color(backgroundColor),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                      child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Your Reports",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 40.0, color: Colors.white),
                        ),
                         CommonInfo(
                           heading: ' Name:',
                           data: ' Xyz',
                         ),
                         CommonInfo(
                           heading: ' Email:',
                           data: ' xyz@gmail.com',
                         ),
                            CommonInfo(
                           heading: ' Phone Number: ',
                           data: ' 1234567894',
                         ),
                          
                         
                          
                      ],
                    ),
                  )),
                  Padding(padding: EdgeInsets.all(1.0)),
                  // Divider(),
                  Expanded(
                    child: Container(
                      child: FirebaseAnimatedList(
                          query: _databaseReference.child(id + "/infoObject"),
                          itemBuilder: (BuildContext context,
                              DataSnapshot snapshot,
                              Animation<double> animation,
                              int index1) {
                            // Map<dynamic,dynamic> tempMap = snapshot.value['infoObject'];
                            return Column(
                              children: <Widget>[
                                Card(
                                  color: Color(cardColor),
                                  elevation: 2.0,
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    // margin: EdgeInsets.all(10.0),
                                    child: Column(
                                      children: <Widget>[
                                        eachObject(snapshot),
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
                        heroTag: "btn1",
                        onPressed: () async {
                          result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return Center(
                                child: Stack(
                                  children: <Widget>[
                                    AddReportForm(result, id),
                                  ],
                                ),
                              );
                            }),
                          );
                          print(
                              "Result from report Form: ${result.toString()}");
                        },
                        backgroundColor: Color(buttonColor),
                        label: Text("Add to the report",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        ),
                      ))),
            ],
          ),
        ),
      ),
    );
  }

  Column eachObject(DataSnapshot snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          ReportRows(
            colourOfTheBackground: colourHeading,
            styleOfText: kTextStyleOfHeadings,
            textString: 'Location:',
          ),
        ]),
        Row(
          children: <Widget>[
            ReportRows(
              colourOfTheBackground: colourbelow,
              styleOfText: kTextStyleForData,
              textString: snapshot.value['location'],
            ),
          ],
        ),
        Row(children: <Widget>[
          ReportRows(
            colourOfTheBackground: colourHeading,
            styleOfText: kTextStyleOfHeadings,
            textString: 'Description: ',
          ),
        ]),
        
        Row(
          children: [
            ReportRows(
              colourOfTheBackground: colourbelow,
              styleOfText: kTextStyleForData,
              textString: snapshot.value['description'],
            ),
          ],
        ),
 Row(children: <Widget>[
          ReportRows(
            colourOfTheBackground: colourHeading,
            styleOfText: kTextStyleOfHeadings,
            textString: 'Date and Time:',
          ),
          ReportRows(
            colourOfTheBackground: colourbelow,
            styleOfText: kTextStyleForData,
            textString: '10/04/19 10:20pm',
          ),
        ]),
        Row(
          children: <Widget>[
            Expanded(
              child: ReusableCard(
                colour: Color(colourHeading),
                cardChild: Text(
                  "Image:",
                  style: kTextStyleOfHeadings,
                ),
              ),
            ),
            Expanded(
              child: ReusableCard(
                colour: Color(colourHeading),
                cardChild: Text(
                  "Video:",
                  style: kTextStyleOfHeadings,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot.value['urlAttachmentPhoto'],
                
              ),
            ),
            Expanded(
              child: VideoPlayerWidget(
                url: snapshot.value['urlAttachmentVideo'],
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }

  void videoPlayer(String url) {
    _controller = VideoPlayerController.network(url);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }
}

