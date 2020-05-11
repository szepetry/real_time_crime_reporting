import 'package:cloud_firestore/cloud_firestore.dart';

class PasswordHandle{
  String _enteredPassword;
  String _phoneNo;
  bool register;
  PasswordHandle(this._enteredPassword,this._phoneNo,this.register);
  
  Future<bool> checkIfPasswordExists() async{
    String _passwordFromDatabase;
    List passwords = new List();
    List justPasswords = new List();
    bool isPresent;
    DocumentSnapshot ds = await Firestore.instance.collection('passwords').document('ListOfPasswords').get();
    _passwordFromDatabase=ds.data['password$_phoneNo'];
    passwords.add(ds.data);
    if(register==false){
      print(passwords.elementAt(0));
       passwords.elementAt(0).forEach((k,v)=>justPasswords.add(PasswordList(v).toString()));
    justPasswords.contains(_enteredPassword)?isPresent=true:isPresent=false;
     return Future.value(isPresent);
    }
    /* print(justPasswords);
    print(passwords);
    print(_passwordFromDatabase);
    print(_enteredPassword); */
    if(_passwordFromDatabase==_enteredPassword)
    return Future.value(true);
    else
    return Future.value(false);
  }

  

  }

  class PasswordList{
    String password;
    PasswordList(this.password);

    @override
  String toString() {
    return '${this.password}';
  }
  }
