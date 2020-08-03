

import 'package:flutter/material.dart';


class ZoneDetailsNotifier with ChangeNotifier{
 String zoneColor='Red';
  bool isTextEmpty;
  String zoneDetailsInput='';
  TextEditingController zoneTextController = TextEditingController();
  
  set setZoneColor(String color) {
    zoneColor=color;
    notifyListeners();
  }

  set setZoneDetails(String details){
    zoneDetailsInput=details;
    notifyListeners();
  }

  bool get isFieldEmpty => zoneDetailsInput.isNotEmpty;
  String get getZoneColor => this.zoneColor;
  String get getZoneDetailsInput => this.zoneDetailsInput;

}
