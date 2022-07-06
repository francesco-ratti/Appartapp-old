import 'package:flutter/cupertino.dart';

class ConnectionErrorDialogBuilder {
  static Route<Object?> buildRoute(BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
            title: const Text("Errore"),
            actions: [
              CupertinoDialogAction(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
            content: Center(
              child: Text("Errore di connessione"),
            ));
      },
    );
  }
}
