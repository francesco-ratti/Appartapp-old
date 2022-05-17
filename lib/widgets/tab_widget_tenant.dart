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
          DisplayText(title: "A partire da", content: "${currentTenant.month}"),
          DisplayText(
              title: "Cosa faccio nella vita", content: currentTenant.job),
          DisplayText(
              title: "Le mie entrate mensili", content: currentTenant.bio),
          DisplayText(title: "Fumatore", content: currentTenant.smoker.toString()),
          DisplayText(title: "Animali", content: currentTenant.pets),
          //PRIVATE INFORMATION
          DisplayText(title: "Sesso", content: "${currentTenant.gender}"),
          DisplayText(title: "Compleanno", content: "${currentTenant.birthday}")
        ],
      );
}
