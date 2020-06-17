import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instant_reporter/AuthenticationHandle/StateNotifiers/Authenticate.dart';
import 'package:instant_reporter/AuthenticationHandle/StateNotifiers/FirestoreService.dart';

enum bailOutOptions {closeApp,signOut,deleteAccount}
bailOutOptions bailOutState;
class Bailout {
 
Future<void> confirmBailOutRequest(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
            content: ascertainText(message),
            actions: <Widget>[
              FlatButton(
                onPressed: () async {
                  ascertainAction(context);
                  Navigator.of(context).pop();
                },
                child: Text('Yes'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
            ],
          );
        });
  }

   void ascertainAction(context){
    switch (bailOutState) {
      case bailOutOptions.signOut:
        _signOut();
        break;
      case bailOutOptions.closeApp:
        _closeAndSignOut(context);
        break;
      case bailOutOptions.deleteAccount:
        deleteAccount();
      break;
      default:
    }
  }

  void deleteAccount() => Authenticate.deleteAccount();

   Widget ascertainText(String message) {
    switch (message) {
      case 'Are you sure you want to Log Out?':{
        bailOutState=bailOutOptions.signOut;
        return null;
      }
        break;
      case 'Close the app?':{
        bailOutState=bailOutOptions.closeApp;
        return Text('You will be Logged out as well');
      }
        break;
      case 'Are you sure you want to delete your account':{
        bailOutState=bailOutOptions.deleteAccount;
        return Text('Your account will be permanently deleted');
      }
        break;
      default:
        return null;
    }
  }

  Future<void> _signOut() async => Authenticate.signOut();

  Future<void> _closeAndSignOut(BuildContext context) async {
    await _signOut();
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}
