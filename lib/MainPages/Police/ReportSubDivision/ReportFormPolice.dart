import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:core';
import 'package:instant_reporter/common_widgets/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../common_widgets/video_player_widget.dart';
import '../../../AuthenticationHandle/StateNotifiers/FirestoreService.dart';
import 'package:instant_reporter/AuthenticationHandle/LandingPage.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'NearbyPolice.dart';

bool result = false;

class ReportFormPolice extends StatefulWidget {
  final String id, uid;
  final bool isCompleted;
  ReportFormPolice(this.id, this.uid, this.isCompleted);

  @override
  _ReportFormPoliceState createState() => _ReportFormPoliceState();
}

class _ReportFormPoliceState extends State<ReportFormPolice> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  bool loadState = false;
  String id, uid;
  String _name;
  String _phoneNo;
  String firstLocation;
  // _ReportFormPoliceState(this.id);

  @override
  void initState() {
    id = widget.id;
    uid = widget.uid;
    getUserDetails();

    super.initState();
  }

  void getUserDetails() async {
    // UserDetails u =Provider.of<UserDetails>(context, listen: false);
    await FirestoreService.registeredUserDocument(uid).get().then((value) {
      setState(() {
        _name = value.data['name'];
        _phoneNo = value.data['phoneNo'];
      });
    }).then((value) async {
      if (id != null) {
        await _databaseReference
            .child("$id/infoObject")
            .once()
            .then((snapshot) {
          firstLocation = snapshot.value[0]['location'];
        }).then((value) => debugPrint("$firstLocation"));
      }
    });
  }

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
                          heading: ' Name: ',
                          data: _name != null ? _name : "Loading name.",
                        ),
                        Row(children: <Widget>[
                          CommonInfo(
                            heading: ' Phone Number: ',
                            data: _phoneNo != null
                                ? _phoneNo
                                : "Loading phone number.",
                          ),
                          SizedBox(
                            width: 70,
                          ),
                          GestureDetector(
                              onTap: () {
                                //  print('hello');
                                if (_phoneNo != null) {
                                  String phno = "tel:" + _phoneNo;
                                  launch(phno);
                                }
                              },
                              child: Icon(
                                Icons.call,
                                color: Colors.white,
                              )),
                          SizedBox(
                            width: 30,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_phoneNo != null) {
                                String sms = "sms:" + _phoneNo;
                                launch(sms);
                              }
                            },
                            child: Icon(
                              Icons.sms,
                              color: Colors.white,
                            ),
                          ),
                        ]),
                      ],
                    ),
                  )),
                  Padding(padding: EdgeInsets.all(1.0)),
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Card(
                                      color: Color(cardColor),
                                      elevation: 2.0,
                                      child: Container(
                                        padding: EdgeInsets.all(15),
                                        // margin: EdgeInsets.all(10.0),
                                        child: Column(
                                          children: <Widget>[
                                            eachObject(snapshot),
                                            // Text("${snapshot.value['timeStamp']}")
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          }),
                    ),
                  ),
                ],
              ),
              //TODO: Add action taken button here
              Positioned(
                bottom: 20,
                left: MediaQuery.of(context).size.width - 100,
                child: widget.isCompleted != true?
                RawMaterialButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => Center(
                        child: Stack(
                          children: <Widget>[
                            _name != null
                                ? NearbyPolice(
                                    userLocation: firstLocation,
                                    uid: uid,
                                    namOfTheReporter: _name,
                                  )
                                : CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    );
                    await _databaseReference
                        .child(id)
                        .update({"handled": "pending"}).then((value) {
                      debugPrint("Updated handled reference!");
                    });
                  },
                  child: Icon(
                    Icons.check,
                  ),
                  shape: CircleBorder(),
                  elevation: 4.0,
                  fillColor: Colors.red,
                  padding: EdgeInsets.all(15.0),
                ):
                Container()
              ),
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
        GestureDetector(
          onTap: () {
            String coordinate = snapshot.value["location"];
            List<String> coordinateList = coordinate.split(", ");
            debugPrint(
                "The location: ${double.parse(coordinateList[0].split(": ")[1])},${double.parse(coordinateList[1].split(": ")[1])}");

            print('hello');
            MapsLauncher.launchCoordinates(
                double.parse(coordinateList[0].split(": ")[1]),
                double.parse(coordinateList[1].split(": ")[1]));
          },
          child: Row(
            children: <Widget>[
              ReportRows(
                colourOfTheBackground: colourbelow,
                styleOfText: kTextStyleForData,
                textString: snapshot.value['location'],
              ),
            ],
          ),
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
            textString: snapshot.value['timeStamp'].toString(),
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
                flex: 1,
                child: snapshot.value['urlAttachmentPhoto'] != ""
                    ? FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: snapshot.value['urlAttachmentPhoto'],
                        // width: MediaQuery.of(context).size.width*0.5,
                        // height: MediaQuery.of(context).size.height*0.5,
                      )
                    : SizedBox(
                        height: 170,
                        child: Container(
                          color: Colors.black26,
                          child: Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.white,
                              size: 100.0,
                            ),
                          ),
                        ),
                      )),
            Expanded(
              flex: 1,
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
}
