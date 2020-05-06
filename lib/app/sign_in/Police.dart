import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instant_reporter/app/sign_in/AuthNew.dart';
import 'package:instant_reporter/app/sign_in/email_sign_in_page.dart';

class Police extends StatefulWidget {
  @override
  _PoliceState createState() => _PoliceState();
}

class _PoliceState extends State<Police> {
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
   /*  Navigator.push(
        context, MaterialPageRoute(builder: (context) => EmailSignInPage())); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hey I yum police')),
      body: Container(
        child: RaisedButton(
          onPressed: () {
            signOut();
          },
          child: Text('Sign Out', style: TextStyle(fontSize: 10)),
        ),
        //police code goes here
      ),
    );
  }
}
