import 'package:appartapp/classes/apartment.dart';
import 'package:appartapp/classes/apartment_handler.dart';
import 'package:appartapp/classes/credentials.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/widgets/apartment_viewer.dart';
import 'package:dio/dio.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';

class Houses extends StatefulWidget {
  Future<Apartment?> firstApartmentFuture;

  Houses({required this.child, required this.firstApartmentFuture});

  final Widget child;

  @override
  _Houses createState() => _Houses();
}

class _Houses extends State<Houses> {
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

  final likeUrlStr="http://172.20.10.4:8080/appartapp_war_exploded/api/reserved/likeapartment";
  final ignoreUrlStr="http://172.20.10.4:8080/appartapp_war_exploded/api/reserved/ignoreapartment";

  Future<void> _networkFunction(String urlString, int apartmentId) async {
    var dio = RuntimeStore().dio;
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


        if (response.statusCode != 200)
          print("Failure");
        else
          print("Done");
      } on DioError catch (e) {
        if (e.response?.statusCode != 200) {
          print("Failure");
        }
      }
  }

  void likeApartment(int apartmentId) async {
    await _networkFunction(likeUrlStr, apartmentId);
  }

  void ignoreApartment (int apartmentId) async {
    await _networkFunction(ignoreUrlStr, apartmentId);
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
                  if (currentApartment!=null) {
                    if (finalCoord < initialCoord) {
                      widget.likeApartment(currentApartment!.id);
                    } else {
                      widget.ignoreApartment(currentApartment!.id);
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
                  onDragUpdate: (double value) {
                    if (firstDrag) {
                      initialCoord=value;
                      firstDrag=false;
                    } else {
                      finalCoord=value;
                    }
                  },
                dragSensitivity: 0.5,
                disabled: !apartmentLoaded,
                child: ApartmentViewer(apartmentLoaded: apartmentLoaded, currentApartment: currentApartment,));
            });
      },
    );
  }
}