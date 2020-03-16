import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sih_app/Database/user_obj_notifier.dart';
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
import '../model/userObject.dart';
import '../model/multiInfoObject.dart';
import '../Database/user_obj_notifier.dart';


//TODO: Make it ask for permissions properly
class BottomPanelView extends StatefulWidget {
  @override
  _BottomPanelViewState createState() => _BottomPanelViewState();
}

class _BottomPanelViewState extends State<BottomPanelView> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  String id = "1234";


  @override
  void initState() {
    UserObjNotifier userObjNotifier = Provider.of<UserObjNotifier>(context);
    super.initState();
  }

  //Takes the app to report form
  navigateToReportForm(id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      //TODO: Add id
      return ReportForm(id);
    }));
  }

  // Stream<UserObject> getUserObject(){
  //   return Firestore.instance
  //         .collection("normalUsers")
  //         .document(id)
  //         .get()
  //         .then((snapshot) {
  //           try{
  //             return UserObject.fromMap(snapshot.data);
  //           }
  //           catch (e){
  //             print("exception here: $e");
  //             return null;
  //           }
  //         }).asStream();
  // }

  getUserObject(UserObjNotifier userObjNotifier) async{
    QuerySnapshot snapshot = await Firestore.instance.collection('normalUsers/$id').getDocuments();

    List<MultiInfoObject> _multiInfoList = [];

    snapshot.documents.forEach((document) {
      MultiInfoObject multiInfoObject = MultiInfoObject.fromMap(document.data);
      _multiInfoList.add(multiInfoObject);
    });
    userObjNotifier.multiInfoList = _multiInfoList;
  }

  @override
  Widget build(BuildContext context) {
    UserObjNotifier userObjNotifier = Provider.of<UserObjNotifier>(context);
    return Center(
      child: ListView.separated(itemBuilder: (BuildContext context,int index){
        return ListTile(
          title: Text("${userObjNotifier.multiInfoList}"),
        );
      }, separatorBuilder: (BuildContext context,int index){
        return Divider(
          color: Colors.black,
        );
      }, itemCount: userObjNotifier.multiInfoList.length)
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
