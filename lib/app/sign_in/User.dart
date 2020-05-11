import 'package:flutter/material.dart';
import 'package:instant_reporter/MainPages/HomepageUser.dart';
import 'package:instant_reporter/app/sign_in/UserDetails.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:provider/provider.dart';

class User extends StatefulWidget {
  String uid;
  bool _isPolice;
  User(this.uid,this._isPolice);
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
                      body:Provider<UserDetails>(
                        create:(context)=>UserDetails(uid:widget.uid,isPolice:widget._isPolice),
                        child: HomepageUser(),),),
          ),
                  );
    
  }
}
