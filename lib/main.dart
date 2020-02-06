import 'package:flutter/material.dart';
import 'MainPages/Homepage.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Instant reporter",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: SafeArea(
        child: Homepage(),
          ),
        );
  }
}