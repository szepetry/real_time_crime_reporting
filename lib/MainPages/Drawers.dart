import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:instant_reporter/AuthenticationHandle/Bailout.dart';
import 'package:instant_reporter/AuthenticationHandle/LandingPage.dart';
import 'package:instant_reporter/ZoneHandle/ZoneNotify.dart';
import 'package:instant_reporter/ZoneHandle/ZoneUploadHandle/ZoneMaps.dart';

class Drawers extends StatefulWidget {
  final bool isPolice;
  UserDetails u;
  Drawers(this.isPolice, this.u);

  @override
  _DrawersState createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  bool get isPolice => widget.isPolice;
  Bailout b = new Bailout();

  Widget addZonesOptionWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.add),
          title: Text(
            'Add Zones',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          subtitle: Text('Add new zones for users'),
          onTap: () async {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ZoneMap.create(context),
            ));
          },
        ),
        SizedBox(
          child: Divider(
            thickness: 1,
          ),
        ),
      ],
    );
  }

/* 
  @override
  void initState() {
    super.initState();
    try {
      widget.u.subscribedZoneNotifications = widget.prefs.getBool('subscribed');
    } catch (e) {
      widget.u.subscribedZoneNotifications = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    try {
      widget.prefs.setBool('subscribed', widget.u.subscribedZoneNotifications);
    } catch (e) {
      widget.u.subscribedZoneNotifications = false;
    }
  }
 */
  Widget deleteAccountWidget(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.delete),
      title: Text(
        'Delete account',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
      ),
      subtitle: Text('Deletes current account'),
      onTap: () async {
        await b.confirmBailOutRequest(
            context, 'Are you sure you want to delete your account');
        Navigator.of(context).pop();
      },
    );
  }

  Widget closeAppWidget(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.close),
      title: Text(
        'Close App',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      subtitle: Text('Closes the app'),
      onTap: () async {
        await b.confirmBailOutRequest(context, 'Close the app?');
      },
    );
  }

  Widget logOutWidget(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.chevron_right),
      title: Text(
        'Logout',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      subtitle: Text('Sign Out from the app'),
      onTap: () async {
        await b.confirmBailOutRequest(
            context, 'Are you sure you want to Log Out?');
        Navigator.of(context).pop();
      },
    );
  }

  Widget headerAvatar(double height) {
    return Center(
      child: Column(
        children: <Widget>[
          //Icon(Icons.person, size: height * 0.12),
          Material(
              borderRadius: BorderRadius.all(Radius.circular(70)),
              child: GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    widget.u.isMale = !widget.u.isMale;
                  });
                },
                child: Image.asset(
                  ascertainImage(),
                  width: height * 0.114,
                  height: height * 0.114,
                ),
              )),
          SizedBox(
            height: height * 0.01,
          ),
          Text(
            isPolice ? 'Police User' : 'Civilian User',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  String ascertainImage() {
    switch (isPolice) {
      case true:
        {
          switch (widget.u.isMale) {
            case true:
              {
                return 'assets/images/police.png';
              }
              break;
            case false:
              {
                return 'assets/images/policewoman.png';
              }
              break;
            default:
              return 'assets/images/user.png';
          }
        }
        break;
      case false:
        {
          switch (widget.u.isMale) {
            case true:
              {
                return 'assets/images/person.png';
              }
              break;
            case false:
              {
                return 'assets/images/person_female.png';
              }
              break;
            default:
              return 'assets/images/user.png';
          }
        }
        break;
      default:
        return 'assets/images/user.png';
    }
  }

  Widget drawerHeaderWidget(double height) {
    return DrawerHeader(
        decoration: BoxDecoration(
          /* boxShadow: <BoxShadow>[
            BoxShadow(blurRadius: 10, color: Colors.black26)
          ], */
          gradient: LinearGradient(
              colors: <Color>[Colors.deepOrange, Colors.yellowAccent[400]]),
          shape: BoxShape.rectangle,
          //color: Colors.white,
        ),
        child: headerAvatar(height));
  }

  Widget subscribeZoneNotifications() {
    return widget.u.subscribedZoneNotifications
        ? ListTile(
            leading: Icon(Icons.remove_circle),
            title: Text(
              'Disable Zone Notifications',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            subtitle: Text('Disable zone entry updates'),
            onTap: () {
              AndroidAlarmManager.cancel(0);
              setState(() {
                widget.u.subscribedZoneNotifications =
                    !widget.u.subscribedZoneNotifications;
              });
            },
          )
        : ListTile(
            leading: Icon(Icons.add_alert),
            title: Text(
              'Subscribe Zone Notifications',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            subtitle: Text('Disable zone entry updates'),
            onTap: () {
              AndroidAlarmManager.initialize();
              AndroidAlarmManager.periodic(
                  const Duration(seconds: 10), 0, ZoneNotify.retrieve);
              setState(() {
                widget.u.subscribedZoneNotifications =
                    !widget.u.subscribedZoneNotifications;
              });
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            drawerHeaderWidget(height),
            SizedBox(height: 2),
            subscribeZoneNotifications(),
            SizedBox(child: Divider(thickness: 1)),
            isPolice ? addZonesOptionWidget(context) : SizedBox(),
            logOutWidget(context),
            SizedBox(child: Divider(thickness: 1)),
            closeAppWidget(context),
            SizedBox(child: Divider(thickness: 1)),
            deleteAccountWidget(context),
            SizedBox(child: Divider(thickness: 1)),
          ],
        ),
      ),
    );
  }
}

class DrawersIconState {
  bool isMale = true;
}

/* UserDetails u =Provider.of<UserDetails>(context, listen: false);
                 print(u);
                Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Drawers(u),
            ),); */
