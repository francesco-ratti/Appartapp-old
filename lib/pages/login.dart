import 'package:appartapp/classes/connection_exception.dart';
import 'package:appartapp/classes/enum_loginresult.dart';
import 'package:appartapp/classes/login_handler.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/classes/user.dart';
import 'package:appartapp/pages/loading.dart';
import 'package:appartapp/widgets/error_dialog_builder.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  final String urlStr =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/login";
  final Color bgColor = Colors.white;

  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;

  void doLogin(Function(String) updateUi, String email, String password) async {
    try {
      List res = await LoginHandler.doLogin(email, password);
      LoginResult loginResult = res[1];
      switch (loginResult) {
        case LoginResult.ok:
          User user = res[0];
          SharedPreferences sharedPreferences =
              RuntimeStore().getSharedPreferences() as SharedPreferences;

          sharedPreferences.setBool("credentialslogin", true);
          RuntimeStore().credentialsLogin = true;

          doInitialisation(context, user, sharedPreferences);
          break;
        case LoginResult.wrong_credentials:
          setState(() {
            _isLoading = false;
          });
          updateUi("Credenziali errate");
          break;
        case LoginResult.server_error:
          setState(() {
            _isLoading = false;
          });
          Navigator.restorablePush(
              context, ErrorDialogBuilder.buildGenericErrorRoute);
          break;
        default:
          setState(() {
            _isLoading = false;
          });
          Navigator.restorablePush(
              context, ErrorDialogBuilder.buildGenericConnectionErrorRoute);
          break;
      }
    } on ConnectionException {
      setState(() {
        _isLoading = false;
      });
      Navigator.restorablePush(
          context, ErrorDialogBuilder.buildGenericConnectionErrorRoute);
    }
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String status = "";

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: const Text('Accedi'),
        backgroundColor: Colors.brown,
      ),
      backgroundColor: widget.bgColor,
      body: ModalProgressHUD(
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              /*
          const SimpleTextField(
            labelText: 'E-Mail',
            showLabelAboveTextField: true,
            textColor: Colors.black,
            accentColor: Colors.green,
          ),
          const SimpleTextField(
            labelText: 'Password',
            showLabelAboveTextField: true,
            textColor: Colors.black,
            accentColor: Colors.green,
          ),

           */
                  const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Inserisci le tue credenziali",
                    style: TextStyle(fontSize: 20),
                  )),
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                  child: Text(
                    status,
                    style: const TextStyle(fontSize: 20),
                  )),
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    obscureText: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-Mail',
                    ),
                    controller: emailController,
                  )),
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  )),
                    ElevatedButton(
                        child: const Text("Accedi"),
                  style: ElevatedButton.styleFrom(primary: Colors.brown),
                  onPressed: () {
                    String email = emailController.text;
                    String password = passwordController.text;

                    setState(() {
                      _isLoading = true;
                    });

                    doLogin((String toWrite) {
                      setState(() {
                        status = toWrite;
                      });
                    }, email, password);
                  })
            ])),
        inAsyncCall: _isLoading,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: const CircularProgressIndicator(),
      ),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
