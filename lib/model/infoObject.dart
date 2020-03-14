import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class InfoObject {
  String id;
  String fName;
  String lName;
  String phone;
  String email;
  String address;
  String urlAttachmentPhoto;
  String urlAttachmentVideo;
  String location;
  String description;

  InfoObject({
      this.fName,
      this.lName,
      this.phone,
      this.email,
      this.description,
      this.location,
      this.urlAttachmentPhoto,
      this.urlAttachmentVideo,
      this.address});
  InfoObject.withId(
      this.id,
      this.fName,
      this.lName,
      this.phone,
      this.email,
      this.description,
      this.location,
      this.urlAttachmentPhoto,
      this.urlAttachmentVideo,
      this.address);

  InfoObject.fromSnapshot(DataSnapshot snapshot) {
    this.id = snapshot.key;
    this.fName = snapshot.value['fName'];
    this.lName = snapshot.value['lName'];
    this.phone = snapshot.value['phone'];
    this.email = snapshot.value['email'];
    this.address = snapshot.value['address'];
    this.urlAttachmentPhoto = snapshot.value['urlAttachmentPhoto'];
    this.urlAttachmentVideo = snapshot.value['urlAttachmentVideo'];
    this.description = snapshot.value['description'];
    this.location = snapshot.value['location'];
  }

  List<Map<String, dynamic>> toJsonList() {
    return [{
        "fName": fName,
        "lName": lName,
        "phone": phone,
        "email": email,
        "address": address,
        "urlAttachmentPhoto": urlAttachmentPhoto,
        "urlAttachmentVideo": urlAttachmentVideo,
        "description": description,
        "location": location
      },];
  }

  Map<String, dynamic> toJson() {
    return {
      "fName": fName,
      "lName": lName,
      "phone": phone,
      "email": email,
      "address": address,
      "urlAttachmentPhoto": urlAttachmentPhoto,
      "urlAttachmentVideo": urlAttachmentVideo,
      "description": description,
      "location": location
    };
  }

  List<dynamic> addToList(InfoObject mapObj) {
    List<dynamic> newList = List<dynamic>();
    newList.add(mapObj);
    return newList;
  }

  //Getters
  String get Id => this.id;
  String get FName => this.fName;
  String get LName => this.lName;
  String get Phone => this.phone;
  String get Email => this.email;
  String get Address => this.address;
  String get UrlAttachmentPhoto => this.urlAttachmentPhoto;
  String get UrlAttachmentVideo => this.urlAttachmentVideo;
  String get Description => this.description;
  String get Location => this.location;

  //Setters
  set FName(String fName) {
    this.fName = fName;
  }

  set LName(String lName) {
    this.lName = lName;
  }

  set Phone(String phone) {
    this.phone = phone;
  }

  set Email(String email) {
    this.email = email;
  }

  set Address(String address) {
    this.address = address;
  }

  set UrlAttactmentPhoto(String urlAttachmentPhoto) {
    this.urlAttachmentPhoto = urlAttachmentPhoto;
  }

  set UrlAttactmentVideo(String urlAttachmentVideo) {
    this.urlAttachmentVideo = urlAttachmentVideo;
  }

  set Description(String description) {
    this.description = description;
  }

  set Location(String location) {
    this.location = location;
  }
}
