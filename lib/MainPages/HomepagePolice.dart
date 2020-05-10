import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomepagePolice extends StatefulWidget {
  final String uid;
  HomepagePolice(this.uid); //use this uid here
  @override
  _HomepagePoliceState createState() => _HomepagePoliceState();
}

class _HomepagePoliceState extends State<HomepagePolice> {
  String uid;

  @override
  void initState() {
    super.initState();
    uid = widget.uid;
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
    return Container();
  }
}
