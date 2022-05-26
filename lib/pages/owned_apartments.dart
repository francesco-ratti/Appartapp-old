import 'package:appartapp/classes/apartment.dart';
import 'package:appartapp/pages/add_apartment.dart';
import 'package:appartapp/pages/houses.dart';
import 'package:flutter/material.dart';

import '../classes/apartment_handler.dart';
import '../classes/runtime_store.dart';
import '../widgets/apartment_viewer.dart';

class OwnedApartments extends StatefulWidget {
  @override
  State<OwnedApartments> createState() => _OwnedApartments();
}

class _OwnedApartments extends State<OwnedApartments> {
  void updateUi(List<Apartment> value) {
    setState(() {
      ownedApartments = value;
    });
  }

  List<Apartment> ownedApartments = [];

  @override
  void initState() {
    Future<List<Apartment>>? oldOwnedApartments =
    RuntimeStore().getOwnedApartments();

    if (oldOwnedApartments != null) oldOwnedApartments.then(updateUi);

    Future<List<Apartment>> newOwnedApartments =
    ApartmentHandler().getOwnedApartments();
    newOwnedApartments.then(updateUi);
    RuntimeStore().setOwnedApartmentsFuture(newOwnedApartments);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(onGenerateRoute: (RouteSettings settings) {
      return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                  title: const Text('I tuoi appartamenti'),
                  actions: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddApartment()),
                            );
                          },
                          child: Icon(
                            Icons.add,
                            size: 26.0,
                          ),
                        )),
                  ]),
              body: ListView.builder(
                  itemCount: ownedApartments.length,
                  itemBuilder: (BuildContext context, int index) {
                    Apartment currentApartment = ownedApartments[index];

                    return ListTile(
                      title: Text(currentApartment.listingTitle),
                      subtitle: Text(currentApartment.description),
                      onTap: () {
                        for (final Image im in ownedApartments[index].images) {
                          precacheImage(im.image, context);
                        }

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Scaffold(
                                    appBar: AppBar(
                                        title: Text(
                                            ownedApartments[index].listingTitle),
                                        actions: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.only(right: 20.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => AddApartment(toEdit: ownedApartments[index])),
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 26.0,
                                                ),
                                              )),
                                        ]),
                                    body: ApartmentViewer(
                                      apartmentLoaded: true,
                                      currentApartment: ownedApartments[index],
                                    ))));
                      },
                    );
                  }),
            );
          });
    });
  }
}
