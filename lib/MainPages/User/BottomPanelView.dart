import 'package:flutter/material.dart';
import 'package:instant_reporter/Forms/ReportForm.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class BottomPanelView extends StatefulWidget {
  final String uid;
  BottomPanelView(this.uid);

  @override
  _BottomPanelViewState createState() => _BottomPanelViewState();
}

class _BottomPanelViewState extends State<BottomPanelView> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  String uid;
  bool firstClick;
  //Takes the app to report form
  navigateToReportForm(id, id2) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ReportForm(id, id2);
    }));
  }

  @override
  void initState() {
    uid = widget.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 75.0),
        margin: EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0),
        child: FirebaseAnimatedList(
            query: _databaseReference.child(uid + "/multiObject"),
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              if (snapshot.value != null)
                return GestureDetector(
                  onTap: () {
                    navigateToReportForm(uid, uid + "/multiObject/$index");
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
                              ),
                              child: Icon(Icons.report),
                            ),
                            Container(
                              margin: EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      "Report made on: ${snapshot.value['infoObject'][0]['timeStamp']}"),
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
  }
}
