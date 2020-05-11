import 'package:flutter/material.dart';
import 'package:instant_reporter/app/sign_in/MyAccount.dart';
import 'package:instant_reporter/app/sign_in/SignOut.dart';
import 'package:provider/provider.dart';
import 'package:instant_reporter/app/sign_in/UserDetails.dart';

class Drawers extends StatelessWidget {
  UserDetails userDetails;
  Drawers(this.userDetails);



  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('My Account'),
                decoration: BoxDecoration(
                  image: DecorationImage(fit:BoxFit.contain,image: new AssetImage("assets/images/gonecase.webp"),),
                  shape: BoxShape.rectangle,
                  //color: Colors.white,
                ),
              ),
              ListTile(
                title: Text('My Account'),
                onTap: () {
                  print(userDetails);
                   Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MyAccount(userDetails),
            ),);
                },
              ),
              ListTile(
                title: Text('Helpline Numbers'),
                onTap: () {

                },
              ),
              ListTile(
                title: Text('Logout'),
                onTap: () async {
                  SignOut().confirmSignout(context,'Are you sure you want to Log Out?');
                },
              ),
              ListTile(
                title: Text('Close App'),
                onTap: () async {
                  SignOut().confirmSignout(context,'Close the app?');
                },
              ),
            ],
          ),
        ),
    );

  }
}
/* UserDetails u =Provider.of<UserDetails>(context, listen: false);
                 print(u);
                Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Drawers(u),
            ),); */