import 'package:flutter/material.dart';
import 'package:instant_reporter/AuthenticationHandle/LandingPage.dart';
import 'package:instant_reporter/common_widgets/background_services.dart';
import 'package:instant_reporter/common_widgets/constants.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:async';
import 'package:workmanager/workmanager.dart';
import '../Forms/LocationReport.dart';
import 'package:instant_reporter/MainPages/MainBodyStack.dart';
import 'package:instant_reporter/MainPages/BottomPanelView.dart';
import 'package:instant_reporter/common_widgets/notifications.dart';


class HomepageUser extends StatefulWidget {
  HomepageUser();
  @override
  _HomepageUserState createState() => _HomepageUserState();
}

String actionTaken(dynamic data) {
  return data;
}

Stream _stream = platform.receiveBroadcastStream();
StreamSubscription subscription;

class _HomepageUserState extends State<HomepageUser> {
  String uid;

  @override
  void initState() {
    Workmanager.initialize(instantReportExecuter, isInDebugMode: true);
    subscription = _stream.listen(actionTaken);
    subscription.onData((data) {
      Workmanager.registerOneOffTask("5", "Background instant report",
          inputData: {
            "uid": uid,
          });
      print("$data");
    });
    //To start the service whenever Homepage opens
    startServiceInPlatform();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserDetails u = Provider.of<UserDetails>(context, listen: false);
    //inherited widget using provider to access uid to all child widgets
    uid = u.uid;

    return Scaffold(
      floatingActionButton: FloatingActionButtonWidget(uid),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SlidingUpPanel(
        color: Color(backgroundColor),
        maxHeight: 600,
        minHeight: 100,
        isDraggable: true,
        backdropEnabled: true,
        controller: panelController,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
        panel: BottomPanelView(uid),
        body: MainBodyStack(uid),
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
        header: Center(
          child: Padding(
            padding: EdgeInsets.only(left:MediaQuery.of(context).size.width * 0.05,top: 30),
            child: Container(
              child: Text("Reports",style: TextStyle(fontSize: 40,color: Colors.white),)
            ),
          ),
        )
      ),
    );
  }
}

class FloatingActionButtonWidget extends StatelessWidget {
  final String id;
  FloatingActionButtonWidget(this.id);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.red,
      onPressed: () {
        LocationReport(id).saveReport(context);

        NotificationManager notificationManager = NotificationManager();
        notificationManager.showNotification(
            sentence: 'Instant reporter service',
            heading: 'Your report has been generated.',
            priority: priority,
            importance: importance);
        panelController.open();
      },
      child: Icon(Icons.offline_bolt),
    );
  }
}
