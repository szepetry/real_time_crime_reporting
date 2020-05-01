import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instant_reporter/app/sign_in/Police.dart';
import 'package:instant_reporter/app/sign_in/UpdateUser.dart';
import 'package:instant_reporter/app/sign_in/User.dart';
import 'package:instant_reporter/app/sign_in/email_sign_in_page.dart';

class Authenticate extends StatefulWidget {
      bool _userAuth;
  bool _policeAuth;
  bool _mode;
  String _name;
  String _phone;
   Authenticate(this._userAuth,this._policeAuth,this._mode,this._phone,[this._name]);
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final formKey = new GlobalKey<FormState>();

  String verificationId, smsCode;
  bool Reg=false;
  bool codeSent = false;

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
    signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed = (AuthException authException) {
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
        timeout: const Duration(seconds: 20),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }


  void initState(){
    super.initState();
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            verifyPhone(widget._phone); 
 });
  }

Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter OTP'),
            content: TextField(
              onChanged: (value) {
                smsCode = value;
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
  }

 signIn(AuthCredential authCreds) async {
    await FirebaseAuth.instance.signInWithCredential(authCreds).then((user){
    if(widget._mode==true) 
      UpdateUser(widget._name,widget._userAuth,widget._policeAuth,widget._phone).updateUserData();
      if(widget._userAuth==true){
        Navigator.push(context,MaterialPageRoute(builder: (context) =>User(),),);
      }
      else if(widget._policeAuth==true){
         Navigator.push(context,MaterialPageRoute(builder: (context) => Police(),),);
      }
    }).catchError((e){
      print('booooooooooooom');
      print(e);
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('ERROR'),
            content: Text('Enter valid OTP'),
            actions: <Widget>[
              FlatButton(onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) =>EmailSignInPage()
                  )
                  ), child: Text('OK'),)
            ],
          );
        }
      );
      //print('Auth Credential Error:$e');
    });
    
  }

  signInWithOTP(smsCode, verId) async {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    await signIn(authCreds);
  }

  void Navigate(){
    
  }
  
  @override
  Widget build(BuildContext context) {
        return Container(
      alignment: Alignment.center,
        child: Text('Authenticating..',
        style: Theme.of(context)
        .textTheme
        .display1
        .copyWith(color: Colors.white)),
      color: Colors.amber[600],
    );
  }
}