import 'package:appartapp/classes/apartment.dart';
import 'package:appartapp/widgets/display_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabWidget extends StatelessWidget {
  final Apartment currentApartment;
  final ScrollController scrollController;

  TabWidget({
    Key? key,
    required this.scrollController,
    required this.currentApartment,
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
              currentApartment.listingTitle,
              //textAlign: TextAlign.center,
              style: GoogleFonts.nunito(color: Colors.white70, fontSize: 30),
            ),
          ),
          DisplayText(
              title: "Descrizione", content: currentApartment.description),
          DisplayText(title: "Prezzo", content: "${currentApartment.price}€"),
          DisplayText(
              title: "Indirizzo", content: "${currentApartment.address}"),
          DisplayText(
              title: "Spese aggiuntive",
              content: "${currentApartment.additionalExpenseDetail}"),
        ],
      );
}
