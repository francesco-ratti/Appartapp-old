import 'package:appartapp/classes/apartment.dart';
import 'package:appartapp/classes/apartment_handler.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/widgets/apartment_viewer.dart';
import 'package:appartapp/widgets/error_dialog_builder.dart';
import 'package:dio/dio.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';

class Houses extends StatefulWidget {
  Future<Apartment?> firstApartmentFuture;

  Houses({required this.child, required this.firstApartmentFuture});

  final Widget child;

  @override
  _HousesState createState() => _HousesState();
}

class _HousesState extends State<Houses> {
  int _currentRoute = 0;

  /*

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    firstApartmentFuture=ApartmentHandler().getNewApartment((Apartment apartment) {
      for (final Image im in apartment.images) {
        precacheImage(im.image, context);
      }
    }
    );
  }

   */

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            // try {
            //   context.pushTransparentRoute(ContentPage(
            //     currentApartment: currentApartment,
            //   ));

            //   return ContentPage(currentApartment: currentApartment);
            // } catch (e) {
            //   print("Error");
            //   print(e);
            //   return Container(
            //     child: Text("Errore 2"),
            //   );
            // }
            return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/background.gif"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ContentPage(
                  currentApartmentFuture: widget.firstApartmentFuture,
                  // updateHouses: () {setState(() {

                  // });}
                ));
          },
        );
      },
    );
  }
}

class ContentPage extends StatefulWidget {

  final likeUrlStr =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/likeapartment";
  final ignoreUrlStr =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/ignoreapartment";

  Future<void> _networkFunction(
      BuildContext context, String urlString, int apartmentId) async {
    var dio = RuntimeStore().dio; //ok
    try {
      Response response = await dio.post(
        urlString,
        data: {
          "apartmentid": apartmentId,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode != 200) {
        Navigator.restorablePush(
            context, ErrorDialogBuilder.buildGenericConnectionErrorRoute);
      }
    } on DioError {
      Navigator.restorablePush(
          context, ErrorDialogBuilder.buildConnectionErrorRoute);
    }
  }

  void likeApartment(BuildContext context, int apartmentId) async {
    await _networkFunction(context, likeUrlStr, apartmentId);
  }

  void ignoreApartment(BuildContext context, int apartmentId) async {
    await _networkFunction(context, ignoreUrlStr, apartmentId);
  }

  Future<Apartment?> currentApartmentFuture;

//Function updateHouses;
  @override
  _ContentPage createState() => _ContentPage();

  ContentPage({
    required this.currentApartmentFuture,
    //required this.updateHouses,
  });
}

class _ContentPage extends State<ContentPage> {
  Apartment? currentApartment=Apartment.withLocalImages(
      0,
      "Caricamento in corso...",
      "Caricamento in corso...",
      0,
      "Caricamento in corso...",
      "Caricamento in corso...",
      <String>[]);

  late Future<Apartment?> nextApartmentFuture;
  bool apartmentLoaded=false;

  bool firstDrag=true;
  double initialCoord=0.0;
  double finalCoord=0.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //TODO handle retry
    nextApartmentFuture=ApartmentHandler().getNewApartment((Apartment apartment) {
      /*Future.delayed(Duration(seconds: 10)).then((value) {
        for (final Image im in apartment.images) {
          precacheImage(im.image, context).then((value) {
            print("precached");
          });
        }
      });
       */

      for (final Image im in apartment.images) {
        precacheImage(im.image, context);
      }
    }
    );
  }

  @override
  void initState() {
    super.initState();

    widget.currentApartmentFuture.then((value) {
      if (value!=null)
        apartmentLoaded=true;
      setState(() {
        currentApartment=value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              return DismissiblePage(
                  //backgroundColor: Colors.white,
                  onDismissed: () {
                    if (currentApartment != null) {
                      if (finalCoord < initialCoord) {
                        widget.likeApartment(context, currentApartment!.id);
                      } else {
                        widget.ignoreApartment(context, currentApartment!.id);
                      }
                    }
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContentPage(
                                  currentApartmentFuture: nextApartmentFuture,
                                )));

                    // ApartmentHandler()
                    //     .getNewApartment()
                    //     .then((value) => setState(() {
                    //           currentApartment = value;
                    //         }));
                  },
                  direction: DismissiblePageDismissDirection.horizontal,
                  onDragUpdate: (DismissiblePageDragUpdateDetails details) {
                    double value = details.offset.dx;
                    if (firstDrag) {
                      initialCoord = value;
                      firstDrag = false;
                    } else {
                      finalCoord = value;
                    }
                  },
                  dragSensitivity: 0.5,
                  disabled: !apartmentLoaded,
                  child: ApartmentViewer(
                    apartmentLoaded: apartmentLoaded,
                    currentApartment: currentApartment,
                  ));
            });
      },
    );
  }
}