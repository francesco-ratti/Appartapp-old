import 'package:appartapp/classes/apartment.dart';
import 'package:appartapp/classes/enum_gender.dart';
import 'package:appartapp/classes/enum_month.dart';
import 'package:appartapp/classes/enum_temporalq.dart';
import 'package:appartapp/classes/user.dart';
import 'package:appartapp/widgets/display_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appartapp/widgets/apartment_viewer.dart';

class TabWidgetTenant extends StatelessWidget {
  final User currentTenant;
  final ScrollController scrollController;
  Apartment? apartment;

  TabWidgetTenant({
    Key? key,
    required this.scrollController,
    required this.currentTenant,
    this.apartment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(
        padding: EdgeInsets.all(6),
        controller: scrollController,
        //physics: Scroll,
        children: [
          Divider(
            color: Colors.white,
            indent: 180,
            thickness: 2,
            endIndent: 180,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: Text(
                  currentTenant.name,
                  //textAlign: TextAlign.center,
                  style:
                      GoogleFonts.nunito(color: Colors.white70, fontSize: 30),
                ),
              ),
              Spacer(),
              this.apartment == null
                  ? SizedBox()
                  : Column(
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.brown,
                                shape: const CircleBorder()),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Scaffold(
                                          appBar: AppBar(
                                            title: Text(
                                                "${apartment?.listingTitle} "),
                                            backgroundColor: Colors.brown,
                                          ),
                                          body: ApartmentViewer(
                                              apartmentLoaded: true,
                                              currentApartment: apartment))));
                            },
                            child: Container(
                                width: 70,
                                height: 70,
                                child: apartment!.images[0] != null
                                    ? CircleAvatar(
                                        backgroundImage:
                                            apartment!.images[0].image)
                                    : Icon(
                                        Icons.apartment_rounded,
                                      ))),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text("${apartment?.listingTitle} ",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
            ],
          ),
          DisplayText(
              title: "Nome e cognome",
              content: currentTenant.name + " " + currentTenant.surname),
          DisplayText(title: "Su di me", content: currentTenant.bio),
          DisplayText(
              title: "Perché cerco casa", content: currentTenant.reason),
          currentTenant.month == null
              ? SizedBox()
              : DisplayText(
                  title: "A partire da",
                  content: currentTenant.month!.toShortString()),
          DisplayText(
              title: "Cosa faccio nella vita", content: currentTenant.job),
          DisplayText(
              title: "Le mie entrate mensili", content: currentTenant.income),
          currentTenant.smoker == null
              ? SizedBox()
              : DisplayText(
                  title: "Fumatore",
                  content: currentTenant.smoker!.toItalianString()),
          DisplayText(
              title: "Animali",
              content: currentTenant.pets.isEmpty ? "No" : currentTenant.pets),
          //PRIVATE INFORMATION
          currentTenant.gender == null
              ? SizedBox()
              : DisplayText(
                  title: "Sesso",
                  content: "${currentTenant.gender.toItalianString()}"),
          DisplayText(
              title: "Compleanno",
              content:
                  "${currentTenant.birthday.day.toString().padLeft(2, '0')}-${currentTenant.birthday.month.toString().padLeft(2, '0')}-${currentTenant.birthday.year.toString()}")
        ],
      );
}
