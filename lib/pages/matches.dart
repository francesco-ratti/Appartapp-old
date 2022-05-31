import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/widgets/apartment_viewer.dart';
import 'package:flutter/material.dart';
import 'package:appartapp/classes/lessor_match.dart';

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
    RuntimeStore().matchHandler.doUpdate(callback);
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
                                                .listingTitle),
                                            backgroundColor: Colors.brown,
                                          ),
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
