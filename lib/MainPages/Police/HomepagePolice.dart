import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:instant_reporter/AuthenticationHandle/LandingPage.dart';
import 'package:instant_reporter/MainPages/Drawers.dart';
import 'package:instant_reporter/ZoneHandle/ZoneNotificationManager.dart';
import 'package:instant_reporter/ZoneHandle/ZoneNotify.dart';
import 'package:instant_reporter/common_widgets/background_services.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'BottomPanelViewPolice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:workmanager/workmanager.dart';
//import 'package:instant_reporter/pages/FireMap.dart';
import '../../Forms/LocationReport.dart';
import 'package:instant_reporter/MainPages/User/MainBodyStack.dart';
import 'package:instant_reporter/MainPages/User/BottomPanelView.dart';
import 'package:instant_reporter/common_widgets/notifications.dart';
import 'MainBodyStackPolice.dart';
import '../../common_widgets/constants.dart';

PanelController _panelController = PanelController();

class HomepagePolice extends StatefulWidget {
  HomepagePolice();
  @override
  _HomepagePoliceState createState() => _HomepagePoliceState();
}

// String actionTaken(dynamic data) {
//   // print("Data: $data");
//   return data;
// }

// Stream _stream = platform.receiveBroadcastStream();
// StreamSubscription subscription;

class _HomepagePoliceState extends State<HomepagePolice> {
  String uid;
  String temp;
  @override
  void initState() {
    // uid = widget.uid;
    // Workmanager.initialize(instantReportExecuter, isInDebugMode: true);

    // // Workmanager.registerOneOffTask("1", "Background instant report",
    // //     inputData: {
    // //       "uid": uid,
    // //     });
    // // print();
    // subscription = _stream.listen(actionTaken);
    // // print("$subscription");
    // subscription.onData((data) {
    //   Workmanager.registerOneOffTask("2", "Background instant report",
    //       inputData: {
    //         "uid": uid,
    //       });
    //   // Workmanager.registerPeriodicTask(
    //   //   "3",
    //   //   "Background instant report",
    //   //   inputData: {
    //   //     "uid": uid,
    //   //   },
    //   // );
    //   print("$data");
    // });

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

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    /*  Navigator.push(
        context, MaterialPageRoute(builder: (context) => EmailSignInPage())); */
    //just uncomment the above if u wnt signout to work
    //copy same code in user.dart if u want signout there
    //need to make more changes for sign out..uid u can use for now
    //il delete useless files later
  }

  @override
  Widget build(BuildContext context) {
    UserDetails u = Provider.of<UserDetails>(context, listen: false);
    //inherited widget using provider to access uid to all child widgets
    uid = u.uid;
    return Scaffold(
      endDrawer: Drawers(true, u),
      // floatingActionButton: FloatingActionButtonWidget(uid),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SlidingUpPanel(
        color: Color(backgroundColor),
        maxHeight: 600,
        minHeight: 100,
        isDraggable: true,
        backdropEnabled: true,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
        //TODO: Make panel
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

// class FloatingActionButtonWidget extends StatelessWidget {
//   final String id;
//   FloatingActionButtonWidget(this.id);
//   // PanelController _panelController = PanelController();
//   // onPressed: () => _panelController.open(),

//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       backgroundColor: Colors.red,
//       onPressed: () {
//         LocationReport(id).saveReport(context);
//          Noti obj = Noti();
//         obj.showNotification(
//           sentence: 'Your report is getting generated.',
//           heading: 'Generating...',
//         );
//         _panelController.open();
//       },
//       child: Icon(Icons.offline_bolt),
//     );
//   }
// }
