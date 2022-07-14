import 'package:appartapp/classes/connection_exception.dart';
import 'package:appartapp/classes/enum_loginresult.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/classes/user.dart' as app_user;
import 'package:appartapp/utils/authentication.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginOrSignup extends StatefulWidget {
  final String urlStr =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/login";

  const LoginOrSignup({Key? key}) : super(key: key);

  @override
  _LoginOrSignupState createState() => _LoginOrSignupState();

  Future<List> signIn(fb.User user, String accessToken) async {
    String idToken = await user.getIdToken();
    var dio = RuntimeStore().dio; //ok
    try {
      Response response = await dio.post(
        urlStr,
        data: {"idtoken": idToken, "accesstoken": accessToken},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode != 200) {
        if (response.statusCode == 401) {
          return [null, LoginResult.wrong_credentials];
        } else {
          return [null, LoginResult.server_error];
        }
      } else {
        Map responseMap = response.data;
        app_user.User user = app_user.User.fromMap(responseMap);

        return [user, LoginResult.ok];
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.other ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.cancel) {
        throw ConnectionException();
      }
      if (e.response?.statusCode == 401) {
        return [null, LoginResult.wrong_credentials];
      }
      return [null, LoginResult.server_error];
    }
  }
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
                        return SignInButton(
                          Buttons.Google,
                          text: "Accedi con Google",
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
/*

                            await Future.delayed(Duration(seconds: 1));

                            List? resG = await Authentication.signInWithGoogle(context: context);

                            setState(() {
                              _isLoading=true;
                            });

                            if (resG != null) {
                              fb.User? gUser = resG[0];
                              String accessToken = resG[1];

                              try {
                                List res = await widget.signIn(gUser!, accessToken);
                                LoginResult loginResult = res[1];
                                switch (loginResult) {
                                  case LoginResult.ok:
                                    app_user.User appUser = res[0];
                                    RuntimeStore()
                                        .getSharedPreferences()
                                        ?.setBool("credentialslogin", false);
                                    RuntimeStore().setCredentialsLogin(false);
                                    doInitialisation(
                                        context,
                                        appUser,
                                        RuntimeStore().getSharedPreferences()
                                        as SharedPreferences);
                                    break;
                                  case LoginResult.network_fail:
                                    setState(() {
                                      _isLoading=false;
                                    });
                                    Navigator.restorablePush(
                                        context, ErrorDialogBuilder.buildConnectionErrorRoute);
                                    break;
                                  case LoginResult.wrong_credentials:
                                    setState(() {
                                      _isLoading=false;
                                    });
                                    Navigator.restorablePush(
                                        context, ErrorDialogBuilder.buildCredentialsErrorRoute);
                                    break;
                                  case LoginResult.server_error:
                                    setState(() {
                                      _isLoading=false;
                                    });
                                    Navigator.restorablePush(context,
                                        ErrorDialogBuilder.buildGenericConnectionErrorRoute);
                                    break;
                                }
                              } on ConnectionException {
                                setState(() {
                                  _isLoading=false;
                                });
                                Navigator.restorablePush(
                                    context, ErrorDialogBuilder.buildConnectionErrorRoute);
                              }
                            } else {
                              setState(() {
                                _isLoading=false;
                              });
                              Navigator.restorablePush(
                                  context, ErrorDialogBuilder.buildGenericConnectionErrorRoute);
                            }*/
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