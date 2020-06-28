import 'package:firebase_database/firebase_database.dart';

class InfoObject {
  String _id;
  String _fName;
  String _lName;
  String _phone;
  String _email;
  String _address;
  String _urlAttachmentPhoto;
  String _urlAttachmentVideo;
  String _location;
  String _description;

  InfoObject(
      this._fName,
      this._lName,
      this._phone,
      this._email,
      this._description,
      this._location,
      this._urlAttachmentPhoto,
      this._urlAttachmentVideo,
      this._address);
  InfoObject.withId(
      this._id,
      this._fName,
      this._lName,
      this._phone,
      this._email,
      this._description,
      this._location,
      this._urlAttachmentPhoto,
      this._urlAttachmentVideo,
      this._address);

  InfoObject.fromSnapshot(DataSnapshot snapshot) {
    this._id = snapshot.key;
    this._fName = snapshot.value['fName'];
    this._lName = snapshot.value['lName'];
    this._phone = snapshot.value['phone'];
    this._email = snapshot.value['email'];
    this._address = snapshot.value['address'];
    this._urlAttachmentPhoto = snapshot.value['urlAttachmentPhoto'];
    this._urlAttachmentVideo = snapshot.value['urlAttachmentVideo'];
    this._description = snapshot.value['description'];
    this._location = snapshot.value['location'];
  }

  List<Map<String, dynamic>> toJsonList() {
    return [{
        "fName": _fName,
        "lName": _lName,
        "phone": _phone,
        "email": _email,
        "address": _address,
        "urlAttachmentPhoto": _urlAttachmentPhoto,
        "urlAttachmentVideo": _urlAttachmentVideo,
        "description": _description,
        "location": _location
      },];
  }

  Map<String, dynamic> toJson() {
    return {
      "fName": _fName,
      "lName": _lName,
      "phone": _phone,
      "email": _email,
      "address": _address,
      "urlAttachmentPhoto": _urlAttachmentPhoto,
      "urlAttachmentVideo": _urlAttachmentVideo,
      "description": _description,
      "location": _location
    };
  }

  List<dynamic> addToList(Map<String, dynamic> mapObj) {
    List<dynamic> newList = List<dynamic>();
    newList.add(mapObj);
    return newList;
  }

  //Getters
  String get id => this._id;
  String get fName => this._fName;
  String get lName => this._lName;
  String get phone => this._phone;
  String get email => this._email;
  String get address => this._address;
  String get urlAttachmentPhoto => this._urlAttachmentPhoto;
  String get urlAttachmentVideo => this._urlAttachmentVideo;
  String get description => this._description;
  String get location => this._location;

  //Setters
  set fName(String fName) {
    this._fName = fName;
  }

  set lName(String lName) {
    this._lName = lName;
  }

  set phone(String phone) {
    this._phone = phone;
  }

  set email(String email) {
    this._email = email;
  }

  set address(String address) {
    this._address = address;
  }

  set urlAttactmentPhoto(String urlAttachmentPhoto) {
    this._urlAttachmentPhoto = urlAttachmentPhoto;
  }

  set urlAttactmentVideo(String urlAttachmentVideo) {
    this._urlAttachmentVideo = urlAttachmentVideo;
  }

  set description(String description) {
    this._description = description;
  }

  set location(String location) {
    this._location = location;
  }
}
