import 'package:flutter/material.dart';
import 'package:instant_reporter/AuthenticationHandle/LandingPage.dart';
<<<<<<< HEAD
import 'package:instant_reporter/MainPages/HomepageUser.dart';
=======
>>>>>>> afcf98a81c13c2b614a22044705dfbe3bc5dfbf5

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Josefin_Sans", primarySwatch: Colors.amber),
      home: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: LandingPage.create(context),
          backgroundColor: Colors.grey[200],
        ),
      ),
    );
  }
}
