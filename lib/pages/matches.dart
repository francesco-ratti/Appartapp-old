import 'package:appartapp/widgets/apartment_viewer.dart';
import 'package:flutter/material.dart';

import 'package:appartapp/classes/match_handler.dart';

import 'package:appartapp/classes/lessor_match.dart';

class Matches extends StatefulWidget {
  @override
  _MatchesState createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  List<LessorMatch>? currentMatches = MatchHandler().getMatches();

  void callback(newMatches) {
    setState(() {
      currentMatches = newMatches;
    });
  }

  @override
  void initState() {
    super.initState();
    MatchHandler().doUpdate(callback);
    MatchHandler().addUpdateCallback(callback);
  }

  @override
  void dispose() {
    super.dispose();
    MatchHandler().removeUpdateCallback(callback);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(onGenerateRoute: (RouteSettings settings) {
      return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return Scaffold(
                appBar: AppBar(title: const Text('I tuoi match')),
                body: currentMatches == null
                    ? Center(
                        child: Text("Updating... please wait"),
                      )
                    : ListView.builder(
                        itemCount: currentMatches?.length,
                        itemBuilder: (BuildContext context, int index) {
                          LessorMatch currentMatch = currentMatches![index];

                          return ListTile(
                            title: Text(currentMatch.apartment.listingTitle),
                            subtitle: Text(
                                "${currentMatch.apartment.description} - ${currentMatch.time}"),
                            onTap: () {
                              for (final Image im
                                  in currentMatches![index].apartment.images) {
                                precacheImage(im.image, context);
                              }

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Scaffold(
                                          appBar: AppBar(
                                              title: Text(currentMatches![index]
                                                  .apartment
                                                  .listingTitle)),
                                          body: ApartmentViewer(
                                              apartmentLoaded: true,
                                              currentApartment:
                                                  currentMatches![index]
                                                      .apartment,
                                              owner: currentMatches![index]
                                                  .apartment
                                                  .owner))));
                            },
                          );
                        }));
          });
    });
  }
}
