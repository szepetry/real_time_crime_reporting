import 'package:firebase_database/firebase_database.dart';

class MultiInfoObject {
  String _id;

  List<dynamic> infoMap = List<dynamic>();
  
  int _count;
  MultiInfoObject(this.infoMap,this._count);
  MultiInfoObject.withId(this._id, this.infoMap,this._count);

  MultiInfoObject.fromSnapshot(DataSnapshot snapshot) {
    this.infoMap = snapshot.value['infoObject'];
    this._count = snapshot.value['count'];
  }

  Map<String, dynamic> toJson() {
    return {
        "infoObject": infoMap,
        "count": _count+1,
        "handled": "action"
    };
  }

  //Getters
  String get id => this._id;
  List<dynamic> get infoObject => this.infoMap;
  int get count => this._count;

  //Setters
  set infoObject(List<dynamic> infoObject) {
    this.infoMap = infoObject;
  }
  set count(int count){
    this._count=count;
  }
}
