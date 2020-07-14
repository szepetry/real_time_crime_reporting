import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instant_reporter/AuthenticationHandle/StateNotifiers/Authenticate.dart';

enum bailOutOptions { closeApp, signOut, deleteAccount }
bailOutOptions bailOutState;

class Bailout {
  /* 
  String logOutMsg = 'Are you sure you want to Log Out?';
  String closeApp = 'Close the app?';
  String deleteAccount = 'Are you sure you want to delete your account'; */

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

  void ascertainAction(context) {
    switch (bailOutState) {
      case bailOutOptions.signOut:
        _signOut();
        break;
      case bailOutOptions.closeApp:
        _closeAndSignOut(context);
        break;
      case bailOutOptions.deleteAccount:
        _deleteAccount();
        break;
      default:
    }
  }

  void _deleteAccount() => Authenticate.deleteAccount();

  Future<void> _signOut() async => Authenticate.signOut();

  Future<void> _closeAndSignOut(BuildContext context) async {
    await _signOut();
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  Widget ascertainText(String message) {
    switch (message) {
      case 'Are you sure you want to Log Out?':
        {
          bailOutState = bailOutOptions.signOut;
          return null;
        }
        break;
      case 'Close the app?':
        {
          bailOutState = bailOutOptions.closeApp;
          return Text('You will be Logged out as well');
        }
        break;
      case 'Are you sure you want to delete your account':
        {
          bailOutState = bailOutOptions.deleteAccount;
          return Text('Your account will be permanently deleted');
        }
        break;
      default:
        return null;
    }
  }
}
