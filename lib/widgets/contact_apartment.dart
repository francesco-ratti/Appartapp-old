import 'package:appartapp/classes/apartment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class ContactApartment extends StatelessWidget {
  final Apartment apartment;

  final Color textColor;
  final Color? backgroundColor;

  const ContactApartment(
      {Key? key,
      required this.textColor,
      this.backgroundColor = null,
      required this.apartment})
      : super(key: key);

  Widget buildBody() {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
              child: Text(
                "Contatta ${apartment.owner!.name} ${apartment.owner!.surname} per email:",
                style: TextStyle(color: textColor),
                textAlign: TextAlign.center,
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
              child: Text(
                apartment.owner!.email,
                style: TextStyle(color: textColor, fontSize: 20),
                textAlign: TextAlign.center,
              )),
          ElevatedButton(
              child: const Text("Invia un'email"),
              style: ElevatedButton.styleFrom(primary: Colors.brown),
              onPressed: () async {
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
              })
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
            body: buildBody())
        : Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              title: Text("Contatta ${apartment.owner?.name}"),
              backgroundColor: Colors.brown,
            ),
            body: buildBody());
  }
}
