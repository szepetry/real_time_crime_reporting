import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instant_reporter/app/sign_in/UserDetails.dart';

class MyAccount extends StatefulWidget {
  UserDetails userDetails;
  MyAccount(this.userDetails);
  
  @override
  _MyAccountState createState() => _MyAccountState();
}

 
class _MyAccountState extends State<MyAccount> {
  DocumentSnapshot ds;
  String name,aadhar,phone;

void initState(){
setState(() {
  waitForData();
});
}
  waitForData() async {
    await _getDetailsByUserId();
  }
  Future<void> _getDetailsByUserId() async {
    
    if(widget.userDetails.isPolice)
    ds=await Firestore.instance.collection('registered_police').document(widget.userDetails.uid).get();
    else
    ds=await Firestore.instance.collection('registered_user').document(widget.userDetails.uid).get();
    setState(() {
      name=ds.data['name'];
      phone=ds.data['phone'];
      aadhar=ds.data['aadhar'];
    });
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('My Account'),leading: Container(),centerTitle: true,),
      body: Center(
      child: ds!=null?Column(children:<Widget>[
        SizedBox(height:8.0),
      Text('Name: ${ds.data['name']}',style: TextStyle(fontSize:20),),
      //Text('Aadhar Number'),
      SizedBox(height:8.0),
      Text('Phone Number: ${ds.data['phone']}',style: TextStyle(fontSize:20),),
    ],):Center(child:CircularProgressIndicator()),
  ) 
    );
  }
}

Widget buildList(var userDetails){
  return Center(
      child: userDetails!=null?Column(children:<Widget>[
        SizedBox(height:8.0),
      Text('Name: ${userDetails['name']}',style: TextStyle(fontSize:20),),
      //Text('Aadhar Number'),
      SizedBox(height:8.0),
      Text('Phone Number: ${userDetails['phone']}',style: TextStyle(fontSize:20),),
    ],):Center(child: CircularProgressIndicator(),),
  ) ;
}