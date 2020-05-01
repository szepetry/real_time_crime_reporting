import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';

class UpdateUser{
  final String name;
  final bool _userAuth;
  final bool _policeAuth;
  final String phoneNo;
   
  UpdateUser(this.name,this._userAuth,this._policeAuth,this.phoneNo);
  final CollectionReference users=Firestore.instance.collection('registered_user');
  final CollectionReference policeusers=Firestore.instance.collection('registered_police');


  Future updateUserData() async{
    if(_userAuth==true){
        return await users.document(phoneNo).setData({
      'name':name,
      'phone':phoneNo
    });
    }
    else if(_policeAuth==true){
      return await policeusers.document(phoneNo).setData({
      'name':name,
      'phone':phoneNo
    });
    
    }
    /* return await users.document(uid).setData({
      'name':this.name,
      'uid':this.uid,
      'aadhar':this.aadhar,
    }); */
  }

}