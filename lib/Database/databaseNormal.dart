import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  
  DatabaseService({this.uid});

  int count = 0;

  // collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection('normalUsers');

  Future<void> updateUserData() async {
    return await userCollection.document(uid).setData({
      "case": "some case",
    }, merge: true);
  }

  Stream<QuerySnapshot> get cases{
    return userCollection.snapshots();
  }

}
