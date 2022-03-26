import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginOrSignup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.white;

    return MaterialApp(
        home: Scaffold(
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
                      text: "Accedi tramite e-mail",
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                    SignInButton(
                      Buttons.Email,
                      text: "Registrati tramite e-mail",
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                    ),
                    SignInButton(
                      Buttons.Google,
                      text: "Sign up with Google",
                      onPressed: () {},
                    )
                  ]),
            )));
  }
}