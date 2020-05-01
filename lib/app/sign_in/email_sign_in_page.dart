import 'package:flutter/material.dart';
import 'package:instant_reporter/app/sign_in/email_sign_in_form.dart';

class EmailSignInPage extends StatelessWidget {
  bool _userAuth;
  bool _policeAuth;
  String _name;
  void initState(){
    _userAuth=false;
    _policeAuth=false;
    _name='';
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
        child: Card(
          child: EmailSignInForm(_userAuth,_policeAuth,_name),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
