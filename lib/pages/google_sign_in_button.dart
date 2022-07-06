import 'package:appartapp/classes/connection_exception.dart';
import 'package:appartapp/classes/enum_loginresult.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/classes/user.dart' as AppUser;
import 'package:appartapp/pages/loading.dart';
import 'package:appartapp/utils/authentication.dart';
import 'package:appartapp/widgets/error_dialog_builder.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as Fb;
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInButton extends StatefulWidget {
  final String urlStr =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/login";
  final Function(bool) isLoadingCbk;

  const GoogleSignInButton({Key? key, required this.isLoadingCbk})
      : super(key: key);

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();

  Future<List> signIn(Fb.User user, String accessToken) async {
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
      }
      else {
        Map responseMap = response.data;
        AppUser.User user=AppUser.User.fromMap(responseMap);

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

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SignInButton(
        Buttons.Google,
        text: "Accedi con Google",
        onPressed: () async {
          widget.isLoadingCbk(true);

          List? resG = await Authentication.signInWithGoogle(context: context);

          if (resG != null) {
            Fb.User? gUser = resG[0];
            String accessToken = resG[1];

            try {
              List res = await widget.signIn(gUser!, accessToken);
              LoginResult loginResult = res[1];
                    switch (loginResult) {
                      case LoginResult.ok:
                        AppUser.User appUser = res[0];
                        doInitialisation(
                            context,
                            appUser,
                            RuntimeStore().getSharedPreferences()
                                as SharedPreferences);
                        break;
                      case LoginResult.network_fail:
                        widget.isLoadingCbk(false);
                  Navigator.restorablePush(
                      context, ErrorDialogBuilder.buildConnectionErrorRoute);
                  break;
                case LoginResult.wrong_credentials:
                        widget.isLoadingCbk(false);
                  Navigator.restorablePush(
                      context, ErrorDialogBuilder.buildCredentialsErrorRoute);
                  break;
                case LoginResult.server_error:
                        widget.isLoadingCbk(false);
                  Navigator.restorablePush(context,
                      ErrorDialogBuilder.buildGenericConnectionErrorRoute);
                  break;
              }
                  } on ConnectionException {
              widget.isLoadingCbk(false);
              Navigator.restorablePush(
                  context, ErrorDialogBuilder.buildConnectionErrorRoute);
            }
                }
              },
      ),
    );
  }
}