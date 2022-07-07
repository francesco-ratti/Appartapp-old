import 'dart:ui';

import 'package:flutter/material.dart';

class AddTenantInformations extends StatelessWidget {
  final Color textColor;

  const AddTenantInformations({Key? key, required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 8.0),
              child: Text(
                "Aggiungi le tue informazioni da locatario per cercare appartamenti.\nSe non lo farai, potrai solamente inserire appartamenti da locatore.",
                style: TextStyle(color: textColor),
                textAlign: TextAlign.center,
              )),
          ElevatedButton(
              child: Text("Completa profilo"),
              style: ElevatedButton.styleFrom(primary: Colors.brown),
              onPressed: () {
                Navigator.pushNamed(context, "/edittenants");
              })
        ]));
  }
}
