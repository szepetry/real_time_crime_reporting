import 'package:flutter/material.dart';
import 'package:instant_reporter/MainPages/HomepageUser.dart';
import 'package:instant_reporter/app/sign_in/UserDetails.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:provider/provider.dart';

class User extends StatefulWidget {
  String uid;
  bool _isPolice;
  User(this.uid, this._isPolice);
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          MoveToBackground.moveTaskToBack();
          return false;
        },
        child: Scaffold(
          //using inherited widget using provider package to call UserDetails object in any child widget under this widget
          //UserDetails class will have uid of the user and can be used in all children without passing through the constructor of every child
          //Just do -> UserDetails u =Provider.of<UserDetails>(context, listen: false); in any child // object 'u' will return uid if u run ->u.uid
          body: Provider<UserDetails>(
            create: (context) =>
                UserDetails(uid: widget.uid, isPolice: widget._isPolice),
            // child: HomepageUser(),
            child: HomepageUser(),
          ),
        ),
      ),
    );
  }
}
