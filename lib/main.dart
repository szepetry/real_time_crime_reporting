import 'package:flutter/material.dart';
import 'MainPages/Homepage.dart';
import 'Forms/ReportForm.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Instant reporter",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Josefin_Sans",
        primarySwatch: Colors.amber
      ),
      home: SafeArea(
        child: Homepage(),
        // child: ReportForm(),
          ),
        );
  }
}