import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginOrSignup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.white;

    return Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
            child: Center(
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
                          "Fai il login o crea un account",
                          style: TextStyle(fontSize: 20),
                        )),
                    SignInButton(
                      Buttons.Email,
                      text: "Login",
                      onPressed: () {},
                    ),
                    SignInButton(
                      Buttons.Email,
                      text: "Registrati",
                      onPressed: () {},
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