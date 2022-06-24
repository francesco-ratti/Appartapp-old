import 'package:appartapp/classes/enum_loginresult.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/classes/user.dart' as AppUser;
import 'package:appartapp/pages/loading.dart';
import 'package:appartapp/utils/authentication.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as Fb;
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInButton extends StatefulWidget {
  String urlStr = "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/login";

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();

  Future<List> signIn(Fb.User user, String accessToken) async {
    String idToken = await user.getIdToken();
    var dio = RuntimeStore().dio;
    try {
      Response response = await dio.post(
        urlStr,
        data: {
          "idtoken": idToken,
          "accesstoken": accessToken
        },
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
          : SignInButton(
              Buttons.Google,
              text: "Accedi con Google",
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });

                List? resG =
                    await Authentication.signInWithGoogle(context: context);

                setState(() {
                  _isSigningIn = false;
                });

                if (resG != null) {
            Fb.User? gUser = resG[0];
            String accessToken=resG[1];

            List res=await widget.signIn(gUser!, accessToken);
            LoginResult loginResult=res[1];
            switch (loginResult) {
              case LoginResult.ok:
                AppUser.User appUser=res[0];
                doInitialisation(context, appUser, RuntimeStore().getSharedPreferences() as SharedPreferences);
                break;
                //TODO implement other case
            }
          }
        },
      ),
    );
  }
}