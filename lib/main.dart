import 'package:flutter/material.dart';
import 'pages/Homepage.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SIH App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: SafeArea(
        child: Homepage(),
          ),
        );
  }
}