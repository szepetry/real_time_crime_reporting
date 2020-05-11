import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class UpdateUser{
  final String name;
  final bool _userAuth;
  final bool _policeAuth;
  final String phoneNo;
  final String _password;
  final String uid;
  final String aadhar;
  UpdateUser(this.uid,this.name,this._userAuth,this._policeAuth,this.phoneNo,this._password,this.aadhar);
  final CollectionReference users=Firestore.instance.collection('registered_user');
  final CollectionReference policeusers=Firestore.instance.collection('registered_police');
  final CollectionReference passwords=Firestore.instance.collection('passwords');

  Future<void> updateUserData() async{
    String passwordEntry = 'password'+phoneNo;
     await passwords.document('ListOfPasswords').setData({
      passwordEntry:_password
    },merge: true);
    if(_userAuth==true){
        return await users.document(uid).setData({
      'name':name,
      'phone':phoneNo,
      passwordEntry:_password,
      'aadhar':aadhar
    });
    }
    else if(_policeAuth==true){
      return await policeusers.document(uid).setData({
      'name':name,
      'phone':phoneNo,
      passwordEntry:_password,
      'aadhar':aadhar
    }); }
  }
}
/*

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instant_reporter/app/sign_in/AuthNew.dart';
import 'package:instant_reporter/app/sign_in/email_sign_in_page.dart';
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
  String _passwordDb;
  final TextEditingController _phNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> checkIfUserOrPolice() async {
    enteredphoneNo = _phNoController.text.toString();
    Future<bool> validPass;
    await SearchUser("registered_user");
    await SearchUser("registered_police");
    if (_phNoController.text.toString().length != 10)
      showErrorMsg(context, 'Enter valid 10 digit Phone Number');
    if (!checkIfValidPhone())
      showErrorMsg(context, 'Enter registered Phone Number');
    if (!chkIfValidPassword())
      showErrorMsg(context, 'Password Invalid');
    else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Authenticate(
                  _userAuth,
                  _policeAuth,
                  false,
                  '+91' + enteredphoneNo,
                  _passwordController.text.toString())));
    }
  }

  void SearchUser(String userType) async {
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

  bool chkIfValidPassword() {
    getPassword();
    if (_passwordDb == _phNoController.text.toString())
      return true;
    else
      return false;
  }

  Future<void> getPassword() async {
    var passwords;
    await Firestore.instance
        .collection('ListOfPasswords')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents
          .forEach((PasswordList) => passwords = PasswordList.data);
    });
    _passwordDb = passwords['password$enteredphoneNo'].toString();
  }

  void showErrorMsg(BuildContext context, String msg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(msg),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Login())),
                child: Text('OK'),
              )
            ],
          );
        });
  
    @override
    Widget build(BuildContext context) {
      var _passwordController;
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
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: '  Enter 10 digit phone number',
                      hintText: '  +91 ',
                    ),
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
}

*/