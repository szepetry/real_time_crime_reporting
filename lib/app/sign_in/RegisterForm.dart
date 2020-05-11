import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instant_reporter/app/sign_in/AuthNew.dart';
import 'package:instant_reporter/app/sign_in/PasswordHandle.dart';
import 'package:instant_reporter/app/sign_in/RegisterPage.dart';
import 'package:instant_reporter/app/sign_in/validators.dart';
import 'package:instant_reporter/common_widgets/form_submit_button.dart';
import 'package:instant_reporter/app/sign_in/login.dart';
import 'package:flutter/cupertino.dart';

class RegisterForm extends StatefulWidget {
  bool _userAuth;
  bool _policeAuth;
  String _name;
  RegisterForm(this._userAuth, this._policeAuth, this._name);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  String phoneNo;
  String smsCode;
  String _aadhar;
  String _enteredPassword;
  String _rePassword;
  bool _submitted=true;

  List<Widget> _buildChildren() {
    return [
      SizedBox(height: 8.0),
      TextField(
        controller: _aadharController,
        decoration: InputDecoration(
          labelText: 'Enter 12 digit aadhar number',
          hintText: 'XXXXXXXXXXXX',
          errorText: null,
          enabled: _submitted?true:false
        ),
        maxLength: 12,
        onChanged: (value){
          this._aadhar=value;
        },
      ),
      SizedBox(height: 8.0),
      TextField(
        controller: _phoneController,
        onChanged: (value) {
          this.phoneNo = value;
        },
        decoration: InputDecoration(
          labelText: 'Enter 10 digit Phone Number',
          hintText: '+91 ',
          errorText: null,
          enabled: _submitted?true:false
        ),
        obscureText: false,
        maxLength: 10,
      ),
      SizedBox(height: 8.0),
      TextField(
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: 'Enter Password',
          errorText: null,
          enabled: _submitted?true:false,
          hintText: 'Minimum 5 characters'
        ),
        obscureText: true,
        onChanged: (value){
          this._enteredPassword=value;
        },
      ),
      SizedBox(height: 8.0),
      TextField(
        controller: _rePasswordController,
        decoration: InputDecoration(
          labelText: 'Re-Enter Password',
          errorText: null,
          enabled: _submitted?true:false,
          hintText: 'Minimum 5 characters'
        ),
        obscureText: true,
        onChanged: (value){
          this._rePassword=value;
        },
      ),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: 'Register',
        onPressed: _submitted?() async {
          setState(() {
              _submitted=false;
            });
            await validation();
        }:null,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        child: Text('Have an account? Log In'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        },
      ),
    ];
  }

  Future<void> validation() async {
    if(!Validator(ph:phoneNo,adhar:_aadhar ,pass:_enteredPassword,re_pass:_rePassword).checkIfFieldsEmpty()){
            if (_aadhar.length != 12)
            showErrorMsg(context, 'Enter Valid 12 digit Aadhar');
            if (phoneNo.length != 10)
            showErrorMsg(context, 'Enter valid 10 digit phone number');
            if(_enteredPassword.length<5 || _enteredPassword.length<5)
            showErrorMsg(context, 'Password length must be minimum 5 characters');
            if(_aadhar.length==12 && phoneNo.length==10 && _enteredPassword.length>=5 && _enteredPassword.length>=5)
            await _submit();
            }
            else
            showErrorMsg(context, 'All fields are mandatory');
  }

  Future<void> _submit() async {
    bool p;
    try{
      if (p=await searchUser("user_aadhar") || await searchUser("police_aadhar")){
      print(p);//p=Validator(u_auth: widget._userAuth,p_auth: widget._policeAuth).checkIfAadharExists()
      if (p=Validator(pass:_enteredPassword ,re_pass:_rePassword ).validatePasswords()) {
        print(p);
        if(p=!await PasswordHandle(_enteredPassword,'+91'+phoneNo,true).checkIfPasswordExists()){
          print(p);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Authenticate(
                    widget._userAuth,
                    widget._policeAuth,
                    true,//meaning registeration of new user not login
                    '+91' + this.phoneNo,
                    _passwordController.text.toString(),
                    widget._name,
                    _aadhar)));
        setState(() {
          _submitted=true;
        });
        }
        else
         showErrorMsg(context, 'Passwords Already Taken..Enter new Password');
      } else
        showErrorMsg(context, 'Passwords do not match');
    } else{
      showErrorMsg(context, 'Invalid Aadhar');
    }
    }
    catch(e){
    showErrorMsg(context, 'A Technical error has occurred');
    }
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
                onPressed: () {
                  setState(() {
                    _submitted=true;
                  });
                  Navigator.of(context).pop();
                } ,
                child: Text('OK'),
              )
            ],
          );
        });
  }

  Future<bool> searchUser(String adhuser) async {
    var list1 = [];
    var Aadhar;
    await Firestore.instance
        .collection(adhuser)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((U_Aadhar) => list1.add(U_Aadhar.data));
    });
    var adhNum;
    var enteredAdhNum;
    enteredAdhNum = _aadharController.text.toString();
    print(enteredAdhNum);
    for (var i = 0; i < list1.length; i++) {
      adhNum = list1[i]['aadhar'].toString();
      print(adhNum);
      if (adhNum.contains(enteredAdhNum) && adhuser == ("user_aadhar")) {
        setState(() {
          widget._userAuth = true;
          widget._policeAuth = false;
        });
        widget._name = list1[i]['name'].toString();
        return Future.value(true);
      } else if (adhNum.contains(enteredAdhNum) && adhuser == ("police_aadhar")) {
        setState(() {
          widget._policeAuth = true;
          widget._userAuth = false;
        });
        widget._name = list1[i]['name'].toString();
        return Future.value(false);
      } else {
        print('Not found -----------------');
          widget._policeAuth = false;
          widget._userAuth = false;
      }
      adhNum = '';
    }
    return Future.value(false);
    //print('aaaaaa');print(widget._userAuth);print(widget._policeAuth);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: _buildChildren(),
          ),
        );
  }
}
