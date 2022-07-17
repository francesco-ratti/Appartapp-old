import 'package:appartapp/entities/apartment.dart';
import 'package:appartapp/entities/like_from_user.dart';
import 'package:appartapp/entities/user.dart';
import 'package:appartapp/widgets/contact_apartment.dart';
import 'package:appartapp/widgets/display_text.dart';
import 'package:appartapp/widgets/tenant_viewer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabWidget extends StatelessWidget {
  final Apartment currentApartment;
  final ScrollController scrollController;
  final User? owner;
  final bool showContact;

  const TabWidget(
      {Key? key,
      required this.scrollController,
      required this.currentApartment,
      this.owner,
      this.showContact = false})
      : super(key: key);

  void updateUI(bool value) {
    //DO NOT DO ANYTHING HERE
  }

  @override
  Widget build(BuildContext context) =>
      ListView(padding: const EdgeInsets.all(6), controller: scrollController,
          //physics: Scroll,
          children: [
            const Divider(
              color: Colors.white,
              indent: 180,
              thickness: 2,
              endIndent: 180,
            ),
            //Row(
            //children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
              child: Text(
                currentApartment.listingTitle,
                //textAlign: TextAlign.center,
                style: GoogleFonts.nunito(color: Colors.white70, fontSize: 30),
              ),
            ),
            //   ],
            // ),
            /*Container(
              padding: const EdgeInsets.all(8.0),
              child: const Text("Questo appartamento è di:", style: TextStyle(color: Colors.white),),
            ),*/
            owner == null
                ? const SizedBox()
                : DisplayText(
                    title: "Questo appartamento è di",
                    contentWidget: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //showContact ? const Spacer() : const SizedBox(),
                        Expanded(
                          child: Column(
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.brown,
                                    shape: const CircleBorder(),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Scaffold(
                                                appBar: AppBar(
                                                  title: Text(
                                                      "${owner?.name} ${owner?.surname}"),
                                                  backgroundColor: Colors.brown,
                                                ),
                                                body: TenantViewer(
                                                  tenantLoaded: true,
                                                  lessor: true,
                                                  currentLikeFromUser:
                                                      LikeFromUser(
                                                          null, owner!),
                                                  updateUI: updateUI,
                                                  match: false,
                                                ))));
                                  },
                                  child: Container(
                                      width: 70,
                                      height: 70,
                                      child: owner!.images[0] != null
                                          ? CircleAvatar(
                                              backgroundImage:
                                                  owner!.images[0].image)
                                          : const Icon(
                                              Icons.person_pin_rounded,
                                            ))),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: Text("${owner?.name} ",
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                        showContact
                            ? Expanded(
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.brown,
                                      shape: const CircleBorder(),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ContactApartment(
                                                      textColor: Colors.black,
                                                      backgroundColor:
                                                          Colors.white,
                                                      apartment:
                                                          currentApartment)));
                                    },
                                    child: Container(
                                        width: 70,
                                        height: 70,
                                        child: const Icon(
                                          Icons.messenger,
                                        ))),
                              )
                            : const SizedBox(),
                      ],
                    )),
            DisplayText(
                title: "Descrizione", content: currentApartment.description),
            DisplayText(title: "Prezzo", content: "${currentApartment.price}€"),
            DisplayText(title: "Indirizzo", content: currentApartment.address),
            DisplayText(
                title: "Spese aggiuntive",
                content: currentApartment.additionalExpenseDetail),
            //Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0)),
          ]);
}
