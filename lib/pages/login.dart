import 'package:flutter/material.dart';
import './../SimpleTextField.dart';

class Login extends StatelessWidget {
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
          const Padding(
              padding: EdgeInsets.all(16.0),
        child:
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'E-Mail',
            )
          )),
          const Padding(
              padding: EdgeInsets.all(16.0),
    child:
              const TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
          )),
          ElevatedButton(
            child:Text("Accedi"),
            onPressed: () {},
          ),
          ]))));
  }
}