import 'package:appartapp/classes/apartment.dart';
import 'package:appartapp/classes/like_from_user.dart';
import 'package:appartapp/classes/user.dart';
import 'package:appartapp/widgets/display_text.dart';
import 'package:appartapp/widgets/tenant_viewer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabWidget extends StatelessWidget {
  final Apartment currentApartment;
  final ScrollController scrollController;
  final User? owner;

  TabWidget({
    Key? key,
    required this.scrollController,
    required this.currentApartment,
    this.owner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.all(16),
    controller: scrollController,
    //physics: Scroll,
    children: [
      Container(
          padding: EdgeInsets.fromLTRB(30, 10, 10, 30),
          child: Row(
            children: [
              Text(
                currentApartment.listingTitle,
                //textAlign: TextAlign.center,
                style:
                GoogleFonts.nunito(color: Colors.white70, fontSize: 30),
              ),
              Spacer(),
              this.owner == null
                  ? SizedBox()
                  :
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Scaffold(
                              appBar: AppBar(
                                  title: Text(
                                      "${owner?.name} ${owner?.surname}")),
                              body: TenantViewer(
                                tenantLoaded: true,
                                lessor: true,
                                currentLikeFromUser:
                                LikeFromUser(null, owner!),
                              ))));
                },
                child: Text("PROPRIETARIO"),
              )
            ],
          )),
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
