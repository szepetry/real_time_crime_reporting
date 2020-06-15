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
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://file-examples.com/wp-content/uploads/2017/04/file_example_MP4_480_1_5MG.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

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
                                "Your Reports",
                                style: TextStyle(fontSize: 40.0),
                              ))),
                      alignment: Alignment.topCenter),
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
                                  // color: Colors.white30,
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
                        backgroundColor: Colors.deepOrange,
                        label: Text("Add to the report"),
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
        Text(
          "Location:",
          style: kTextStyleOfHeadings,
        ),
        Text(
          snapshot.value['location'],
          style: kTextStyleForData,
        ),
        Text(
          "Description:",
          style: kTextStyleOfHeadings,
        ),
        Text(
          snapshot.value['description'],
          style: kTextStyleForData,
        ),
        Text(
          "Image:",
          style: kTextStyleOfHeadings,
        ),
        // Text(
        //   snapshot.value['urlAttachmentPhoto'],
        //   style: kTextStyleForUrl,
        // ),
        FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: snapshot.value['urlAttachmentPhoto'],
          height: 80.0,
          width: 80.0,
        ),
        // Image.network(
        //   snapshot.value['urlAttachmentPhoto'],
        //   height: 80.0,
        //   width: 80.0,
        // ),
        Text(
          "Video:",
          style: kTextStyleOfHeadings,
        ),
        // Scaffold(
        //   body: Center(
        //     child: _controller.value.initialized
        //         ? AspectRatio(
        //             aspectRatio: _controller.value.aspectRatio,
        //             child: VideoPlayer(_controller),
        //           )
        //         : Container(),
        //   ),
        //   floatingActionButton: FloatingActionButton(
        //     onPressed: () {
        //       setState(() {
        //         _controller.value.isPlaying
        //             ? _controller.pause()
        //             : _controller.play();
        //       });
        //     },
        //     child: Icon(
        //       _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        //     ),
        //   ),
        // ),
        // Text(
        //   snapshot.value['urlAttachmentVideo'],
        //   style: kTextStyleForUrl,
        // ),

        Divider(),
      ],
    );
  }
}
