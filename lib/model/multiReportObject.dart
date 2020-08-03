import 'package:firebase_database/firebase_database.dart';

class MultiReportObject {
  String _id;

  List<dynamic> multiMap = List<dynamic>();
  String _name;
  String _phone;
  String _aadhar;

  int _count;
  MultiReportObject(
      this.multiMap, this._count, this._aadhar, this._name, this._phone);
  MultiReportObject.withId(this._id, this.multiMap, this._count, this._aadhar,
      this._name, this._phone);

  MultiReportObject.fromSnapshot(DataSnapshot snapshot) {
    this.multiMap = snapshot.value['multiObject'];
    this._count = snapshot.value['count'];
    this._aadhar = snapshot.value['aadhar'];
    this._name = snapshot.value['name'];
    this._phone = snapshot.value['phone'];
  }

  Map<String, dynamic> toJson() {
    return {
      "multiObject": multiMap,
      "count": _count + 1,
      "aadhar": _aadhar,
      "name": _name,
      "phone": _phone
    };
  }

  //Getters
  String get id => this._id;
  List<dynamic> get multiObject => this.multiMap;
  int get count => this._count;
  String get aadhar => this._aadhar;
  String get name => this._name;
  String get phone => this._phone;

  //Setters
  set multiObject(List<dynamic> multiObject) {
    this.multiMap = multiObject;
  }

  set count(int count) {
    this._count = count;
  }

  set aadhar(String aadhar) {
    this._aadhar = aadhar;
  }

  set name(String name) {
    this._name = name;
  }

  set phone(String phone) {
    this._phone = phone;
  }
}
