import 'package:cloud_firestore/cloud_firestore.dart';

class PasswordHandle{
  String _enteredPassword;
  String _phoneNo;
  PasswordHandle(this._enteredPassword,this._phoneNo);
  Future<bool> checkIfPasswordExists() async{
    String _passwordFromDatabase;
    var passwords;
    await Firestore.instance
        .collection('passwords')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents
          .forEach((PasswordList) => passwords = PasswordList.data);
    });
    _passwordFromDatabase = passwords['password$_phoneNo'].toString();
    print(_passwordFromDatabase);
    print(_enteredPassword);
    if(_passwordFromDatabase==_enteredPassword)
    return Future.value(true);
    else
    return Future.value(false);
  }

  }
