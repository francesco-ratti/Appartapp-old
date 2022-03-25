
import 'dart:convert';

import 'package:flutter/material.dart';
//import './../SimpleTextField.dart';
//import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import "dart:convert" show latinArabic;
//import "dart:convert" show utf8;

class Login extends StatefulWidget {
  String urlStr = "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/login";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String status = "Not submitted yet";

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
                  /*
                  const HtmlEscape htmlEscape = HtmlEscape();

                  String email = htmlEscape.convert(emailController.text);
                  String password = htmlEscape.convert(passwordController.text);

                  var url = Uri.parse(widget.urlStr);
                  var body = utf8.encode("email=${email}&password=${password}");
                  http
                      .post(url,
                          headers: {
                            "Content-Length": body.length.toString(),
                            "Content-Type": "application/x-www-form-urlencoded"
                          },
                          encoding: Encoding.getByName('utf-8'),
                          body: body)
                      .then((response) => setState(() {
                            if (response.statusCode != 200)
                              status = "Failure" + response.body;
                            else
                              status = "Logged in" + response.body;
                          }));*/
                  //Instance level
                  String email = emailController.text;
                  String password = passwordController.text;
/*
                  var url = Uri.parse(widget.urlStr);

                  http
                      .post(url,
                      //headers: {
                      //  "Content-Type": "application/x-www-form-urlencoded"
                      //},
                      encoding: Encoding.getByName('iso-8859-1'),
                      body: {"email": email, "password": password})
                      .then((response) => setState(() {
                    if (response.statusCode != 200)
                      status = "Failure" + response.body;
                    else
                      status = "Logged in" + response.body;
                  }));
*/
                  var dio = Dio();

                  //dio.options.contentType = Headers.formUrlEncodedContentType;
//or works once
                  dio.post(
                        widget.urlStr,
                        data: {"email": email, "password": password},
                        options: Options(contentType: Headers.formUrlEncodedContentType,
                          headers: {"Content-Type": "application/x-www-form-urlencoded"},
                        ),
                      )
                      .then((response) => setState(() {
                            if (response.statusCode != 200)
                              status = "Failure" + response.data;
                            else
                              status = "Logged in" + response.data;
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
