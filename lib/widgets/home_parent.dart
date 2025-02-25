import 'package:appartapp/entities/lessor_match.dart';
import 'package:appartapp/pages/home.dart';
import 'package:appartapp/utils_classes/runtime_store.dart';
import 'package:appartapp/widgets/apartment_viewer.dart';
import 'package:appartapp/widgets/match_entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeParent extends StatefulWidget {
  const HomeParent({Key? key}) : super(key: key);

  @override
  State<HomeParent> createState() => _HomeParent();
}

class _HomeParent extends State<HomeParent> {
  List<LessorMatch>? currentMatches = RuntimeStore().matchHandler.getMatches();
  bool pressed = false;

  void callback(newMatches) {
    setState(() {
      currentMatches = newMatches;
      pressed = false;
    });
  }

  @override
  void initState() {
    super.initState();
    //RuntimeStore().matchHandler.doUpdate(callback);
    //RuntimeStore().matchHandler.doUpdateFromDate(callback);
    RuntimeStore().matchHandler.addUpdateCallback(callback);
  }

  @override
  void dispose() {
    super.dispose();
    RuntimeStore().matchHandler.removeUpdateCallback(callback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        const Home(),
        currentMatches != null && currentMatches!.isNotEmpty && !pressed
            ? CupertinoAlertDialog(
                title: currentMatches!.length > 1
                    ? const Text("Hai dei nuovi match!")
                    : const Text("Hai un nuovo match!"),
                actions: [
                  CupertinoDialogAction(
                    child: const Text("Ho visto"),
                    onPressed: () {
                      setState(() {
                        RuntimeStore().matchHandler.setChangesAsSeen();
                        pressed = true;
                      });
                    },
                  )
                ],
                content: SizedBox(
                  height: 300,
                  width: 300,
                  child: ListView.builder(
                      itemCount: currentMatches?.length,
                      itemBuilder: (BuildContext context, int index) {
                        LessorMatch currentMatch = currentMatches![index];

                        for (final Image im in currentMatch.apartment.images) {
                          precacheImage(im.image, context);
                        }

                        return MatchEntry(
                          onTileTap: (BuildContext context, LessorMatch match) {
                            if (currentMatches!.length == 1) {
                              setState(() {
                                RuntimeStore().matchHandler.setChangesAsSeen();
                                pressed = true;
                              });
                            }

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                        appBar: AppBar(
                                          title: Text(
                                              match.apartment.listingTitle),
                                          backgroundColor: Colors.brown,
                                        ),
                                        body: ApartmentViewer(
                                            apartmentLoaded: true,
                                            currentApartment: match.apartment,
                                            owner: match.apartment.owner))));
                          },
                          match: currentMatch,
                        );
                      }),
                ),
              )
            : const SizedBox(),
      ]),
    );
  }
}
