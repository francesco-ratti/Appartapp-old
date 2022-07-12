import 'dart:ui';

import 'package:flutter/material.dart';

class AddApartmentInformations extends StatelessWidget {
  final Color textColor;

  const AddApartmentInformations({Key? key, required this.textColor})
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
                "Devi aggiungere un appartamento prima di poter vedere e mettere like alle persone interessate ai tuoi appartamenti.",
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
