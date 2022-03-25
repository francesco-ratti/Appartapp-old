import 'package:flutter/material.dart';
import './../SimpleTextField.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {

  String urlStr = "http://ratti.dynv6.net/appartapp_war_exploded/api/login";
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String status="Not submitted yet";

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.white;

    return Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
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

                          var url = Uri.parse(widget.urlStr);
                          http.post(
                              url, body: {'email': email, 'password': password}).then((response) => setState(() {
                              if (response.statusCode!=200)
                                status="Failure";
                              else
                                status="Logged in"+response.body;
                          }));
                        },
                      ),
                    ]))));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
