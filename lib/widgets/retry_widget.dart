import 'package:flutter/material.dart';

class RetryWidget extends StatelessWidget {
  final Function() retryCallback;

  const RetryWidget({Key? key, required this.retryCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 8.0),
          child: Text(
              "Impossibile connettersi. Controlla la connessione e riprova")),
      ElevatedButton(
          child: Text("Riprova"),
          style: ElevatedButton.styleFrom(primary: Colors.brown),
          onPressed: retryCallback)
    ]));
  }
}
