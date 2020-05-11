import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:instant_reporter/app/sign_in/RegisterPage.dart';

class SignOut{
  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
     SchedulerBinding.instance.addPostFrameCallback((_) async {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) =>RegisterPage()),
                                  (Route<dynamic> route) => false);
                            });
  }

   Future<void> closeAndSignOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
     SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }



   void confirmSignout(BuildContext context,String message){
     bool _closeApp=true;
     if(message=='Are you sure you want to Log Out?')
     _closeApp=false;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(message),
              content: _closeApp?Text('You will be Logged out as well'):null,
              actions: <Widget>[
                FlatButton(
                  onPressed: () async{
                    _closeApp?await closeAndSignOut(context):await signOut(context);
                  },
                  child: Text('Yes'),
                ),
                FlatButton(
                  onPressed: (){
                      Navigator.of(context).pop();
                  },
                  child: Text('No'),
                ),
              ],
            );
          });
  }
}