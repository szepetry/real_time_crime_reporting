import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:instant_reporter/common_widgets/constants.dart';
import 'package:path/path.dart';
import 'package:instant_reporter/model/infoObject.dart';
import 'package:instant_reporter/model/multiInfoObject.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:instant_reporter/common_widgets/notifications.dart';
import '../common_widgets/video_player_widget.dart';

List<dynamic> infoObjs = List<dynamic>();

Position _currentPosition;
int count = 0;
MultiInfoObject _multiInfoObject;

typedef voidCallback = bool Function(bool);

class AddReportForm extends StatefulWidget {
  voidCallback callback;
  bool firstLoad;
  final String id;
  AddReportForm(this.firstLoad, this.id, this.callback);

  @override
  _AddReportFormState createState() {
    print("hello first load: " + firstLoad.toString());
    return _AddReportFormState(firstLoad, id);
  }
}

class _AddReportFormState extends State<AddReportForm> {
  bool firstLoad;
  String id;
  _AddReportFormState(this.firstLoad, this.id);
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  String _fName = '';
  String _lName = '';
  String _phone = '';
  String _email = '';
  String _address = '';
  String _urlAttachmentPhoto = '';
  String _urlAttachmentVideo = '';
  LatLng _location;
  String _description = '';

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
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
        InfoObject infoObject = InfoObject(
            this._fName,
            this._lName,
            this._phone,
            this._email,
            this._description,
            _currentPosition.toString(),
            this._urlAttachmentPhoto,
            this._urlAttachmentVideo,
            this._address,
            DateTime.fromMillisecondsSinceEpoch(
                    DateTime.now().millisecondsSinceEpoch)
                .toString());
        setState(() {
          NotificationManager notificationManager = NotificationManager();
          notificationManager.showNotification(
              sentence: 'Your report has been submitted successfully',
              heading: 'Report',
              priority: priority,
              importance: importance);
        });
        Navigator.pop(context);
        infoObjs.clear();
        if (loadStat == false) {
          print("1st load count: $count");

          await _databaseReference.child("$id").once().then((value) async {
            count = value.value['count'];
            infoObjs.addAll(value.value['infoObject']);
            debugPrint("COunt value $count");
          }).then((value) {
            infoObjs.add(infoObject.toJson());
          }).then((value) async {
            _multiInfoObject = MultiInfoObject(infoObjs, count);
            await _databaseReference
                .child("$id")
                .set(_multiInfoObject.toJson());
            print("The object sent: $infoObjs");
          });

          setState(() {
            loadStat = true;
          });
        } else {
          infoObjs.add(infoObject.toJson());
          _multiInfoObject = MultiInfoObject(infoObjs, count);
          await _databaseReference.child("$id").set(_multiInfoObject.toJson());
          print("The object sent: $infoObjs");
        }

        widget.callback(loadStat);
      } else {
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Color(backgroundColor),
      elevation: 6.0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.60,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Center(
          child: ListView(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "Add to the report",
                    style: TextStyle(fontSize: 30.0, color: Colors.white),
                  )),
              Divider(
                color: Color(cardColor),
              ),
              Container(
                margin: EdgeInsets.all(20.0),
                child: TextField(
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                  maxLines: 10,
                  decoration: InputDecoration(
                      labelText: "Description",
                      // fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white10)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white10)),
                      labelStyle: TextStyle(fontSize: 20, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        this.pickVideo(context);
                      },
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: Container(
                              width: 50.0,
                              height: 50.0,
                              child: Icon(
                                Icons.video_call,
                                color: Colors.white,
                              ),
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
                        this.pickImage(context);
                      },
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: Container(
                              width: 50.0,
                              height: 50.0,
                              child: Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                              ),
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
              Padding(padding: EdgeInsets.all(20.0)),
              Center(
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  child: _currentPosition != null
                      ? Text(
                          "Current location: ${_currentPosition.latitude}, ${_currentPosition.longitude}",
                          style: TextStyle(color: Colors.green))
                      : CircularProgressIndicator(),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Color(cardColor),
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
                  fillColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: () {
                    saveReport(context);
                    // print('clicked!');
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future pickImage(BuildContext context) async {
    await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 100)
        .then((file) {
      String fileName = basename(file.path);
      uploadImage(fileName, file, context);
    });
  }

  Future pickVideo(BuildContext context) async {
    await ImagePicker.pickVideo(source: ImageSource.gallery).then((file) {
      String fileName = basename(file.path);
      uploadVideo(fileName, file, context);
    });
  }

  void uploadImage(String fileName, File file, BuildContext context) async {
    StorageReference _storageReference =
        FirebaseStorage.instance.ref().child("{$id}/images/{$fileName}");
    await _storageReference.putFile(file).onComplete.then((firebaseFile) async {
      await firebaseFile.ref.getDownloadURL().then((url) {
        debugPrint("url picture: " + url);
        setState(() {
          _urlAttachmentPhoto = url;
        });
      }).then((value) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Color(backgroundColor),
              title: Text(
                "Image uploaded",
                style: TextStyle(color: Colors.white),
              ),
              content: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: _urlAttachmentPhoto,
                width: MediaQuery.of(context).size.width * 0.40,
                height: MediaQuery.of(context).size.height * 0.40,
              ),
              actions: <Widget>[
                FlatButton(
                    // color: Colors.red,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Ok", style: TextStyle(color: Colors.white)))
              ],
            );
          },
        );
      });
    });
  }

  void uploadVideo(String fileName, File file, BuildContext context) async {
    StorageReference _storageReference =
        FirebaseStorage.instance.ref().child("{$id}/videos/{$fileName}");
    await _storageReference.putFile(file).onComplete.then((firebaseFile) async {
      await firebaseFile.ref.getDownloadURL().then((url) {
        debugPrint("url video: " + url);
        setState(() {
          _urlAttachmentVideo = url;
        });
      }).then((value) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Color(backgroundColor),
              title:
                  Text("Video uploaded", style: TextStyle(color: Colors.white)),
              content: VideoPlayerWidget(url: _urlAttachmentVideo),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Ok", style: TextStyle(color: Colors.white))),
              ],
            );
          },
        );
      });
    });
  }

  navigateToLastScreen(BuildContext context, bool loadStat) {
    Navigator.pop(context, loadStat);
  }
}
