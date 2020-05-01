import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instant_reporter/app/sign_in/email_sign_in_page.dart';

class AuthService{
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  //SignIn
  signIn(AuthCredential authCreds) async {
    await FirebaseAuth.instance.signInWithCredential(authCreds);
    
  }

  signInWithOTP(smsCode, verId) async {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    await signIn(authCreds);
  }
}