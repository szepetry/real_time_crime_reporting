import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'infoObject.dart';

class MultiInfoObject {
  String _id;

  List<dynamic> infoMap = List<dynamic>();
  // List<InfoObject> infoObjs = List<InfoObject>();
  
  // InfoObject _infoObject;
  // int _count;
  MultiInfoObject({this.infoMap});
  // MultiInfoObject.withId(this._id, this.infoMap,this._count);

  MultiInfoObject.fromMap(Map<dynamic, dynamic> data)
    : infoMap = List.from(data['infoObject']);

  // Map<String, dynamic> toJson() {
  //   return {
  //       "infoObject": infoMap,
  //       "count": _count+1,
  //   };
  // }
  List<dynamic> addToList(MultiInfoObject mapObj) {
    List<dynamic> newList = List<dynamic>();
    newList.add(mapObj);
    return newList;
  }
  //Getters
  // String get id => this._id;
  List<dynamic> get infoObject => this.infoMap;
  // int get count => this._count;

  //Setters
  set infoObject(List<dynamic> infoObject) {
    this.infoMap = infoObject;
  }
  // set count(int count){
  //   this._count=count;
  // }
}
