import 'dart:ui';

import 'package:appartapp/classes/enum_loginresult.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/pages/loading.dart';
import 'package:appartapp/utils/authentication.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:appartapp/classes/user.dart' as AppUser;
import 'package:firebase_auth/firebase_auth.dart' as Fb;
import 'package:shared_preferences/shared_preferences.dart';

class LoginOrSignup extends StatelessWidget {
  String urlStr = "http://172.20.10.4:8080/appartapp_war_exploded/api/login";

  Future<List> signIn(Fb.User user) async {
    String idToken = await user.getIdToken();
    var dio = RuntimeStore().dio;
    try {
      Response response = await dio.post(
        urlStr,
        data: {"idtoken": idToken},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode != 200) {
        if (response.statusCode == 401)
          return [null, LoginResult.wrong_credentials];
        else
          return [null, LoginResult.server_error];
      }
      else {
        Map responseMap = response.data;
        AppUser.User user = AppUser.User.fromMap(responseMap);

        return [user, LoginResult.ok];
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401)
        return [null, LoginResult.wrong_credentials];
      else
        return [null, LoginResult.server_error];
    }
  }


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
                  onPressed: () {
                    Navigator.pushNamed(context, '/googlesignup');
/*
                    Fb.User? gUser =
                    await Authentication.signInWithGoogle(context: context);

                    if (gUser != null) {
                      List res = await signIn(gUser);
                      AppUser.User appUser = res[0];
                      LoginResult loginResult = res[1];
                      switch (loginResult) {
                        case LoginResult.ok:
                          doInitialisation(context, appUser, RuntimeStore()
                              .getSharedPreferences() as SharedPreferences);
                          break;
                      //TODO implement other case
                      }
                    }*/
                  },
                )
              ]),
        ));
  }
}