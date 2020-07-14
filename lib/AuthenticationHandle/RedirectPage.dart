import 'package:instant_reporter/AuthenticationHandle/SubmitButtons/FormSubmitButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RedirectPage extends StatelessWidget {
  final FirebaseUser user;
  RedirectPage(this.user);

  EdgeInsetsGeometry redirectPadding(BuildContext context) {
    return EdgeInsets.only(
      top: MediaQuery.of(context).size.height * 0.08,
      bottom: MediaQuery.of(context).size.height * 0.7,
      /* left: MediaQuery.of(context).size.width * 0.0,
      right: MediaQuery.of(context).size.width * 0.0, */
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[50],
      child: Padding(
        padding: redirectPadding(context),
        child: Center(
          child: Card(
            // color: Colors.blueGrey[50],
            child: Padding(
              padding: const EdgeInsets.all(9.0),
              child: Column(
                children: <Widget>[
                  Text('Your Account was not found',
                      style: TextStyle(
                        //color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      )),
                  SizedBox(height: 8.0),
                  Text(
                    'Please register',
                    style: TextStyle(
                      //color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  FormSubmitButton(
                    text: 'Go to Register Page',
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
