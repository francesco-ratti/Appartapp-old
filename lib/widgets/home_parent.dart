import 'package:appartapp/classes/lessor_match.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/pages/home.dart';
import 'package:appartapp/widgets/apartment_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeParent extends StatefulWidget {
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
    return Scaffold(
      body: Stack(children: <Widget>[
        Home(),
        currentMatches != null && currentMatches!.isNotEmpty && !pressed
            ? CupertinoAlertDialog(
                title: const Text("Nuovo match!"),
                actions: [
                  CupertinoDialogAction(
                    child: Text("OK"),
                    onPressed: () {
                      setState(() {
                        pressed = true;
                      });
                    },
                  )
                ],
                content: Container(
                  height: 300,
                  width: 300,
                  child: ListView.builder(
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
                      }),
                ),
              )
            : SizedBox(),
      ]),
    );
  }
}
