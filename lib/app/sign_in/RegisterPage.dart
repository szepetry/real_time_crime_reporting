import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instant_reporter/app/sign_in/RegisterForm.dart';

class RegisterPage extends StatelessWidget {
  bool _userAuth;
  bool _policeAuth;
  String _name;
  RegisterPage();
  void initState() {
    _userAuth = false;
    _policeAuth = false;
    _name = '';
    print('boo');
  }

  Stream<FirebaseUser> get onAuthStateChanged {
    return FirebaseAuth.instance.onAuthStateChanged;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        elevation: 2.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(child: RegisterForm(_userAuth, _policeAuth, _name)),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
