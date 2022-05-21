import 'package:appartapp/classes/enum_gender.dart';
import 'package:appartapp/classes/enum_month.dart';
import 'package:appartapp/classes/enum_temporalq.dart';
import 'package:appartapp/classes/user.dart';
import 'package:appartapp/widgets/display_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabWidgetTenant extends StatelessWidget {
  final User currentTenant;
  final ScrollController scrollController;

  TabWidgetTenant({
    Key? key,
    required this.scrollController,
    required this.currentTenant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(
        padding: EdgeInsets.all(16),
        controller: scrollController,
        //physics: Scroll,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(30, 10, 10, 30),
            child: Text(
              currentTenant.name,
              //textAlign: TextAlign.center,
              style: GoogleFonts.nunito(color: Colors.white70, fontSize: 30),
            ),
          ),
          /*
          email;
  
  DateTime birthday;
  Gender gender;

          */
          DisplayText(
              title: "Nome e cognome",
              content: currentTenant.name + " " + currentTenant.surname),
          DisplayText(title: "Su di me", content: currentTenant.bio),
          DisplayText(
              title: "Perché cerco casa", content: currentTenant.reason),
          DisplayText(title: "A partire da", content: currentTenant.month!.toShortString()),
          DisplayText(
              title: "Cosa faccio nella vita", content: currentTenant.job),
          DisplayText(
              title: "Le mie entrate mensili", content: currentTenant.bio),
          DisplayText(title: "Fumatore", content: currentTenant.smoker!.toItalianString()),
          DisplayText(title: "Animali", content: currentTenant.pets.isEmpty ? "No" : currentTenant.pets),
          //PRIVATE INFORMATION
          DisplayText(title: "Sesso", content: "${currentTenant.gender.toItalianString()}"),
          DisplayText(title: "Compleanno", content: "${currentTenant.birthday.day.toString().padLeft(2,'0')}-${currentTenant.birthday.month.toString().padLeft(2,'0')}-${currentTenant.birthday.year.toString()}")
        ],
      );
}
