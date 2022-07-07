import 'dart:ui';

import 'package:flutter/material.dart';

class RetryWidget extends StatelessWidget {
  final Function() retryCallback;
  final Color textColor;

  const RetryWidget(
      {Key? key, required this.retryCallback, required this.textColor})
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
                "Impossibile connettersi.\nControlla la connessione e riprova",
                style: TextStyle(color: textColor),
                textAlign: TextAlign.center,
              )),
          ElevatedButton(
              child: Text("Riprova"),
              style: ElevatedButton.styleFrom(primary: Colors.brown),
              onPressed: retryCallback)
        ]));
  }
}
