import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../../common_widgets/constants.dart';
import 'ReportFormPolice.dart';
import '../../../AuthenticationHandle/StateNotifiers/FirestoreService.dart';

DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

class ActionRequired extends StatefulWidget {
  @override
  _ActionRequiredState createState() => _ActionRequiredState();
}

class _ActionRequiredState extends State<ActionRequired> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
      child: Column(
        children: <Widget>[
          Text(
            "Actions required",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: _databaseReference.child("/"),
              itemBuilder: (context, snapshot, animation, index) {
                int inc = 0;
                for (int i = 0; i < snapshot.value['multiObject'].length; i++) {
                  if (snapshot.value['multiObject'][i]['handled'] == "action")
                    ++inc;
                }
                if (inc != 0) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Center(
                          child: Stack(
                            children: <Widget>[
                              UserReports(uid: snapshot.key),
                            ],
                          ),
                        ),
                      );
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
                                    Text("Reporter: ${snapshot.value["name"]}"),
                                  ],
                                ),
                              )
                            ],
                          )),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UserReports extends StatefulWidget {
  final String uid;
  UserReports({@required this.uid});
  @override
  _UserReportsState createState() => _UserReportsState();
}

class _UserReportsState extends State<UserReports> {
  String _name;

  void getUserDetails() async {
    await FirestoreService.registeredUserDocument(widget.uid)
        .get()
        .then((value) {
      setState(() {
        _name = value.data['name'];
      });
    });
  }

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Color(backgroundColor),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.67,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(20.0)),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Reports from ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    _name == null
                        ? CircularProgressIndicator()
                        : Text(
                            _name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                  ],
                ),
              ),
              Expanded(
                  child: FirebaseAnimatedList(
                query: _databaseReference.child(widget.uid + "/multiObject"),
                itemBuilder: (context, snapshot, animation, index) {
                  if (snapshot.value["handled"] == "action") {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportFormPolice(
                                    widget.uid + "/multiObject/$index",
                                    widget.uid,false)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                        color: Colors.black26),
                                    child: IconButton(
                                      icon: Icon(Icons.check),
                                      color: Colors.white,
                                      onPressed: () async {
                                        await _databaseReference
                                            .child(widget.uid +
                                                "/multiObject/$index")
                                            .update({
                                          "handled": "pending"
                                        }).then((value) {
                                          debugPrint(
                                              "Updated handled reference!");
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Report made on: ${snapshot.value['infoObject'][0]["timeStamp"]}",
                                          maxLines: 2,
                                          softWrap: false,
                                          overflow: TextOverflow.visible,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
