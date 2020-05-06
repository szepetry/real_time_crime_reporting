import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instant_reporter/app/sign_in/email_sign_in_page.dart';

class LogOutService{

  invokeAuthStream() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EmailSignInPage()));
          }
        });
  }
  
}

