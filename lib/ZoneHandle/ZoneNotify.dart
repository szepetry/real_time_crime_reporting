import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:poly/poly.dart';

class ZoneNotify {
  static Future<void> retrieve() async {
    try {
      CollectionReference zones = Firestore.instance.collection('Zones');

      String uid = await FirebaseAuth.instance
          .currentUser()
          .then<String>((value) => value.uid)
          .catchError((e) => print(e));

      if (uid != null || uid.isNotEmpty) {
        DocumentReference user =
            Firestore.instance.collection('registeredUsers').document(uid);

        Map<String, dynamic> userDetails = await user
            .get()
            .then<Map<String, dynamic>>((value) => value.data)
            .catchError((e) => print(e));
        print(userDetails);
        Position pos = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
            .catchError((e) => print(e));

        List<DocumentSnapshot> zoneList = await zones
            .getDocuments()
            .then<List<DocumentSnapshot>>((value) => value.documents)
            .catchError((e) => print(e));

        if (userDetails['zoneId'].length > 0) {
          Map<String, dynamic> enteredZone = await zones
              .document(userDetails['zoneId'])
              .get()
              .then<Map<String, dynamic>>((value) => value.data)
              .catchError((e) => print(e));
          print('aa');
          if (isPointInZone(enteredZone, pos) == false) {
            bool found = false;
            for (int i = 0; i < zoneList.length; i++) {
              Map<String, dynamic> zoneDocument = zoneList[i].data;
              List<String> zoneDetails = [
                zoneDocument['zoneColor'],
                zoneDocument['notificationMsg']
              ];

              if (isPointInZone(zoneDocument, pos)) {
                if (userDetails['zoneId'] != zoneList[i].documentID) {
                  await user.updateData({
                    'entered': true,
                    'zoneColor': zoneDetails[0],
                    'zoneNotification': zoneDetails[1],
                    'zoneId': zoneList[i].documentID
                  }).catchError((e) => print(e));
                  found = true;
                  break;
                }
              }
            }
            if (found != true) {
              await user
                  .updateData({
                    'entered': false,
                    'zoneColor': "",
                    'zoneNotification': "",
                    'zoneId': ""
                  })
                  .then((value) => null)
                  .catchError((e) => print(e));
            }
          }

/* 
           for (int i = 0; i < zoneList.length; i++) {
          Map<String, dynamic> zoneDocument = zoneList[i].data;
          List<String> zoneDetails = [
            zoneDocument['zoneColor'],
            zoneDocument['notificationMsg']
          ];
          if (isPointInZone(zoneDocument, pos)) {
            if (userDetails['zoneId'] != zoneList[i].documentID) {
              await user.updateData({
                'entered': true,
                'zoneColor': zoneDetails[0],
                'zoneNotification': zoneDetails[1],
                'zoneId': zoneList[i].documentID
              }).catchError((e) => print(e));
              break;
            }
          } else {
            if (userDetails['zoneId'].length > 0) {
              Map<String, dynamic> enteredZone = await zones
                  .document(userDetails['zoneId'])
                  .get()
                  .then<Map<String, dynamic>>((value) => value.data)
                  .catchError((e) => print(e));

              if (isPointInZone(enteredZone, pos) == false) {
                if (userDetails['entered'] == true)
                  await user
                      .updateData({
                        'entered': false,
                        'zoneColor': "",
                        'zoneNotification': "",
                        'zoneId': ""
                      })
                      .then((value) => null)
                      .catchError((e) => print(e));
              }
            }
          } */
        } else {
          bool found = false;
          for (int i = 0; i < zoneList.length; i++) {
            Map<String, dynamic> zoneDocument = zoneList[i].data;
            List<String> zoneDetails = [
              zoneDocument['zoneColor'],
              zoneDocument['notificationMsg']
            ];
            if (isPointInZone(zoneDocument, pos)) {
              await user.updateData({
                'entered': true,
                'zoneColor': zoneDetails[0],
                'zoneNotification': zoneDetails[1],
                'zoneId': zoneList[i].documentID
              }).catchError((e) => print(e));
              found = true;
              break;
            }
          }
          if (found != true)
            await user
                .updateData({
                  'entered': false,
                  'zoneColor': "",
                  'zoneNotification': "",
                  'zoneId': ""
                })
                .then((value) => null)
                .catchError((e) => print(e));
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static bool isPointInZone(Map<String, dynamic> enteredZone, Position pos) {
    try {
      if (enteredZone == null) return false;
      List<Point<num>> polyList = List<Point<num>>();
      for (int i = 0; i < enteredZone.length - 2; i++) {
        polyList.add(Point(
            enteredZone['Point$i'].latitude, enteredZone['Point$i'].longitude));
      }
      Polygon testPolygon = Polygon(polyList);
      return testPolygon.contains(pos.latitude, pos.longitude);
    } catch (e) {
      print(e);
    }
  }
}
