class ZoneInfo{
  String zoneColor;
  String zoneDetails;
  bool cancel=false;
  ZoneInfo(this.zoneColor,this.zoneDetails);
  set setZoneColor(String color) => this.zoneColor = color;
  set setZoneDetails(String details) => this.zoneDetails = details;

  Map<String,dynamic> get zoneUpdateObject => {
    'zoneColor':this.zoneColor,
    'notificationMsg':this.zoneDetails
  };
}