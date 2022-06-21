import 'package:appartapp/classes/enum_loginresult.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/classes/user.dart' as AppUser;
import 'package:firebase_auth/firebase_auth.dart' as Fb;

import 'package:appartapp/pages/loading.dart';
import 'package:appartapp/utils/authentication.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInButton extends StatefulWidget {
  String urlStr = "http://192.168.20.108:8080/appartapp_war_exploded/api/login";

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();

  Future<List> signIn(Fb.User user) async {
    String idToken=await user.getIdToken();
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
          return [null,LoginResult.wrong_credentials];
        else
          return [null,LoginResult.server_error];
      }
      else {
        Map responseMap = response.data;
        AppUser.User user=AppUser.User.fromMap(responseMap);

        return [user, LoginResult.ok];
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401)
        return [null, LoginResult.wrong_credentials];
      else
        return [null, LoginResult.server_error];
    }
  }
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      )
          : OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
        onPressed: () async {
          setState(() {
            _isSigningIn = true;
          });

          Fb.User? gUser =
          await Authentication.signInWithGoogle(context: context);

          setState(() {
            _isSigningIn = false;
          });

          if (gUser != null) {
            List res=await widget.signIn(gUser);
            AppUser.User appUser=res[0];
            LoginResult loginResult=res[1];
            switch (loginResult) {
              case LoginResult.ok:
                doInitialisation(context, appUser, RuntimeStore().getSharedPreferences() as SharedPreferences);
                break;
                //TODO implement other case
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("assets/google_logo.png"),
                height: 35.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}