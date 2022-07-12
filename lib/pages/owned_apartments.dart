import 'package:appartapp/classes/apartment.dart';
import 'package:appartapp/classes/apartment_handler.dart';
import 'package:appartapp/classes/connection_exception.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/pages/add_apartment.dart';
import 'package:appartapp/widgets/apartment_viewer.dart';
import 'package:appartapp/widgets/retry_widget.dart';
import 'package:flutter/material.dart';

class OwnedApartments extends StatefulWidget {
  const OwnedApartments({Key? key}) : super(key: key);

  @override
  State<OwnedApartments> createState() => _OwnedApartments();
}

class _OwnedApartments extends State<OwnedApartments> {
  void updateUi(List<Apartment> value) {
    setState(() {
      ownedApartments = value;
    });
  }

  List<Apartment>? ownedApartments = null;
  bool _networkError = false;

  void updateApartments() {
    _networkError = false;
    Future<List<Apartment>> newOwnedApartments =
        ApartmentHandler().getOwnedApartments();
    newOwnedApartments
        .then(updateUi)
        .onError<ConnectionException>((error, stackTrace) => setState(() {
              _networkError = true;
            }));
    RuntimeStore().setOwnedApartmentsFuture(newOwnedApartments);
  }

  void callbck(bool ownsApartments) {
    Future<List<Apartment>> newOwnedApartments =
        ApartmentHandler().getOwnedApartments();
    newOwnedApartments.then(updateUi).then((value) => Navigator.pop(context));
    RuntimeStore().setOwnedApartmentsFuture(newOwnedApartments);
  }

  @override
  void initState() {
    Future<List<Apartment>>? oldOwnedApartments =
        RuntimeStore().getOwnedApartments();

    if (oldOwnedApartments != null) oldOwnedApartments.then(updateUi);
    updateApartments();

    RuntimeStore().addApartmentAddedCbk(callbck);
  }

  @override
  void dispose() {
    super.dispose();
    RuntimeStore().removeApartmentAddedCbk(callbck);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(onGenerateRoute: (RouteSettings settings) {
      return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                heroTag: null,
                backgroundColor: Colors.brown,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddApartment()),
                  );
                },
                child: const Icon(Icons.add),
              ),
              body: ownedApartments == null
                  ? Center(
                      child: _networkError
                          ? RetryWidget(
                              textColor: Colors.black,
                              retryCallback: updateApartments)
                          : const CircularProgressIndicator(
                              value: null,
                            ))
                  : ownedApartments!.isEmpty
                      ? const Center(
                          child: Text(
                              "Non possiedi alcun appartamento. Aggiungine uno!"),
                        )
                      : ListView.builder(
                          itemCount: ownedApartments!.length,
                          itemBuilder: (BuildContext context, int index) {
                            Apartment currentApartment =
                                ownedApartments![index];

                            return ListTile(
                              leading: currentApartment.images[0] != null
                                  ? CircleAvatar(
                                      backgroundImage:
                                          currentApartment.images[0].image)
                                  : const Icon(
                                      Icons.apartment_rounded,
                                    ),
                              title: Text(currentApartment.listingTitle),
                              subtitle: Text(currentApartment.description),
                              onTap: () {
                                for (final Image im
                                    in ownedApartments![index].images) {
                                  precacheImage(im.image, context);
                                }

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Scaffold(
                                            appBar: AppBar(
                                                title: Text(
                                                    ownedApartments![index]
                                                        .listingTitle),
                                                backgroundColor: Colors.brown,
                                                actions: <Widget>[
                                                  Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          right: 20.0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        AddApartment(
                                                                          toEdit:
                                                                              ownedApartments![index],
                                                                        )),
                                                          );
                                                        },
                                                        child: const SizedBox(
                                                          height: 26,
                                                          width: 26,
                                                          child: Icon(
                                                            Icons.edit,
                                                            size: 26.0,
                                                          ),
                                                        ),
                                                      )),
                                                ]),
                                            body: ApartmentViewer(
                                              apartmentLoaded: true,
                                              currentApartment:
                                              ownedApartments![index],
                                            ))));
                              },
                            );
                          }),
            );
          });
    });
  }
}
