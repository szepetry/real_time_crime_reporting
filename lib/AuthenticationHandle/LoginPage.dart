import 'package:instant_reporter/AuthenticationHandle/StateNotifiers/Authenticate.dart';
import 'package:instant_reporter/AuthenticationHandle/StateNotifiers/RegisterPageNotifier.dart';
import 'package:flutter/material.dart';
import 'package:instant_reporter/AuthenticationHandle/SubmitButtons/FormSubmitButton.dart';
import 'package:instant_reporter/common_widgets/constants.dart';
class LoginPage extends StatelessWidget with ChangeNotifier {
  final RegisterPageNotifier registerHandle;
  final Authenticate auth;
  LoginPage(this.registerHandle, this.auth);

  TextEditingController get _getPhoneNoController =>
      registerHandle.phoneController;
  TextEditingController get _getPasswordController =>
      registerHandle.passwordController;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _getPasswordController.clear();
        _getPhoneNoController.clear();
        registerHandle.setLoginMode = false;
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        // appBar: AppBar(
        //   title: Text(
        //     'Login',
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        body: buildChildren(),
      ),
    );
  }

  Widget buildChildren() {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
             Padding(
               padding: const EdgeInsets.all(25.0),
               child: Text('Login',
                style: TextStyle(
                  color:Colors.white,
                  fontSize:30,
                ),),
             ),
            Card(
                 color: Color(cardColor),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 8.0),
                  buildPhoneField(),
                  SizedBox(height: 8.0),
                  buildPasswordField(),
                  SizedBox(height: 8.0),
                  buildSubmitButton(),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  StreamBuilder<bool> buildSubmitButton() {
    return StreamBuilder<bool>(
        stream: auth.isLoadingStream,
        builder: (context, snapshot) {
          return FormSubmitButton(
            text: 'Login',
            onPressed: snapshot.data != true
                ? registerHandle.canSubmit
                    ? () {
                        auth.isLoadingController.add(true);
                        auth.isNewUser = false;
                        registerHandle.processRegistration(context, auth);
                      }
                    : null
                : null,
          );
        });
  }

  bool get validateFields =>
      !registerHandle.getValidPhone || !registerHandle.validLoginPassword;

  Widget buildPhoneField() {
    return TextField(
      style: TextStyle(
        color: Colors.white,
      ),
      controller: _getPhoneNoController,
      decoration: InputDecoration(
     hintStyle:kTextStyleforLabelText ,
        labelStyle: kTextStyleforLabelText,
          enabled: true, //!_submitted?false:true,
          labelText: '  Enter 10 digit phone number',
          hintText: '  +91 ',
          errorText: registerHandle.getValidPhone == false
              ? 'Enter registered phone number'
              : null),
      onChanged: (value) => registerHandle.crossCheckLoginData(
          'phoneNo', registerHandle.phoneNo, true),
    );
  }

  Widget buildPasswordField() {
    return TextField(
       style: TextStyle(
        color: Colors.white,
      ),
      controller: _getPasswordController,
      decoration: InputDecoration(
        
         hintStyle:kTextStyleforLabelText ,
          enabled: true, //!_submitted?false:true,
          labelStyle: kTextStyleforLabelText,
         
          labelText: ' Enter Password',
          errorText: registerHandle.validLoginPassword == false
              ? 'Enter valid password'
              : null),
      obscureText: true,
      onChanged: (value) => registerHandle.crossCheckLoginData(
          'password', registerHandle.password, true),
    );
  }
}