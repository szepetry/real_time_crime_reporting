import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'package:instant_reporter/app/sign_in/Police.dart';
import 'package:instant_reporter/app/sign_in/RegisterPage.dart';
import 'package:instant_reporter/app/sign_in/UpdateUser.dart';
import 'package:instant_reporter/app/sign_in/User.dart';
import 'package:instant_reporter/app/sign_in/UserDetails.dart';

class Authenticate extends StatefulWidget {
  bool _userAuth;
  bool _policeAuth;
  bool _mode; //true:register//false:login
  String _name;
  String _phone;
  String _password;
  String aadhar;
  Authenticate(
      this._userAuth, this._policeAuth, this._mode, this._phone, this._password,
      [this._name,this.aadhar]);
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  String verificationId, smsCode;
  bool Reg = false;
  bool codeSent = false;
  String _uid;

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      smsCodeDialog(context);
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget._phone,
        timeout: const Duration(seconds: 30),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      verifyPhone(widget._phone);
    });
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    bool _sent = false;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
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
                onPressed: !_sent
                    ? () async {
                        setState(() {
                          _sent = true;
                        });
                        await signInWithOTP(smsCode, verificationId);
                        //  Navigator.of(context).pop();
                      }
                    : null,
              )
            ],
          );
        });
  }

  Future<void> signIn(AuthCredential authCreds) async {
    await FirebaseAuth.instance
        .signInWithCredential(authCreds)
        .then((user) async {
      _uid = user.user.uid;
      if (widget._mode == true)
        await UpdateUser(_uid, widget._name, widget._userAuth,
                widget._policeAuth, widget._phone, widget._password,widget.aadhar)
            .updateUserData();
      if (widget._userAuth == true) {
        SchedulerBinding.instance.addPostFrameCallback((_) async {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => User(_uid,false)));
        });
      } else if (widget._policeAuth == true) {
        SchedulerBinding.instance.addPostFrameCallback((_) async {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Police(_uid,true)));
        });
      }
    }).catchError((e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('OTP Mismatch'),
              content: Text('An Error has Occurred'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>RegisterPage())),
                  child: Text('OK'),
                )
              ],
            );
          });
      //print('Auth Credential Error:$e');
    });
  }

  Future<void> signInWithOTP(smsCode, verId) async {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    await signIn(authCreds);
  }

  @override
  Widget build(BuildContext context) {
    // bool _loggedIn=false;
    return Container(
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 5.0),
              Text(
                'Authenticating..',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      );
  }
}
