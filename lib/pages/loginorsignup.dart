import 'dart:ui';

import 'package:appartapp/pages/google_sign_in_button.dart';
import 'package:appartapp/utils/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginOrSignup extends StatefulWidget {
  @override
  _LoginOrSignupState createState() => _LoginOrSignupState();
}

class _LoginOrSignupState extends State<LoginOrSignup> {
  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.white;
    bool _isLoading = false;

    return Scaffold(
        backgroundColor: bgColor,
        body: ModalProgressHUD(
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Iniziamo!",
                        style: TextStyle(fontSize: 30),
                      )),
                  const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Accedi o crea un account",
                        style: TextStyle(fontSize: 20),
                      )),
                  SignInButton(
                    Buttons.Email,
                    text: "Accedi",
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
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
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text(
                          'Error initializing Firebase',
                          style: TextStyle(color: Colors.black),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return GoogleSignInButton(
                          isLoadingCbk: (bool isLoading) {
                            setState(() {
                              _isLoading = isLoading;
                            });
                          },
                        );
                      }
                      return const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.orange,
                        ),
                      );
                    },
                  ),
                ]),
          ),
          inAsyncCall: _isLoading,
          // demo of some additional parameters
          opacity: 0.5,
          progressIndicator: const CircularProgressIndicator(),
        ));
  }
}