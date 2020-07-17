import 'package:flutter/material.dart';
import 'package:instant_reporter/AuthenticationHandle/LandingPage.dart';
import 'package:instant_reporter/MainPages/Drawers.dart';
import 'package:instant_reporter/common_widgets/background_services.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'BottomPanelViewPolice.dart';
import 'MainBodyStackPolice.dart';
import '../../common_widgets/constants.dart';

class HomepagePolice extends StatefulWidget {
  HomepagePolice();
  @override
  _HomepagePoliceState createState() => _HomepagePoliceState();
}
class _HomepagePoliceState extends State<HomepagePolice> {
  String uid;
  String temp;
  @override
  void initState() {
    super.initState();
    //  getSharedPrefs();
  }

  /* Future<void> getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  } */
  // @override
  // void dispose() {
  //   subscription.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    UserDetails u = Provider.of<UserDetails>(context, listen: false);
    //inherited widget using provider to access uid to all child widgets
    uid = u.uid;
    return Scaffold(
      endDrawer: Drawers(true, u),
      body: SlidingUpPanel(
        color: Color(backgroundColor),
        maxHeight: 600,
        minHeight: 100,
        isDraggable: true,
        backdropEnabled: true,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
        panel: BottomPanelViewPolice(),
        body: MainBodyStackPolice(uid),
        controller: panelController,

        collapsed: Container(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 65.0),
            child: Divider(
              color: Colors.white,
              thickness: 5.0,
              endIndent: MediaQuery.of(context).size.width * 0.3,
              indent: MediaQuery.of(context).size.width * 0.3,
            ),
          ),
        ),
        header: Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05, top: 30),
          child: Row(
            children: <Widget>[
              Container(
                  child: Text(
                "Reports",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ))
            ],
          ),
        ),
      ),
    );
  }
}