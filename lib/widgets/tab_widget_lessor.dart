import 'package:appartapp/entities/user.dart';
import 'package:appartapp/enums/enum_gender.dart';
import 'package:appartapp/widgets/display_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabWidgetLessor extends StatelessWidget {
  final User currentLessor;
  final ScrollController scrollController;

  const TabWidgetLessor({
    Key? key,
    required this.scrollController,
    required this.currentLessor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(6),
        controller: scrollController,
        //physics: Scroll,
        children: [
          const Divider(
            color: Colors.white,
            indent: 180,
            thickness: 2,
            endIndent: 180,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 10, 10, 30),
            child: Text(
              currentLessor.name,
              //textAlign: TextAlign.center,
              style: GoogleFonts.nunito(color: Colors.white70, fontSize: 30),
            ),
          ),

          DisplayText(
              title: "Nome e cognome",
              content: currentLessor.name + " " + currentLessor.surname),
          DisplayText(title: "Su di me", content: currentLessor.bio),
          //PRIVATE INFORMATION
          currentLessor.gender == null
              ? const SizedBox()
              : DisplayText(
                  title: "Sesso",
                  content: currentLessor.gender.toItalianString()),
          DisplayText(
              title: "Compleanno",
              content:
                  "${currentLessor.birthday.day.toString().padLeft(2, '0')}-${currentLessor.birthday.month.toString().padLeft(2, '0')}-${currentLessor.birthday.year.toString()}")
        ],
      );
}
