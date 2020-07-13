import 'dart:async';
import 'package:flutter_sms/flutter_sms.dart';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:instant_reporter/common_widgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class NearbyPolice extends StatefulWidget {
  final String userLocation, uid;
  NearbyPolice({@required this.userLocation, this.uid});
  @override
  _NearbyPoliceState createState() =>
      _NearbyPoliceState(userLocation: userLocation);
}

class _NearbyPoliceState extends State<NearbyPolice> {
  Map<String, dynamic> nameAndDistance = Map<String, dynamic>();
  List<dynamic> latitudes = List<dynamic>();
  List<String> phoneNumbers = List<String>();
  List<dynamic> longitudes = List<dynamic>();
  List<dynamic> distance = List<dynamic>();
  LinkedHashMap sortedMap;
  Map<String, bool> checkedListFinal = Map<String, bool>();
  Map<String, String> namesAndPhoneNumber = Map<String, String>();

  final String userLocation;
  String uid;
  var dist;
  _NearbyPoliceState({this.userLocation});
  StreamSubscription _streamSubscription; //n
  Stream _stream = Firestore.instance.collection("registeredUsers").snapshots();
  List<int> selectedBox = List();

  @override
  void initState() {
    print(userLocation);
    _streamSubscription = _stream.listen((event) {
      debugPrint("$event happened?");
    });
    _streamSubscription.onData((data) async {
      for (int i = 0; i < data.documents.length; i++) {
        if (data.documents[i].documentID != widget.uid) {
          if (data.documents[i].data['occupation'] == "Police") {
            print(data.documents[i].data['location'].latitude.toString() +
                ' fffffffff');
            print(data.documents[i].data['location'].longitude.toString());

            String coordinate = userLocation;
            List<String> coordinateList = coordinate.split(", ");
            await Geolocator()
                .distanceBetween(
                    double.parse(coordinateList[0].split(": ")[1]),
                    double.parse(coordinateList[1].split(": ")[1]),
                    data.documents[i].data['location'].latitude,
                    data.documents[i].data['location'].longitude)
                .then((dist) {
              nameAndDistance[data.documents[i].data['name']] = dist;
              namesAndPhoneNumber[data.documents[i].data['name']] =
                  data.documents[i].data['phoneNo'];
            });
          }
        }
      }
      print(nameAndDistance);
      print(namesAndPhoneNumber);
      var sortedKeys = nameAndDistance.keys.toList(growable: false)
        ..sort((k1, k2) => nameAndDistance[k1].compareTo(nameAndDistance[k2]));
      setState(() {
        sortedMap = LinkedHashMap.fromIterable(sortedKeys,
            key: (k) => k, value: (k) => nameAndDistance[k]);
      });

      print(sortedMap);
    });
    super.initState();
  }
//function to send multiple sms

void _sendSMS(String message, List<String> recipents) async {
 String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
print(_result);
}

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Color(backgroundColor),
      child: Container(
        padding: EdgeInsets.only(bottom: 10),
        height: MediaQuery.of(context).size.height * 0.67,
        width: MediaQuery.of(context).size.width * 0.8,
        child: sortedMap != null
            ? Center(
                child: Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(20.0)),
                    Text(
                      "Police Nearby",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          ListView.builder(
                            itemCount: sortedMap.length,
                            itemBuilder: (context, index) {
                              //  checkedListFinal[sortedMap.keys.toList()[index]]=false;
                              // checkedListFinal.values.toList()[index]=false;
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  // color: Color(backgroundColor),

                                  decoration:
                                      BoxDecoration(color: Color(cardColor)),
                                  child: CheckboxListTile(
                                    //  secondary: Icon(Icons.sms,color: Colors.white,),
                                    // contentPadding: EdgeInsets.all(8.0),
                                    title: Text(
                                      sortedMap.keys.toList()[index],
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      sortedMap.values
                                          .toList()[index]
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    value: selectedBox.contains(index),
                                    onChanged: (bool value) {
                                      debugPrint('hello');
                                      setState(() {
                                        if (selectedBox.contains(index)) {
                                          print(selectedBox.contains(index));
                                          selectedBox.remove(index);
                                          checkedListFinal[sortedMap.keys
                                              .toList()[index]] = false;
                                          //  print(checkedListFinal);
                                        } else {
                                          selectedBox.add(index);
                                          checkedListFinal[sortedMap.keys
                                              .toList()[index]] = true;
                                          //   print(checkedListFinal);
                                        }
                                        print(index);
                                      });
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                  ),
                                ),
                              );
                            },
                          ),
                          Align(
                            child: RawMaterialButton(
                              child: Text(
                                'Assign Case',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              fillColor: Colors.red,
                              constraints: BoxConstraints(
                                minWidth: 110,
                                minHeight: 45,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              onPressed: () {
                                setState(() {
                                  for (int i = 0;
                                      i < checkedListFinal.length;
                                      i++) {
                                    if (checkedListFinal[checkedListFinal.keys
                                            .toList()[i]] ==
                                        true) {
                                      phoneNumbers.add(namesAndPhoneNumber[
                                          checkedListFinal.keys.toList()[i]]);
                                      
                                    }
                                  }
                                  String message ='You Have Been Assigned A Case.';
                                  _sendSMS(message, phoneNumbers);
                                  print(phoneNumbers);
                                  print(checkedListFinal);
                                });
                              },
                            ),
                            alignment: Alignment.bottomCenter,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
