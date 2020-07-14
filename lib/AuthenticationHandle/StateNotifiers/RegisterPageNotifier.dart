import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instant_reporter/AuthenticationHandle/StateNotifiers/Authenticate.dart';
import 'package:flutter/material.dart';
import 'package:instant_reporter/AuthenticationHandle/StateNotifiers/FirestoreService.dart';

//Notifier for both login and register page
class RegisterPageNotifier extends FirestoreService with ChangeNotifier {
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  String smsCode;
  String aadhar;
  String enteredPassword;
  String rePassword;
  bool validAadhar = true;
  bool validPassword = true;
  bool validRePassword = true;
  bool validPhone = true;
  bool validLoginPassword = true;
  bool loginMode = false;
  bool canSubmit = true;
  set setLoginMode(bool value) {
    this.loginMode = value;
    notifyListeners();
  }

  set setValidPhone(bool value) {
    this.validPhone = value;
    notifyListeners();
  }

  bool get getValidPhone => validPhone;

  bool get checkRepass => validRePassword;
  bool get checkValidPassword => validPassword;
  bool get checkValidAadhar => validAadhar;
  bool get aadharLengthValid => aadharController.text.toString().length == 12;
  bool get phoneLengthValid => phoneController.text.toString().length == 10;
  bool get passwordLengthValid =>
      passwordController.text.toString().length >= 5;
  bool get rePasswordLengthValid =>
      rePasswordController.text.toString().length >= 1;
  String get phoneNo => phoneController.text.toString();
  String get aadharNo => aadharController.text.toString();
  String get password => passwordController.text.toString();

  Future<void> validateAadhar() async {
    if (aadharLengthValid) {
      aadhar = aadharController.text;
      await crossCheck('aadhar', aadhar, false);
      aadharDB == aadhar ? validAadhar = true : validAadhar = false;
    } else
      validAadhar = true;
    canSubmit = validAadhar;
    notifyListeners();
  }

  Future<void> validatePassword() async {
    if (passwordLengthValid) {
      enteredPassword = passwordController.text;
      loginMode == false
          ? handleRegistrationPasswordVerification()
          : handleLoginPasswordVerification();
      print(passwordDB);
    } else
      validPassword = true;
    canSubmit = validPassword;
    notifyListeners();
  }

  void handleRegistrationPasswordVerification() => passwordDB == enteredPassword
      ? validPassword = false
      : validPassword = true;
  void handleLoginPasswordVerification() => passwordDB == enteredPassword
      ? validPassword = true
      : validPassword = false;

  void validateRePassword() {
    rePassword = rePasswordController.text;
    if (rePasswordLengthValid) {
      passwordController.text == rePassword
          ? validRePassword = true
          : validRePassword = false;
    } else
      validRePassword = true;
    canSubmit = validRePassword;
    notifyListeners();
  }

  bool checkIfFieldsEmptyRegister() =>
      aadharLengthValid &&
      phoneLengthValid &&
      passwordLengthValid &&
      rePasswordLengthValid;

  bool canSubmitForm() {
    return true;
    /*  if (loginMode == false) {
      if (checkIfFieldsEmptyRegister()) {
        bool canSubmit =
            validAadhar && validPassword && validRePassword && phoneLengthValid;
        return canSubmit;
      } else
        return false;
    } else {
      if (phoneLengthValid && passwordLengthValid) {
        bool canSubmit = validPassword && validPhone;
        return canSubmit;
      } else
        return false;
    } */
  }

  void processRegistration(BuildContext context, Authenticate auth) async {
    isError == false
        ? authenticateUser(auth, context)
        : auth.displayDialog('Authentication failed', 'Network Error');
    isError = false;
  }

  void clearControllers() {
    phoneController.clear();
    passwordController.clear();
    aadharController.clear();
    rePasswordController.clear();
  }

  Future<void> authenticateUser(Authenticate auth, BuildContext context) async {
    canSubmitForm() == true
        ? await auth.verifyPhone('+91' + phoneNo, context)
        : auth.displayDialog('Enter Valid Credentials', 'Authentication Error');
  }

  void newUserUpdate(String uid) => updateNewUser(
      UserData(nameDB, aadharNo, phoneNo, getOccupation, password), uid);

  Future<void> crossCheckLoginData(
      String key, String enteredString, bool isLogin) async {
    if (phoneLengthValid) {
      await crossCheck(key, enteredString, isLogin);
      if (key == 'phoneNo')
        enteredString == phoneNoDB
            ? setValidPhone = true
            : setValidPhone = false;
      if (key == 'password')
        enteredString == passwordDB
            ? validLoginPassword = true
            : validLoginPassword = false;
    }
  }
}

class UserData {
  String _name;
  String _aadhar;
  String _phoneNo;
  String _password;
  String _occupation;
  GeoPoint _point;
  UserData(this._name, this._aadhar, this._phoneNo, this._occupation,
      this._password);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> userData = {
      'name': _name,
      'aadhar': _aadhar,
      'phoneNo': _phoneNo,
      'password': _password,
      'occupation': _occupation,
      'location': _point,
      'token': "",
      "zoneId": "",
    };
    return userData;
  }
}
