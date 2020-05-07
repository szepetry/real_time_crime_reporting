import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instant_reporter/app/sign_in/AuthNew.dart';
import 'package:instant_reporter/app/sign_in/email_sign_in_page.dart';

class Police extends StatefulWidget {
  String uid;
  Police(this.uid); //use this uid here

  @override
  _PoliceState createState() => _PoliceState();
}

class _PoliceState extends State<Police> {
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    /*  Navigator.push(
        context, MaterialPageRoute(builder: (context) => EmailSignInPage())); */
        //just uncomment the above if u wnt signout to work 
        //copy same code in user.dart if u want signout there
        //need to make more changes for sign out..uid u can use for now
        //il delete useless files later 
  }

  void initState() {
    print(widget.uid);
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
