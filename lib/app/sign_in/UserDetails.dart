import 'package:cloud_firestore/cloud_firestore.dart';


class UserDetails  {
  String uid;
  bool isPolice;
  var userDetails;

  UserDetails({String uid,bool isPolice}){
    this.uid = uid;
    this.isPolice = isPolice;
    //waitForData();
  }
  waitForData() async {
    await _getDetailsByUserId();
  }
  Future<void> _getDetailsByUserId() async {
    DocumentSnapshot ds;
    if(isPolice)
    ds=await Firestore.instance.collection('registered_police').document(uid).get();
    else
    ds=await Firestore.instance.collection('registered_user').document(uid).get();
    this.userDetails=ds.data;
    print(userDetails);
  }

/*   bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static UserDetails of(BuildContext context) {
    UserDetails details = context.dependOnInheritedWidgetOfExactType();
    return details;
  }  */
}