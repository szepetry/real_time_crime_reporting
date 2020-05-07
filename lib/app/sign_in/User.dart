import 'package:flutter/material.dart';
import 'package:instant_reporter/MainPages/Homepage.dart';

class User extends StatefulWidget {
  String uid;
  User(this.uid);//use this uid here

  @override
  _UserState createState() => _UserState();
}
class _UserState extends State<User> {
  void initState(){
  print(widget.uid);
}
  @override
  Widget build(BuildContext context) {
    return Container(child: Container(child: Homepage()));//user code goes here
  }
}