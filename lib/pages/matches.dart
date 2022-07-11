import 'package:appartapp/classes/lessor_match.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/widgets/apartment_viewer.dart';
import 'package:appartapp/widgets/match_entry.dart';
import 'package:flutter/material.dart';

class Matches extends StatefulWidget {
  @override
  _MatchesState createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  List<LessorMatch>? currentMatches = RuntimeStore().matchHandler.getMatches();

  void callback(newMatches) {
    setState(() {
      currentMatches = newMatches;
    });
  }

  @override
  void initState() {
    super.initState();
    //RuntimeStore().matchHandler.doUpdate(callback);
    RuntimeStore().matchHandler.doUpdateFromDate(callback); //TODO
    RuntimeStore().matchHandler.addUpdateCallback(callback);
  }

  @override
  void dispose() {
    super.dispose();
    RuntimeStore().matchHandler.removeUpdateCallback(callback);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(onGenerateRoute: (RouteSettings settings) {
      return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text('I tuoi match'),
                  backgroundColor: Colors.brown,
                ),
                body: currentMatches == null
                    ? Center(
                  child: Text("Caricamento in corso..."),
                      )
                    : ListView.builder(
                    itemCount: currentMatches?.length,
                    itemBuilder: (BuildContext context, int index) {
                      LessorMatch currentMatch = currentMatches![index];

                          return MatchEntry(
                            onTileTap:
                                (BuildContext context, LessorMatch match) {
                              for (final Image im in match.apartment.images) {
                                precacheImage(im.image, context);
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
                        }));
          });
    });
  }
}
