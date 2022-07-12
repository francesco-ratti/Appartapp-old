import 'package:appartapp/classes/apartment.dart';
import 'package:appartapp/classes/like_from_user.dart';
import 'package:appartapp/classes/user.dart';
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
          Row(
            children: [
              SingleChildScrollView(
                //padding: EdgeInsets.fromLTRB(30, 10, 10, 30),
                child: Text(
                  currentApartment.listingTitle,
                  //textAlign: TextAlign.center,
                  style:
                      GoogleFonts.nunito(color: Colors.white70, fontSize: 30),
                ),
              ),
              showContact ? const Spacer() : const SizedBox(),
              showContact
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.brown,
                        shape: const CircleBorder(),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContactApartment(
                                    textColor: Colors.black,
                                    backgroundColor: Colors.white,
                                    apartment: currentApartment)));
                      },
                      child: Container(
                          width: 70,
                          height: 70,
                          child: const Icon(
                            Icons.messenger,
                          )))
                  : const SizedBox(),
              const Spacer(),
              owner == null
                  ? const SizedBox()
                  : Column(
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
                                                LikeFromUser(null, owner!),
                                            updateUI: updateUI,
                                            match: false,
                                          ))));
                            },
                            child: Container(
                                width: 70,
                                height: 70,
                                child: owner!.images[0] != null
                                    ? CircleAvatar(
                                        backgroundImage: owner!.images[0].image)
                                    : const Icon(
                                        Icons.person_pin_rounded,
                                      ))),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text("${owner?.name} ",
                              style: const TextStyle(color: Colors.white)),
                        ),
                      ],
                    )
            ],
          ),
          DisplayText(
              title: "Descrizione", content: currentApartment.description),
          DisplayText(title: "Prezzo", content: "${currentApartment.price}€"),
          DisplayText(title: "Indirizzo", content: currentApartment.address),
          DisplayText(
              title: "Spese aggiuntive",
              content: currentApartment.additionalExpenseDetail),
        ],
      );
}
