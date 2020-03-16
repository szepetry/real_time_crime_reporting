import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sih_app/model/multiInfoObject.dart';
import 'dart:collection';

class UserObjNotifier with ChangeNotifier{

  List<MultiInfoObject> _multiInfoList = [];
  MultiInfoObject _currentMultiInfoObj;


  // Getters
  UnmodifiableListView<MultiInfoObject> get multiInfoList => UnmodifiableListView(_multiInfoList);
  MultiInfoObject get currentMultiInfoObj => _currentMultiInfoObj;

  //Setters
  set multiInfoList(List<MultiInfoObject> multiInfoList) {
    _multiInfoList = multiInfoList;
    notifyListeners();
  }

  set currentMultiInfoObj(MultiInfoObject multiInfoObj){
    _currentMultiInfoObj = multiInfoObj;
    notifyListeners();
  }
  // set count(int count){
  //   this._count=count;
  // }
}
