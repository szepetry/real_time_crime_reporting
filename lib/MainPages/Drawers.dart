import 'package:flutter/material.dart';
import 'package:instant_reporter/AuthenticationHandle/Bailout.dart';

class Drawers extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Bailout b = new Bailout();
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
                title: Text('Delete account'),
                onTap: () async {
                  await  b.confirmBailOutRequest(context,'Are you sure you want to delete your account');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Logout'),
                onTap: () async {
                 await  b.confirmBailOutRequest(context,'Are you sure you want to Log Out?');
                 Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Close App'),
                onTap: () async {
                await b.confirmBailOutRequest(context,'Close the app?');
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