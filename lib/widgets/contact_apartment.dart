import 'package:appartapp/entities/apartment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class ContactApartment extends StatelessWidget {
  final Apartment apartment;

  final Color textColor;
  final Color? backgroundColor;

  static Route<Object?> buildNoEmailClientErrorRoute(
      BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
            title: const Text("Errore"),
            actions: [
              CupertinoDialogAction(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
            content: const Center(
              child: Text("Nessun client di posta installato"),
            ));
      },
    );
  }

  static Route<Object?> buildEmailErrorRoute(
      BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
            title: const Text("Errore"),
            actions: [
              CupertinoDialogAction(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
            content: const Center(
              child: Text("Impossibile aprire il client di posta"),
            ));
      },
    );
  }

  const ContactApartment(
      {Key? key,
      required this.textColor,
      this.backgroundColor,
      required this.apartment})
      : super(key: key);

  Widget buildBody(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Contatta ${apartment.owner!.name} ${apartment.owner!.surname} per email:",
                style: TextStyle(color: textColor, fontSize: 15),
                textAlign: TextAlign.center,
              )),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                apartment.owner!.email,
                style: TextStyle(color: textColor, fontSize: 20),
                textAlign: TextAlign.center,
              )),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  child: const Text("Scrivi un'email"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                  onPressed: () async {
                    try {
                      final Email email = Email(
                        body:
                            "Ciao ${apartment.owner!.name}, ti contatto per l'appartamento ${apartment.description} in ${apartment.address}.\n",
                        subject: "Annuncio ${apartment.description}",
                        recipients: [apartment.owner!.email],
                        //cc: ['cc@example.com'],
                        //bcc: ['bcc@example.com'],
                        //attachmentPaths: ['/path/to/attachment.zip'],
                        isHTML: false,
                      );

                      await FlutterEmailSender.send(email);
                    } on PlatformException catch (e) {
                      if (e.code == "not_available") {
                        Navigator.restorablePush(
                            context, buildNoEmailClientErrorRoute);
                      } else {
                        Navigator.restorablePush(
                            context, buildNoEmailClientErrorRoute);
                      }
                    }
                  })),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return backgroundColor == null
        ? Scaffold(
            appBar: AppBar(
              title: Text("Contatta ${apartment.owner?.name}"),
              backgroundColor: Colors.brown,
            ),
            body: buildBody(context))
        : Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              title: Text("Contatta ${apartment.owner?.name}"),
              backgroundColor: Colors.brown,
            ),
            body: buildBody(context));
  }
}
