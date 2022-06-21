import 'package:appartapp/pages/loading.dart';
import 'package:appartapp/classes/user.dart';
import 'package:appartapp/classes/credentials.dart';
import 'package:appartapp/classes/enum_loginresult.dart';
import 'package:flutter/material.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/login_handler.dart';

class Login extends StatefulWidget {
  String urlStr = "http://192.168.20.108:8080/appartapp_war_exploded/api/login";
  Color bgColor = Colors.white;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void doLogin(Function(String) updateUi, String email, String password) async {
    List res = await LoginHandler.doLogin(email, password);

    User user = res[0];
    LoginResult loginResult = res[1];
    switch (loginResult) {
      case LoginResult.ok:
        doInitialisation(context, user, RuntimeStore().getSharedPreferences() as SharedPreferences);
        break;
      case LoginResult.wrong_credentials:
        updateUi("Credenziali errate");
        break;
      case LoginResult.server_error:
        updateUi("internal server error");
        break;
      default:
        updateUi("Errore");
        break;
    }
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String status = "Not submitted yet";

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        appBar: AppBar(
          title: const Text('Accedi'),
          backgroundColor: Colors.brown,
        ),
        backgroundColor: widget.bgColor,
        body: Center(
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
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Inserisci le tue credenziali",
                    style: TextStyle(fontSize: 20),
                  )),
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    status,
                    style: TextStyle(fontSize: 20),
                  )),
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-Mail',
                    ),
                    controller: emailController,
                  )),
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  )),
              ElevatedButton(
                  child: Text("Accedi"),
                  style: ElevatedButton.styleFrom(primary: Colors.brown),
                  onPressed: () {
                    String email = emailController.text;
                    String password = passwordController.text;

                    doLogin((String toWrite) {
                      setState(() {
                        status = toWrite;
                      });
                    }, email, password);
                  })
            ]))));
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
