import 'package:appartapp/entities/apartment.dart';
import 'package:appartapp/entities/user.dart';
import 'package:appartapp/enums/enum_gender.dart';
import 'package:appartapp/enums/enum_month.dart';
import 'package:appartapp/enums/enum_temporalq.dart';
import 'package:appartapp/widgets/apartment_viewer.dart';
import 'package:appartapp/widgets/display_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabWidgetTenant extends StatefulWidget {
  final User currentTenant;
  final ScrollController scrollController;
  Apartment? apartment;
  bool match; //If there is no match, info should be locked
  Function(bool value) updateUi;

  TabWidgetTenant(
      {Key? key,
      required this.scrollController,
      required this.currentTenant,
      this.apartment,
      required this.match,
      required this.updateUi});

  @override
  _TabWidgetTenant createState() => _TabWidgetTenant();
}

class _TabWidgetTenant extends State<TabWidgetTenant> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(6),
        controller: widget.scrollController,
        //physics: Scroll,
        children: [
          const Divider(
            color: Colors.white,
            indent: 180,
            thickness: 2,
            endIndent: 180,
          ),
          Row(
            children: [
              Expanded(
                flex: 90,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: Text(
                    widget.currentTenant.name,
                    //textAlign: TextAlign.center,
                    style:
                        GoogleFonts.nunito(color: Colors.white70, fontSize: 30),
                  ),
                ),
              ),
              const Spacer(),
              widget.apartment == null
                  ? const SizedBox()
                  : Expanded(
                      flex: 41,
                      child: Column(
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
                                                "${widget.apartment?.listingTitle} "),
                                            backgroundColor: Colors.brown,
                                          ),
                                          body: ApartmentViewer(
                                              apartmentLoaded: true,
                                              currentApartment:
                                                  widget.apartment))));
                            },
                            child: Container(
                                width: 70,
                                height: 70,
                                child: widget.apartment!.images[0] != null
                                    ? CircleAvatar(
                                        backgroundImage:
                                            widget.apartment!.images[0].image)
                                    : const Icon(
                                        Icons.apartment_rounded,
                                      )),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text("${widget.apartment?.listingTitle} ",
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
          DisplayText(
              title: "Nome e cognome",
              content: widget.currentTenant.name +
                  " " +
                  widget.currentTenant.surname),
          DisplayText(title: "Su di me", content: widget.currentTenant.bio),
          DisplayText(
              title: "Perché cerco casa", content: widget.currentTenant.reason),
          widget.currentTenant.month == null
              ? const SizedBox()
              : DisplayText(
                  title: "A partire da",
                  content: widget.currentTenant.month!.toShortString()),
          DisplayText(
              title: "Cosa faccio nella vita",
              content: widget.currentTenant.job),
          DisplayText(
              title: "Le mie entrate mensili",
              content: widget.currentTenant.income),
          widget.currentTenant.smoker == null
              ? const SizedBox()
              : DisplayText(
                  title: "Fumatore",
                  content: widget.currentTenant.smoker!.toItalianString()),
          DisplayText(
              title: "Animali",
              content: widget.currentTenant.pets.isEmpty
                  ? "No"
                  : widget.currentTenant.pets),

          //PRIVATE INFORMATION

          widget.currentTenant.gender == null
              ? const SizedBox()
              : !widget.match
                  ? DisplayText(title: "Sesso", content: "Non è importante!")
                  : DisplayText(
                      title: "Sesso",
                      content:
                          "${widget.currentTenant.gender.toItalianString()}"),
          !widget.match
              ? DisplayText(title: "Compleanno", content: "Non è importante!")
              : DisplayText(
                  title: "Compleanno",
                  content:
                      "${widget.currentTenant.birthday.day.toString().padLeft(2, '0')}-${widget.currentTenant.birthday.month.toString().padLeft(2, '0')}-${widget.currentTenant.birthday.year.toString()}"),
          !widget.match
              ? Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 3),
                      child: Text(
                        "Sblocca questo profilo, diremo a " +
                            widget.currentTenant.name +
                            " che il suo profilo ti interessa!",
                        style: GoogleFonts.nunito(
                            color: Colors.white70, fontSize: 15),
                      ),
                    ),
                    FloatingActionButton(
                        heroTag: null,
                        backgroundColor: Colors.brown,
                        child: const Icon(Icons.lock_open_rounded),
                        onPressed: () async {
                          //LIKE
                          widget.updateUi(true); //match true
                        }),
                    const SizedBox(height: 130),
                  ],
                )
              : Container(
                  child: const Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 50,
                  ),
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 70),
                )
        ],
      );
}
