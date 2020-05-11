import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:instant_reporter/MainPages/FireMap.dart';
import 'package:instant_reporter/MainPages/MainBodyStack.dart';



//TODO: Make it ask for permissions properly
class BottomPanelView extends StatefulWidget {
  const BottomPanelView({
    Key key,
  }) : super(key: key);

  @override
  _BottomPanelViewState createState() => _BottomPanelViewState();
}

class _BottomPanelViewState extends State<BottomPanelView> {
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
            itemBuilder: (BuildContext context, int i) {
              return ListTile(
                trailing: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image:
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1200px-Cat03.jpg"),
                title: Text("List number $i"),
                // selected: true,
                subtitle: Text("Test fill"),
              );
            },
          ),
        ),
      ],
    );
  }
}