import 'package:appartapp/utils_classes/google_authentication.dart';
import 'package:appartapp/widgets/google_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginOrSignup extends StatefulWidget {
  const LoginOrSignup({Key? key}) : super(key: key);

  @override
  _LoginOrSignupState createState() => _LoginOrSignupState();
}

class _LoginOrSignupState extends State<LoginOrSignup> {
  bool _isLoading = false;
  bool _firebaseError = false;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _firebaseError = false;
    GoogleAuthentication.initializeFirebase()
        .then((value) {})
        .onError((error, stackTrace) {
      setState(() {
        _firebaseError = true;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.white;

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
                  _firebaseError
                      ? const Text(
                          'Error initializing Firebase',
                          style: TextStyle(color: Colors.black),
                        )
                      : GoogleSignInButton(
                          isLoadingCbk: (bool isLoading) {
                            if (isLoading != _isLoading) {
                              setState(() {
                                _isLoading = isLoading;
                              });
                            }
                          },
                          parentContext: context,
                        )
                ]),
          ),
          inAsyncCall: _isLoading,
          // demo of some additional parameters
          opacity: 0.5,
          progressIndicator: const CircularProgressIndicator(),
        ));
  }
}