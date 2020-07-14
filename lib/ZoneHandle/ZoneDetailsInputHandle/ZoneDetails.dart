import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instant_reporter/ZoneHandle/DisplayZones/ZoneTapOptions.dart';
import 'package:instant_reporter/ZoneHandle/ZoneDetailsInputHandle/ZoneDetailsNotifier.dart';
import 'package:instant_reporter/ZoneHandle/ZoneInfo.dart';
import 'package:instant_reporter/ZoneHandle/ZoneUploadHandle/ZoneMaps.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ZoneDetails extends StatefulWidget {
  ZoneInfo zoneInfo;
  ZoneDetailsNotifier zoneDetails;
  bool submitPressed;
  ZoneDetails(this.zoneInfo, this.zoneDetails);

  @override
  _ZoneDetailsState createState() => _ZoneDetailsState();
}

class _ZoneDetailsState extends State<ZoneDetails> {
  ZoneInfo get zoneInfo => widget.zoneInfo;
  ZoneDetailsNotifier get zoneDetails => widget.zoneDetails;
  TextEditingController get zoneTextController =>
      zoneDetails.zoneTextController;
  bool get isPortrait =>
      MediaQuery.of(context).orientation == Orientation.portrait;
  @override
  void dispose() {
    zoneTextController.dispose();
    super.dispose();
  }

  EdgeInsetsGeometry setMarginZoneDetailsCard(BuildContext context) {
    return isPortrait
        ? EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.25,
            left: MediaQuery.of(context).size.width * 0.12,
            right: MediaQuery.of(context).size.width * 0.12,
            bottom: MediaQuery.of(context).size.height * 0.42)
        : EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.2,
            left: MediaQuery.of(context).size.width * 0.3,
            right: MediaQuery.of(context).size.width * 0.3,
            bottom: MediaQuery.of(context).size.height * 0.15);
  }

  @override
  Widget build(BuildContext context) {
    //   bool isKeyboardHidden = MediaQuery.of(context).viewInsets.bottom==0;
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Card(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0)),
        margin: setMarginZoneDetailsCard(context),
        child: Padding(
          padding:
              EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0, bottom: 5.0),
          child: ListView(
            /*   mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, */
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Text(
                'Enter Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: buildDropdown(),
              ),
              SizedBox(
                height: 8.0,
              ),
              enterDetailsTextWidget(),
              SizedBox(
                height: 11.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: buildButtons(),
              ),
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget enterDetailsTextWidget() {
    return Column(children: <Widget>[
      Text('Enter Zone Notification Details'),
      SizedBox(
        height: 8.0,
      ),
      TextField(
        controller: zoneTextController,
        decoration: InputDecoration(
            labelText: '  Notification Text',
            errorText: null,
            hintText: 'Max 50 characters'),
        onChanged: (value) {
          zoneDetails.setZoneDetails = zoneTextController.text;
          print(zoneDetails.zoneDetailsInput);
        },
      ),
    ]);
  }

  List<Widget> buildButtons() {
    return [
      SizedBox(
        height: isPortrait
            ? MediaQuery.of(context).size.height * 0.055
            : MediaQuery.of(context).size.height * 0.1,
        width: isPortrait
            ? MediaQuery.of(context).size.width * 0.35
            : MediaQuery.of(context).size.width * 0.18,
        child: FlatButton(
          child: Text(
            'Submit Details',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
          onPressed: zoneDetails.isFieldEmpty
              ? () {
                  zoneInfo.setZoneColor = zoneDetails.getZoneColor;
                  zoneInfo.setZoneDetails = zoneDetails.getZoneDetailsInput;
                  currentState = state.other;
                  widget.submitPressed = true;
                  Navigator.of(context).pop();
                }
              : null,
          color: Colors.blue[400],
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
          disabledColor: Colors.grey[400],
          disabledTextColor: Colors.white,
        ),
      ),
      SizedBox(
        width: 6.0,
      ),
      SizedBox(
        height: isPortrait
            ? MediaQuery.of(context).size.height * 0.055
            : MediaQuery.of(context).size.height * 0.1,
        width: isPortrait
            ? MediaQuery.of(context).size.width * 0.35
            : MediaQuery.of(context).size.width * 0.18,
        child: FlatButton(
          child: Text(
            'Cancel',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            currentState = state.other;
            zoneInfo.cancel = true;
            widget.submitPressed = false;
            Navigator.of(context).pop();
          },
          color: Colors.blue[400],
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
          disabledColor: Colors.grey[400],
          disabledTextColor: Colors.white,
        ),
      ),
    ];
  }

  List<Widget> buildDropdown() {
    return [
      Text('Enter Zone Color '),
      DropdownButton<String>(
        value: zoneDetails.zoneColor,
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String newValue) {
          zoneDetails.setZoneColor = newValue;
        },
        items: <String>['Red', 'Orange', 'Green']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      )
    ];
  }
}
