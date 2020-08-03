import 'package:firebase_database/firebase_database.dart';
import 'dart:core';

class InfoObject {
  String _id;
  String _urlAttachmentPhoto;
  String _urlAttachmentVideo;
  String _location;
  String _description;
  String _dateTime;  

  InfoObject(
      this._description,
      this._location,
      this._urlAttachmentPhoto,
      this._urlAttachmentVideo,
      this._dateTime);
  InfoObject.withId(
      this._id,
      this._description,
      this._location,
      this._urlAttachmentPhoto,
      this._urlAttachmentVideo,
      this._dateTime);

  InfoObject.fromSnapshot(DataSnapshot snapshot) {
    this._id = snapshot.key;
    this._urlAttachmentPhoto = snapshot.value['urlAttachmentPhoto'];
    this._urlAttachmentVideo = snapshot.value['urlAttachmentVideo'];
    this._description = snapshot.value['description'];
    this._location = snapshot.value['location'];
    this._dateTime = snapshot.value['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    return {
      "urlAttachmentPhoto": _urlAttachmentPhoto,
      "urlAttachmentVideo": _urlAttachmentVideo,
      "description": _description,
      "location": _location,
      "timeStamp": _dateTime
    };
  }

  //Getters
  String get id => this._id;
  String get urlAttachmentPhoto => this._urlAttachmentPhoto;
  String get urlAttachmentVideo => this._urlAttachmentVideo;
  String get description => this._description;
  String get location => this._location;
  String get dateTime => this._dateTime;

  //Setters
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

  set dateTime(String dateTime) {
    this._dateTime = dateTime;
  }
}
