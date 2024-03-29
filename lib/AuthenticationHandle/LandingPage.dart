import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instant_reporter/AuthenticationHandle/RedirectPage.dart';
import 'package:instant_reporter/AuthenticationHandle/StateNotifiers/Authenticate.dart';
import 'package:instant_reporter/AuthenticationHandle/LoginPage.dart';
import 'package:instant_reporter/AuthenticationHandle/StateNotifiers/FirestoreService.dart';
import 'package:instant_reporter/AuthenticationHandle/StateNotifiers/RegisterPageNotifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instant_reporter/AuthenticationHandle/RegisterPage.dart';
import 'package:instant_reporter/MainPages/Police/HomepagePolice.dart';
import 'package:instant_reporter/MainPages/User/HomepageUser.dart';
import 'package:provider/provider.dart';


class LandingPage extends StatelessWidget {
  final RegisterPageNotifier registerHandle;
  final Authenticate auth;
  LandingPage(this.registerHandle, this.auth);

  static Widget create(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RegisterPageNotifier>(
          create: (context) => RegisterPageNotifier(),
        ),
        ChangeNotifierProvider<Authenticate>(
          create: (context) => Authenticate(context),
        ),
      ],
      child: Consumer2<RegisterPageNotifier, Authenticate>(
        builder: (context, registerHandle, auth, properties) =>
            LandingPage(registerHandle, auth),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: Authenticate.currentAuthState,
      builder: (context, authSnapshot) {
        print('Auth state rebuild..auth value:' + authSnapshot.data.toString());
        if (authSnapshot.data == null) {
          if (registerHandle.loginMode == true)
            return LoginPage(registerHandle, auth);
          else
            return RegisterPage(registerHandle, auth);
        } else if (authSnapshot.data != null) {
          auth.isLoadingController.add(false);
          return handleNavigation(authSnapshot);
        } else
          return Center(child:CircularProgressIndicator());
      },
    );
  }

  StreamBuilder<DocumentSnapshot> handleNavigation(
      AsyncSnapshot<FirebaseUser> authSnapshot) {
    String uid = authSnapshot.data.uid;
    if (auth.isNewUser == true)
      registerHandle
          .newUserUpdate(uid); //await fn so cant put outside if-else statement
    auth.isNewUser = false;
    registerHandle.clearControllers();
    return userTypeStream(uid, authSnapshot.data);
  }

  StreamBuilder<DocumentSnapshot> userTypeStream(
      String uid, FirebaseUser user) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirestoreService.registeredUserStream(uid),
      builder: (context, firestoreSnapshot) {
        print('Auth state rebuild..auth value:' +
            firestoreSnapshot.data.toString());
        if (firestoreSnapshot.hasData) {
          if (firestoreSnapshot.data.data == null)
            return RedirectPage(user);
          else if (firestoreSnapshot.data['occupation'] != 'Police')
            return Provider<UserDetails>(
                create: (context) => UserDetails(uid), child: HomepageUser());
          else if (firestoreSnapshot.data['occupation'] == 'Police')
            return Provider<UserDetails>(
                create: (context) => UserDetails(uid), child: HomepagePolice());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class UserDetails {
  String uid;
  bool isMale = true;
  bool subscribedZoneNotifications = false;
  UserDetails(this.uid);
  String get getUid => this.uid;
}
