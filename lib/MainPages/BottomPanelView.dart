import 'package:flutter/material.dart';
import 'package:sih_app/Forms/ReportForm.dart';
import 'package:sih_app/model/userObject.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:sih_app/MainPages/FireMap.dart';
import 'package:sih_app/MainPages/MainBodyStack.dart';
import '../model/infoObject.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//TODO: Make it ask for permissions properly
class BottomPanelView extends StatefulWidget {
  const BottomPanelView({
    Key key,
  }) : super(key: key);

  @override
  _BottomPanelViewState createState() => _BottomPanelViewState();
}

class _BottomPanelViewState extends State<BottomPanelView> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  String id = "1234";
  //Takes the app to report form
  navigateToReportForm(id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      //TODO: Add id
      return ReportForm(id);
    }));
  }

  Stream<UserObject> getUserObject(){
    return Firestore.instance
          .collection("normalUsers")
          .document(id)
          .get()
          .then((snapshot) {
            try{

              return UserObject.fromSnapshot(snapshot);
            }
            catch (e){
              print("exception here: $e");
              return null;
            }
          }).asStream();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          padding: EdgeInsets.all(10.0),
          child: StreamBuilder<UserObject>(
              stream: getUserObject(),
              builder: (BuildContext context,
                  AsyncSnapshot<UserObject> snapshot) {
                if (snapshot.hasError) return Text("Error: ${snapshot.error}");
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  default:
                    {
                      UserObject userObj = snapshot.data;
                      return Text("${userObj.multiMap}");}
                }
              })),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(top: 20.0),
//         child: FirebaseAnimatedList(
//             query: _databaseReference,
//             itemBuilder: (BuildContext context, DataSnapshot snapshot,
//                 Animation<double> animation, int index) {
//               return GestureDetector(
//                 onTap:(){
//                   navigateToReportForm("1234");
//                 },
//                 child: Card(
//                   color: Colors.grey,
//                   elevation: 2.0,
//                   child: Container(
//                       margin: EdgeInsets.all(10.0),
//                       child: Row(
//                         children: <Widget>[
//                           Container(
//                             width: 50.0,
//                             height: 50.0,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               // image: DecorationImage(
//                               //   fit: BoxFit.cover,
//                               //   image: snapshot.value['photoUrl'] == "empty"
//                               //       ? AssetImage("assets/logo.png")
//                               //       : NetworkImage(snapshot.value['photoUrl']),
//                             ),
//                           ),
//                           // ),
//                           Container(
//                             margin: EdgeInsets.all(20.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Text(
//                                     "${snapshot.key}")
//                               ],
//                             ),
//                           )
//                         ],
//                       )),
//                 ),
//               );
//             }));
//   }
// }
