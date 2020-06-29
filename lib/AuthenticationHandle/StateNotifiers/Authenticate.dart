import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instant_reporter/AuthenticationHandle/StateNotifiers/FirestoreService.dart';

class Authenticate with ChangeNotifier {
  String verificationId, smsCode;
  bool codeSent = false;
  String uid;
  BuildContext context;
  bool _otpsent = false;
  bool isNewUser = false;
  Authenticate(this.context);

  static Future<bool> deleteAccount() {
    bool deleteFailed = false;
    FirebaseAuth.instance.currentUser().then(
      (value) async {
        await FirestoreService.deleteUser(value.uid);
        await value.delete().catchError((e) => deleteFailed = true);
      },
    );
    return Future.value(deleteFailed);
  }

  static Future<void> signOut() async => await FirebaseAuth.instance.signOut();

  final StreamController<bool> isLoadingController =
      new StreamController<bool>.broadcast();
  Stream<bool> get isLoadingStream =>
      isLoadingController.stream.asBroadcastStream();

  void closeLoadingStream() => isLoadingController.close();

  static Stream<FirebaseUser> get currentAuthState =>
      FirebaseAuth.instance.onAuthStateChanged;

  Future<void> verifyPhone(String phoneNo, BuildContext context) async {
    loadingDialog(context);

    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      if (_otpsent == false) signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) => print('${authException.message}');

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) async {
      _otpsent = true;
      this.verificationId = verId;
      await smsCodeDialog(context);
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout =
        (String verId) => this.verificationId = verId;

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 30),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StreamBuilder<bool>(
              stream: isLoadingStream,
              builder: (context, snapshot) {
                if (snapshot.data == false) {
                  popLoadingScreen();
                }
                return new AlertDialog(
                  title: Text('Enter OTP'),
                  content: TextField(
                    onChanged: (value) {
                      this.smsCode = value;
                    },
                  ),
                  contentPadding: EdgeInsets.all(10.0),
                  actions: <Widget>[
                    new FlatButton(
                      child: Text('Done'),
                      onPressed: () async {
                        await signInWithOTP(smsCode, verificationId);
                      },
                    )
                  ],
                );
              });
        });
  }

  Future<void> signInWithOTP(String smsCode, String verId) async {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    await signIn(authCreds);
  }

  Future<void> displayDialog(String message, [String title]) async {
    return showDialog(
        context: context,
        builder: (context) {
          isLoadingController.add(false);
          return AlertDialog(
            title: title != null ? Text(title) : null,
            content: Text(message),
          );
        });
  }

  Widget circularIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        SizedBox(height: 5.0),
        Text('Authenticating',
            style: TextStyle(color: Colors.black, fontSize: 20)),
      ],
    );
  }

  void popLoadingScreen() => WidgetsBinding.instance
      .addPostFrameCallback((timeStamp) => Navigator.pop(context, true));

  Future<void> loadingDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StreamBuilder<bool>(
              stream: isLoadingStream,
              builder: (context, snapshot) {
                if (snapshot.data == false) popLoadingScreen();
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 250, left: 50, right: 50, bottom: 250),
                  child: AlertDialog(
                    content: circularIndicator(),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                  ),
                );
              });
        });
  }

  Future<void> signIn(AuthCredential authCreds) async {
    await FirebaseAuth.instance
        .signInWithCredential(authCreds)
        .then((user) async {
      uid = user.user.uid;
    }).catchError((e) async {
      print(e);
      isLoadingController.add(false);
      await displayDialog('An error has occurred', 'Auth Failed');
    });
    _otpsent = false;
   
    // closeLoadingStream();
  }
}
