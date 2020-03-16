import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'infoObject.dart';

class MultiInfoObject {
  // String _id;

  List<MultiInfoObject> multiMap = List<MultiInfoObject>();

  // List<dynamic> infoMap = List<dynamic>();
  // List<InfoObject> infoObjs = List<InfoObject>();
  
  // InfoObject _infoObject;
  // int _count;
  // MultiInfoObject({this.infoMap});
  // MultiInfoObject.withId(this._id, this.infoMap,this._count);

  MultiInfoObject.fromMap( Map<String,dynamic> data){
    multiMap = data['multiInfoObject'];
  }


  Map<String, dynamic> toJson() {
    return {
        "multiInfoObject": multiMap,
    };
  }
  // List<dynamic> addToList(MultiInfoObject mapObj) {
  //   List<dynamic> newList = List<dynamic>();
  //   newList.add(mapObj);
  //   return newList;
  // }
  //Getters
  // String get id => this._id;
  // List<dynamic> get infoObject => this.infoMap;
  // int get count => this._count;

  //Setters
  // set infoObject(List<dynamic> infoObject) {
  //   this.infoMap = infoObject;
  // }
  // set count(int count){
  //   this._count=count;
  // }
}
