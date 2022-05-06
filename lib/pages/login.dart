import 'package:appartapp/classes/User.dart';
import 'package:appartapp/classes/apartment.dart';
import 'package:appartapp/classes/credentials.dart';
import 'package:appartapp/classes/enum%20LoginResult.dart';
import 'package:flutter/material.dart';
import 'package:appartapp/classes/apartment_handler.dart';

//import './../SimpleTextField.dart';
import 'package:appartapp/classes/runtime_store.dart';

import '../classes/login_handler.dart';

class Login extends StatefulWidget {
  String urlStr = "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/login";
  Color bgColor = Colors.white;


  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void doLogin(Function(String) updateUi, String email, String password) async {
    List res = await LoginHandler.doLogin(email, password);

    Credentials credentials = res[0];
    User user=res[1];
    LoginResult loginResult = res[2];
    switch (loginResult) {
      case LoginResult.ok:
        RuntimeStore().setCredentials(credentials);
        RuntimeStore().setUser(user);

        RuntimeStore().getSharedPreferences()?.setString("email", credentials.email);
        RuntimeStore().getSharedPreferences()?.setString("password", credentials.password);

        Apartment firstApartment = await ApartmentHandler().getNewApartment(
                (Apartment apartment) {
              for (final Image im in apartment.images) {
                precacheImage(im.image, context);
              }
            });

        Future<Apartment> firstApartmentFuture = Future (
                () {
              return firstApartment;
            }
        );

        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/home', arguments: firstApartmentFuture);

        break;
      case LoginResult.wrong_credentials:
        updateUi("Credenziali errate");
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
            appBar: AppBar(title: const Text('Accedi')),
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
    emailController.dispose();
    passwordController.dispose();
  }
}
