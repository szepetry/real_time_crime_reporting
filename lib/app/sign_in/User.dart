import 'package:flutter/material.dart';
import 'package:instant_reporter/MainPages/Homepage.dart';

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Container(child: Homepage()));//user code goes here
  }
}