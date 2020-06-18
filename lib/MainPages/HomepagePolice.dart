import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instant_reporter/AuthenticationHandle/LandingPage.dart';
import 'package:provider/provider.dart';

class HomepagePolice extends StatefulWidget {
  HomepagePolice(); //use this uid here
  @override
  _HomepagePoliceState createState() => _HomepagePoliceState();
}

class _HomepagePoliceState extends State<HomepagePolice> {
  String uid;

  @override
  void initState() {
    super.initState();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    /*  Navigator.push(
        context, MaterialPageRoute(builder: (context) => EmailSignInPage())); */
    //just uncomment the above if u wnt signout to work
    //copy same code in user.dart if u want signout there
    //need to make more changes for sign out..uid u can use for now
    //il delete useless files later
  }

  @override
  Widget build(BuildContext context) {
    UserDetails u = Provider.of<UserDetails>(context, listen: false);
    uid = u.uid;
    return Container(
      child: Center(
        child: FlatButton(onPressed: signOut, child: Text('\tPolice\Touch to Log Out'),color: Colors.indigo[200],),
      ),
    );
  }
}
