import 'package:flutter/material.dart';
import 'package:instant_reporter/MainPages/HomepageUser.dart';

class User extends StatefulWidget {
  String uid;
  User(this.uid); //use this uid here

  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(child: HomepageUser(widget.uid))); //user code goes here
  }
}
