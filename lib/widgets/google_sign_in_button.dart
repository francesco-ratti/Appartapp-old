import 'package:appartapp/entities/user.dart' as AppUser;
import 'package:appartapp/enums/enum_loginresult.dart';
import 'package:appartapp/exceptions/connection_exception.dart';
import 'package:appartapp/model/login_handler.dart';
import 'package:appartapp/pages/loading.dart';
import 'package:appartapp/utils_classes/google_authentication.dart';
import 'package:appartapp/utils_classes/runtime_store.dart';
import 'package:appartapp/widgets/error_dialog_builder.dart';
import 'package:firebase_auth/firebase_auth.dart' as Fb;
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GoogleSignInButton extends StatefulWidget {
  final BuildContext parentContext;
  final Function(bool) isLoadingCbk;

  const GoogleSignInButton(
      {Key? key, required this.isLoadingCbk, required this.parentContext})
      : super(key: key);

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
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

          List? resG =
          await GoogleAuthentication.signInWithGoogle(context: context);

          if (resG != null) {
            Fb.User? gUser = resG[0];
            String accessToken = resG[1];

            try {
              List res = await LoginHandler.doLoginWithGoogleToken(
                  gUser!, accessToken);
              LoginResult loginResult = res[1];
              switch (loginResult) {
                case LoginResult.ok:
                  AppUser.User appUser = res[0];
                  RuntimeStore()
                      .getSharedPreferences()
                      ?.setBool("credentialslogin", false);
                  RuntimeStore().setCredentialsLogin(false);
                  doInitialisation(
                      widget.parentContext,
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
          } else {
            widget.isLoadingCbk(false);
            Navigator.restorablePush(
                context, ErrorDialogBuilder.buildGenericConnectionErrorRoute);
          }
        },
      ),
    );
  }
}