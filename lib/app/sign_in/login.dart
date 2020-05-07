import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instant_reporter/app/sign_in/AuthNew.dart';
import 'package:instant_reporter/app/sign_in/PasswordHandle.dart';
import 'package:instant_reporter/common_widgets/form_submit_button.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _userAuth = false;
  bool _policeAuth = false;
  String enteredphoneNo;
  String smsCode;
  String verificationId;
  int count = 0;
  String name;
  String enteredPassword;
  final TextEditingController _phNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> checkIfUserOrPolice() async {
    Future<bool> validPass;
    await SearchUser("registered_user");
    await SearchUser("registered_police");
    if (_phNoController.text.toString().length == 10) {
      if (checkIfValidPhone()) {
        if (await PasswordHandle(enteredPassword,'+91'+enteredphoneNo).checkIfPasswordExists()) {
          navigateToAuthenticate();
        } 
        else
          showErrorMsg(context, 'Password Invalid', true);
      } else
        showErrorMsg(context, 'Enter registered Phone Number', false);
    } else
      showErrorMsg(context, 'Enter valid 10 digit Phone Number', false);
  }

  navigateToAuthenticate() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Authenticate(_userAuth, _policeAuth, false,
                '+91' + enteredphoneNo, _passwordController.text.toString())));
  }

  Future<void> SearchUser(String userType) async {
    var User_details = new List();
    await Firestore.instance
        .collection(userType)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((User) => User_details.add(User.data));
    });
    var enteredphNo = _phNoController.text.toString();
    var phNo;
    for (int j = 0; j < User_details.length; j++) {
      phNo = User_details[j]['phone'].toString();
      if (phNo.contains(enteredphNo) && userType == "registered_user") {
        setState(() {
          _userAuth = true;
          _policeAuth = false;
        });
        name = User_details[j]['name'].toString();
      } else if (phNo.contains(enteredphNo) &&
          userType == "registered_police") {
        setState(() {
          _policeAuth = true;
          _userAuth = false;
        });
        name = User_details[j]['name'].toString();
      }
      phNo = '';
    }
  }

  bool checkIfValidPhone() {
    if (_userAuth == false && _policeAuth == false) {
      return false;
    }
    return true;
  }


  void showErrorMsg(BuildContext context, String msg, bool pop) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(msg),
            actions: <Widget>[
              FlatButton(
                onPressed: () => pop
                    ? Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()))
                    : Navigator.of(context).pop(),
                child: Text('OK'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 8.0),
                TextField(
                  controller: _phNoController,
                  decoration: InputDecoration(
                    labelText: '  Enter 10 digit phone number',
                    hintText: '  +91 ',
                  ),
                  onChanged: (value){
                    this.enteredphoneNo=value;
                  },
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: ' Enter Password',
                  ),
                  obscureText: true,
                  onChanged: (value){
                    this.enteredPassword=value;
                  },
                ),
                SizedBox(height: 8.0),
                FormSubmitButton(
                  text: 'Login',
                  onPressed: () async {
                    await checkIfUserOrPolice();
                  },
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
