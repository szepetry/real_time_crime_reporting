import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sih_app/model/multiInfoObject.dart';
import 'package:sih_app/model/multiInfoObject.dart';
import 'infoObject.dart';

class UserObject {
  // String _id;

  List<MultiInfoObject> multiMap = List<MultiInfoObject>();
  // List<InfoObject> infoObjs = List<InfoObject>();
  
  // MultiInfoObject _multiInfoObject;
  // int _count;
  // String id;
  // UserObject({this.multiMap});
  // UserObject.withId(this._id, this.userMap);

  // UserObject.fromSnapshot(DataSnapshot snapshot) {
  //   this.infoMap = snapshot.value['infoObject'];
  //   this._count = snapshot.value['count'];
  // }

  UserObject.fromMap( Map<String,dynamic> data){
    multiMap = data['multiInfoObject'];
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //       "multiInfoObject": multiMap,
  //   };
  // }

  // Getters
  // String get id => this._id;
  // List<dynamic> get multiMapFunc => this.multiMap;
  // int get count => this._count;

  //Setters
  // set multiMapFunc(List<dynamic> infoObject) {
  //   this.multiMap = infoObject;
  // }
  // // set count(int count){
  //   this._count=count;
  // }
}
