import 'package:flutter/material.dart';
import 'package:instant_reporter/MainPages/HomepagePolice.dart';
import 'package:instant_reporter/app/sign_in/UserDetails.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:provider/provider.dart';

class Police extends StatelessWidget {
  String uid;
  bool _isPolice;
  Police(this.uid, this._isPolice);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          MoveToBackground.moveTaskToBack();
          return false;
        },
        child: Scaffold(
          body: Provider<UserDetails>(
            create: (context) => UserDetails(uid: uid, isPolice: _isPolice),
            child: HomepagePolice(),
          ),
        ),
      ),
    );
  }
}
