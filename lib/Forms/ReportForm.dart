import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:instant_reporter/Forms/AddReportForm.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:core';
import 'package:instant_reporter/common_widgets/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import '../common_widgets/video_player_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../AuthenticationHandle/StateNotifiers/FirestoreService.dart';

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
  String id;
  String _name;
  String _phoneNo;
  // _ReportFormState(this.id);
  
  @override
  void initState() {
    id = widget.id;
    getUserDetails();
    super.initState();
  }

  void getUserDetails() async {
    await FirestoreService.registeredUserDocument(id).get().then((value) {
      setState(() {
        _name = value.data['name'];
        _phoneNo = value.data['phoneNo'];
      });
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
                          data: _name != null?
                          _name:"Loading name.",
                        ),
                        CommonInfo(
                          heading: ' Phone Number: ',
                          data: _phoneNo != null?
                          _phoneNo:"Loading phone number.",
                        ),
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
                          showDialog(
                            context: context,
                            builder: (context) => Center(
                                child: Stack(
                              children: <Widget>[
                                AddReportForm(result, id, (value) {
                                  setState(() {
                                    result = value;
                                  });
                                  return result = value;
                                }),
                              ],
                            )),
                            
                          );
                          print(
                              "Result from report Form: ${result.toString()}");
                        },
                        backgroundColor: Color(buttonColor),
                        label: Text(
                          "Add to the report",
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