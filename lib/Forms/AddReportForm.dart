import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart';
import 'package:sih_app/model/infoObject.dart';
import 'package:sih_app/model/multiInfoObject.dart';
import '../MainPages/FireMap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';

List<dynamic> infoObjs = List<dynamic>();
Position _currentPosition;
//TODO: change count to 1
int count = 0;
bool isLoading = true;
MultiInfoObject _multiInfoObject;

class AddReportForm extends StatefulWidget {
  bool firstLoad;
  AddReportForm(this.firstLoad);

  @override
  _AddReportFormState createState() {
    print("hello" + firstLoad.toString());
    return _AddReportFormState(firstLoad);
  }
}

class _AddReportFormState extends State<AddReportForm> {
  bool firstLoad;
  _AddReportFormState(this.firstLoad);
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  String _fName = '';
  String _lName = '';
  String _phone = '';
  String _email = '';
  String _address = '';
  String _urlAttachmentPhoto = '';
  String _urlAttachmentVideo = '';
  LatLng _location;
  String loc;
  String _description = '';

  String id = "1234";

  @override
  void initState() {
    super.initState();
    // infoObjs.clear();
    print("hello" + firstLoad.toString());
    _getLocation();
    _databaseReference.child(id).onValue.listen((event) {
      count = event.snapshot.value['count'];
      print("Count value: " + count.toString());
    });
    // if(count!=0){
    //   firstLoad=true;
    // }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   int len = infoObjs.length;

  //   // for (int index3 = 0; index3 < len; index3++)
  //     infoObjs.clear();

  //   print("Disposed" + infoObjs.toString());
  //   len = 0;
  // }

  Future<void> _getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      // _location = LatLng(_currentPosition.latitude, _currentPosition.longitude);
    });
  }

  void getReport(id, BuildContext context) {
    try {
      _databaseReference.child(id).once().then((DataSnapshot snapshot) {
        // count = 0;
        print(this.firstLoad);
        print("count value: " + count.toString());
        if (count >= 0) {
          // count = event.snapshot.value['count'];
          for (int index = 0; index < snapshot.value['count']; index++) {
            // print(infoObjs);
            infoObjs.add(snapshot.value['infoObject'][index]);
          }
        }
      });
    } catch (e) {
      print("Get report exception: $e");
    }
  }

  saveReport(BuildContext context) async {
    try {
      bool loadStat = this.firstLoad;
      print("save report state check: $loadStat");
      if (_fName.isNotEmpty ||
          _lName.isNotEmpty ||
          _phone.isNotEmpty ||
          _email.isNotEmpty ||
          _address.isNotEmpty ||
          _urlAttachmentPhoto.isNotEmpty ||
          _urlAttachmentVideo.isNotEmpty ||
          _description.isNotEmpty ||
          _location != null) {
        // infoObjs.clear();
        print("1st $count");

        navigateToLastScreen(context);

        if (loadStat == false) {
          print("1st $count");

          //TODO: make 0 -> 1 here
          // if (count >= 1) {
          getReport(id, context);
          setState(() {
            loadStat = true;
            // isLoading = false;
          });
          // }
        }

        print(_description);
        print(_location);
        print(_urlAttachmentPhoto);
        print(_urlAttachmentVideo);

        //Sleep statement
        print("sleeping for 2 now\n");
        sleep(Duration(seconds: 2));

        InfoObject infoObject = InfoObject(
            fName:this._fName,
            lName:this._lName,
            phone:this._phone,
            email:this._email,
            description: this._description,
            location:_currentPosition.toString(),
            urlAttachmentPhoto:this._urlAttachmentPhoto,
            urlAttachmentVideo:this._urlAttachmentVideo,
            address:this._address);

        infoObjs.add(infoObject.toJson());
        // _multiInfoObject = MultiInfoObject(infoObjs, count);
        // await _databaseReference.child("$id").set(_multiInfoObject.toJson());
          print("The object sent: $infoObjs");

        // infoObjs.clear();
      }
      //  else if (isLoading == true) {
      //   showDialog(
      //       context: context,
      //       builder: (context) {
      //         return AlertDialog(
      //           // title: Text("At least one field required"),
      //           content: CircularProgressIndicator(),
      //         );
      //       });
      // }
      else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("At least one field required"),
                content: Text("Enter at least one field"),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Close")),
                ],
              );
            });
      }
    } catch (e) {
      print("Caught exceptions: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.grey,
      elevation: 6.0,
      child: Container(
        height: MediaQuery.of(context).size.height - 400,
        width: MediaQuery.of(context).size.width - 100,
        child: Center(
          child: ListView(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "Add to the report",
                    style: TextStyle(fontSize: 30.0),
                  )),
              Divider(
                color: Colors.black12,
              ),
              Container(
                margin: EdgeInsets.all(20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                  maxLines: 10,
                  decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: TextStyle(fontSize: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                ),
              ),
              Row(
                //TODO: Add as gesture buttons
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        this.pickVideo();
                      },
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: Container(
                              width: 50.0,
                              height: 50.0,
                              child: Icon(Icons.video_call),
                            ),
                          ),
                          Center(
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: _urlAttachmentVideo,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: 50,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        this.pickImage();
                      },
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: Container(
                              width: 50.0,
                              height: 50.0,
                              child: Icon(Icons.add_a_photo),
                            ),
                          ),
                          Center(
                              child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: _urlAttachmentPhoto),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // BoxDecoration(
              //                   shape: BoxShape.circle,
              //                   image: DecorationImage(
              //                     fit: BoxFit.cover,
              //                     image: _urlAttachmentVideo == "empty"
              //                         ? Icons.add_a_photo
              //                         : NetworkImage(_urlAttachmentVideo),
              //                   ),
              //                 ),
              Padding(padding: EdgeInsets.all(20.0)),
              Center(
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  child: _currentPosition != null
                      ? Text(
                          "Current location: ${_currentPosition.latitude}, ${_currentPosition.longitude}")
                      : CircularProgressIndicator(),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.green,
                  ),
                ),
              ),
              Container(
                // margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                child: RawMaterialButton(
                  // elevation: 2.0,
                  // constraints: BoxConstraints(minHeight: 100,minWidth: 10),
                  fillColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: () {
                    saveReport(context);
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future pickImage() async {
    File file = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 100);
    String fileName = basename(file.path);
    uploadImage(fileName, file);
  }

  Future pickVideo() async {
    File file = await ImagePicker.pickVideo(source: ImageSource.gallery);
    String fileName = basename(file.path);
    uploadVideo(fileName, file);
  }

  void uploadImage(String fileName, File file) {
    StorageReference _storageReference =
        FirebaseStorage.instance.ref().child(fileName);
    _storageReference.putFile(file).onComplete.then((firebaseFile) async {
      var downloadUrl = await firebaseFile.ref.getDownloadURL();
      setState(() {
        _urlAttachmentPhoto = downloadUrl;
      });
    });
  }

  void uploadVideo(String fileName, File file) {
    StorageReference _storageReference =
        FirebaseStorage.instance.ref().child(fileName);
    _storageReference.putFile(file).onComplete.then((firebaseFile) async {
      var downloadUrl = await firebaseFile.ref.getDownloadURL();
      setState(() {
        _urlAttachmentVideo = downloadUrl;
      });
    });
  }

  navigateToLastScreen(BuildContext context) {
    Navigator.pop(context, true);
  }
}
