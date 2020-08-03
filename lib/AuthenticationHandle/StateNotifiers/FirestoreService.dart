import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instant_reporter/AuthenticationHandle/StateNotifiers/RegisterPageNotifier.dart';

class FirestoreService {
  bool isError = false;

  String aadharDB, occupation, phoneNoDB, passwordDB,nameDB;
  
  String get getOccupation => this.occupation;

  static CollectionReference _validationLists =
      Firestore.instance.collection('validationLists');

  final CollectionReference aadhars = Firestore.instance.collection('aadhars');

  final CollectionReference registeredUsers =
      Firestore.instance.collection('registeredUsers');

  final Future<DocumentSnapshot> passwords =
      _validationLists.document('passwords').get();

  static Stream registeredUserStream(String uid) => Firestore.instance
      .collection('registeredUsers')
      .document('$uid')
      .snapshots();

  static DocumentReference registeredUserDocument(String uid) =>
      Firestore.instance.collection('registeredUsers').document('$uid');

  Future<void> updateNewUser(UserData user, String uid) async =>
      await registeredUserDocument(uid).setData(user.toMap(), merge: true);

  static Future<void> deleteUser(String uid) async =>
      await registeredUserDocument(uid).delete();

  Future<void> crossCheck(String key, String enteredString, bool isLogin) async {
    isError = false;
    occupation = '';
    phoneNoDB = '';
    passwordDB = '';
    Query q = isLogin == true
        ? registeredUsers.where(key, isEqualTo: enteredString)
        : aadhars.where(key, isEqualTo: enteredString);
    await q
        .getDocuments()
        .then(
          (value) => _lookUpDatabase(value,key,enteredString,isLogin),
        )
        .catchError((e) => isError = true);
  }

  void _lookUpDatabase(QuerySnapshot value,String key, String enteredString, bool isLogin){
    value.documents.forEach(
            (element) {
              if (isLogin == true) {
                _loadLoginCreds(element.data);
              } else {
                _loadRegisterCreds(element.data);
                _getPassword(key, enteredString);
              }
            },
          );
  }

  void _loadLoginCreds(Map<String,dynamic> userDetails){
    phoneNoDB = userDetails['phoneNo'];
    occupation = userDetails['occupation'];
    passwordDB = userDetails['password'];
  }

  void _loadRegisterCreds(Map<String,dynamic> aadharDetails){
    aadharDB = aadharDetails['aadhar'];
    occupation = aadharDetails['occupation'];
    nameDB=aadharDetails['name'];
  }

  Future<void> _getPassword(String aadharKey, String enteredAadhar) async {
    Query passwordRetreive =
        registeredUsers.where(aadharKey, isEqualTo: enteredAadhar);
    passwordRetreive.getDocuments().then(
          (value) => value.documents
              .forEach((element) => passwordDB = element.data['password']),
        );
  }
}
