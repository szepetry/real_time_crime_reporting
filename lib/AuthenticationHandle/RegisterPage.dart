import 'package:flutter/material.dart';
import 'package:instant_reporter/AuthenticationHandle/StateNotifiers/RegisterPageNotifier.dart';
import 'package:instant_reporter/AuthenticationHandle/SubmitButtons/FormSubmitButton.dart';
import 'package:instant_reporter/AuthenticationHandle/StateNotifiers/Authenticate.dart';
import 'package:instant_reporter/common_widgets/constants.dart';

class RegisterPage extends StatelessWidget {
  final RegisterPageNotifier registerHandle;
  final Authenticate auth;
  RegisterPage(this.registerHandle, this.auth);

  TextEditingController get _getAadharController =>
      registerHandle.aadharController;
  TextEditingController get _getPhoneNoController =>
      registerHandle.phoneController;
  TextEditingController get _getPasswordController =>
      registerHandle.passwordController;
  TextEditingController get _getRePasswordController =>
      registerHandle.rePasswordController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Register'),
        elevation: 2.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 16.0, bottom: 260.0, left: 16.0, right: 16.0),
        child: Card(
          //  color: Color(cardColor),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: _buildChildren(context),
                ),
              )),
        ),
      ),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    return [
      SizedBox(height: 8.0),
      buildAadharField(),
      SizedBox(height: 8.0),
      buildPhoneField(),
      SizedBox(height: 8.0),
      buildPasswordField(),
      SizedBox(height: 8.0),
      buildRePasswordField(),
      SizedBox(height: 8.0),
      buildSubmitButton(),
      SizedBox(height: 8.0),
      buildLoginPage(),
    ];
  }

  Widget buildAadharField() {
    return TextField(
      controller: _getAadharController,
      decoration: InputDecoration(
          labelText: 'Enter 12 digit aadhar number',
          hintText: 'XXXXXXXXXXXX',
          //  labelStyle: kTextStyleforLabelText,
          errorText:
              registerHandle.checkValidAadhar ? null : 'Enter Valid Aadhar',
          enabled: true), //_submitted ? true : false),
      maxLength: 12,
      onChanged: (value) => registerHandle.validateAadhar(),
    );
  }

  Widget buildPhoneField() {
    return TextField(
      controller: _getPhoneNoController,
      decoration: InputDecoration(
          labelText: 'Enter 10 digit Phone Number',
          hintText: '+91 ',
          errorText: null,
          enabled: true), //_submitted ? true : false),
      obscureText: false,
      maxLength: 10,
    );
  }

  Widget buildPasswordField() {
    return TextField(
      controller: _getPasswordController,
      decoration: InputDecoration(
          labelText: 'Enter Password',
          errorText:
              registerHandle.checkValidPassword ? null : 'Password Taken',
          enabled: true, //_submitted ? true : false,
          hintText: 'Minimum 5 characters'),
      obscureText: true,
      onChanged: (value) => registerHandle.validatePassword(),
    );
  }

  Widget buildRePasswordField() {
    return TextField(
      controller: _getRePasswordController,
      decoration: InputDecoration(
          labelText: 'Re-Enter Password',
          errorText: registerHandle.checkRepass ? null : 'Password Mismatch',
          enabled: true, //_submitted ? true : false,
          hintText: 'Minimum 5 characters'),
      obscureText: true,
      onChanged: (value) => registerHandle.validateRePassword(),
    );
  }

  StreamBuilder<bool> buildSubmitButton() {
    return StreamBuilder<bool>(
        stream: auth.isLoadingStream,
        builder: (context, snapshot) {
          return FormSubmitButton(
            text: 'Register',
            onPressed: snapshot.data != true
                ? registerHandle.canSubmit
                    ? () {
                        auth.isLoadingController.add(true);
                        auth.isNewUser = true;
                        registerHandle.processRegistration(context, auth);
                      }
                    : null
                : null,
          );
        });
  }

  Widget buildLoginPage() {
    return FlatButton(
      child: Text('Have an account? Log In'),
      onPressed: () {
        _getPasswordController.clear();
        _getPhoneNoController.clear();
        registerHandle.setLoginMode = true;
      },
    );
  }
}
