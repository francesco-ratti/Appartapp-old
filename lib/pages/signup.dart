import 'dart:convert';

import 'package:flutter/material.dart';

//import './../SimpleTextField.dart';
import 'package:dio/dio.dart';

class Signup extends StatefulWidget {
  String urlStr = "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/login";

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  void doSignup(
      Function(String) updateUi, String email, String password) async {
    var dio = Dio();
    try {
      Response response = await dio.post(
        widget.urlStr,
        data: {"email": email, "password": password},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode != 200)
        updateUi("Failure");
      else
        updateUi("Logged in");
    } on DioError catch (e) {
      if (e.response?.statusCode != 200) {
        updateUi("Failure");
      }
    }
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final birthdayController = TextEditingController();

  String status = "Not submitted yet";

  DateTime initialDate = new DateTime.now();

  List<String> _locations = [
    "Maschile",
    "Femminile",
    "Non binario"
  ]; // Option 2
  var _selectedLocation = null; // Option 2

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.white;

    birthdayController.text =
        "${initialDate.day}/${initialDate.month}/${initialDate.year}";

    return (MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text('Login')),
            backgroundColor: bgColor,
            body: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'E-Mail',
                      ),
                      controller: emailController,
                    )),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                      controller: passwordController,
                    )),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nome',
                      ),
                      controller: nameController,
                    )),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Cognome',
                      ),
                      controller: surnameController,
                    )),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: birthdayController,
                      readOnly: true,
                      onTap: () {
                        showDatePicker(
                                context: context,
                                initialDate: initialDate,
                                lastDate: DateTime.now(),
                                firstDate: DateTime(1900))
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              initialDate = value;
                            });
                          }
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Data di nascita',
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(children: [
                      Expanded(
                          child: DropdownButton(
                        hint: Text("Scegli il tuo genere"),
                        // Not necessary for Option 1
                        value: _selectedLocation,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedLocation = newValue;
                          });
                        },
                        items: _locations.map((location) {
                          return DropdownMenuItem(
                            child: new Text(location),
                            value: location,
                          );
                        }).toList(),
                      ))
                    ])),
                ElevatedButton(child: Text("Registrati"), onPressed: () {})
              ],
            ))));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
