import 'dart:ui';

import 'package:appartapp/pages/google_sign_in_button.dart';
import 'package:appartapp/utils/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginOrSignup extends StatefulWidget {
  @override
  _LoginOrSignupState createState() => _LoginOrSignupState();
}

class _LoginOrSignupState extends State<LoginOrSignup> {
  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.white;

    return Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Iniziamo!",
                      style: TextStyle(fontSize: 30),
                    )),
                Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Accedi o crea un account",
                      style: TextStyle(fontSize: 20),
                    )),
                SignInButton(
                  Buttons.Email,
                  text: "Accedi",
                  onPressed: () {
                    Navigator.pushNamed(context, '/googlesignup');
                  },
                ),
                SignInButton(
                  Buttons.Email,
                  text: "Registrati",
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                ),
                FutureBuilder(
                  future: Authentication.initializeFirebase(),
                  //TODO (context: context),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        'Error initializing Firebase',
                        style: TextStyle(color: Colors.black),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return GoogleSignInButton();
                    }
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.orange,
                      ),
                    );
                  },
                ),
              ]),
        ));
  }
}