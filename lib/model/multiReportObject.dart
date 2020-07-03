import 'package:firebase_database/firebase_database.dart';

class MultiReportObject {
  String _id;

  List<dynamic> multiMap = List<dynamic>();

  int _count;
  MultiReportObject(this.multiMap, this._count);
  MultiReportObject.withId(this._id, this.multiMap, this._count);

  MultiReportObject.fromSnapshot(DataSnapshot snapshot) {
    this.multiMap = snapshot.value['multiObject'];
    this._count = snapshot.value['count'];
  }

  Map<String, dynamic> toJson() {
    return {
      "multiObject": multiMap,
      "count": _count + 1,
    };
  }

  //Getters
  String get id => this._id;
  List<dynamic> get multiObject => this.multiMap;
  int get count => this._count;

  //Setters
  set multiObject(List<dynamic> multiObject) {
    this.multiMap = multiObject;
  }

  set count(int count) {
    this._count = count;
  }
}
