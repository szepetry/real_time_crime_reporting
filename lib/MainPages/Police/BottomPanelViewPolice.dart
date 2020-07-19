import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../common_widgets/constants.dart';
import 'ReportSubDivision/ActionRequired.dart';
import 'ReportSubDivision/Completed.dart';
import 'ReportSubDivision/Pending.dart';

class BottomPanelViewPolice extends StatefulWidget {
  @override
  _BottomPanelViewPoliceState createState() => _BottomPanelViewPoliceState();
}

DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

int currentIndex = 0;

class _BottomPanelViewPoliceState extends State<BottomPanelViewPolice> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 90),
      child: Column(
        children: <Widget>[
          Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: MaterialButtonWidget(
                      onPressed: () {
                        setState(() {
                          currentIndex = 0;
                        });
                      },
                      color: Colors.red,
                      text: "Action required",
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: MaterialButtonWidget(
                      onPressed: () {
                        setState(() {
                          currentIndex = 1;
                        });
                      },
                      color: Colors.red,
                      text: "Pending",
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: MaterialButtonWidget(
                      onPressed: () {
                        setState(() {
                          currentIndex = 2;
                        });
                      },
                      color: Colors.red,
                      text: "Completed",
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
                      child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                  child: (currentIndex == 0)
                      ? ActionRequired()
                      : (currentIndex == 1)
                          ? Pending()
                          : (currentIndex == 2) ? Completed() : Container()),
            ),
          )
        ],
      ),
    );
  }
}
