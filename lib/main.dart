import 'package:flutter/material.dart';
import 'package:instant_reporter/AuthenticationHandle/LandingPage.dart';
import 'package:instant_reporter/Forms/ReportForm.dart';
import 'package:instant_reporter/MainPages/User/HomepageUser.dart';
import 'common_widgets/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Color(cardColor),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Josefin_Sans", primarySwatch: Colors.amber),
      builder: (context, child) {
        return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 0.95), child: child);
      },
      routes: <String, WidgetBuilder>{
        '/home': (context) => SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: LandingPage.create(context),
            backgroundColor: Colors.grey[200],
          ),
        ),
      },
      initialRoute: '/home',
      // home: SafeArea(
      //     child: Scaffold(
      //       resizeToAvoidBottomInset: false,
      //       body: LandingPage.create(context),
      //       backgroundColor: Colors.grey[200],
      //     ),
      //   ),
    );
  }
}
