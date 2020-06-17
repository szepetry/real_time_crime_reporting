import 'package:flutter/material.dart';
import 'package:instant_reporter/AuthenticationHandle/LandingPage.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:async';
// import 'package:geolocator/geolocator.dart';
// import 'package:transparent_image/transparent_image.dart';
// import 'package:instant_reporter/pages/FireMap.dart';
import '../Forms/LocationReport.dart';
import 'package:instant_reporter/MainPages/MainBodyStack.dart';
import 'package:instant_reporter/MainPages/BottomPanelView.dart';
import 'package:instant_reporter/common_widgets/notifications.dart';

// import 'package:flutter/services.dart';

PanelController _panelController = PanelController();

class HomepageUser extends StatefulWidget {
  HomepageUser(); //use this uid here
  @override
  _HomepageUserState createState() => _HomepageUserState();
}

class _HomepageUserState extends State<HomepageUser> {
  String uid;

  @override
  void initState() {
    super.initState();
  }

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
      floatingActionButton: FloatingActionButtonWidget(uid),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SlidingUpPanel(
        maxHeight: 600,
        minHeight: 100,
        isDraggable: true,
        backdropEnabled: true,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
        panel: BottomPanelView(uid),
        body: MainBodyStack(uid),
        collapsed: Container(
          child: Divider(
            thickness: 4.0,
            endIndent: MediaQuery.of(context).size.width - 200,
            indent: MediaQuery.of(context).size.width - 300,
          ),
        ),
      ),
    );
  }
}

class FloatingActionButtonWidget extends StatelessWidget {
  final String id;
  FloatingActionButtonWidget(this.id);
  // PanelController _panelController = PanelController();
  // onPressed: () => _panelController.open(),

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.red,
      onPressed: () {  
        LocationReport(id).saveReport(context);
         Noti obj = Noti();
        obj.showNotification(
          sentence: 'Your report is getting generated.',
          heading: 'Generating...',
        );
        _panelController.open();
      },
      child: Icon(Icons.offline_bolt),
    );
  }
}
