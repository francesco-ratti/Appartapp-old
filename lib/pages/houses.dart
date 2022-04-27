import 'dart:ui';

import 'package:appartapp/classes/apartment.dart';
import 'package:appartapp/classes/apartment_handler.dart';
import 'package:appartapp/widgets/apartment_model.dart';
import 'package:appartapp/widgets/tab_widget.dart';
import 'package:appartapp/widgets/tab_widget_loading.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Houses extends StatefulWidget {
  Future<Apartment> firstApartmentFuture;

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
                    image: AssetImage("assets/background.jpeg"),
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
  Future<Apartment> currentApartmentFuture;
//Function updateHouses;
  @override
  _ContentPage createState() => _ContentPage();
  ContentPage({
    required this.currentApartmentFuture,
    //required this.updateHouses,
  });
}

class _ContentPage extends State<ContentPage> {
  Apartment currentApartment=Apartment.withLocalImages(
      0,
      "Caricamento in corso...",
      "Caricamento in corso...",
      0,
      "Caricamento in corso...",
      "Caricamento in corso...",
      <String>[]);

  late Future<Apartment> nextApartmentFuture;
  bool apartmentLoaded=false;

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
                  Navigator.of(context).pop();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContentPage(
                            currentApartmentFuture: nextApartmentFuture,
                          )));
                  print("DISMISSED");

                  // ApartmentHandler()
                  //     .getNewApartment()
                  //     .then((value) => setState(() {
                  //           currentApartment = value;
                  //         }));
                },
                direction: DismissiblePageDismissDirection.horizontal,
                dragSensitivity: 0.5,
                disabled: !apartmentLoaded,
                child: SlidingUpPanel(
                  color: Colors.transparent.withOpacity(0.7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  ),
                  isDraggable: apartmentLoaded,
                  panelBuilder: (scrollController) =>
                  apartmentLoaded ? TabWidget(
                      scrollController: scrollController,
                      currentApartment: currentApartment) : TabWidgetLoading(),
                  body: apartmentLoaded ? ApartmentModel(currentApartment: currentApartment) : Center(
                      child: CircularProgressIndicator(
                        value: null,
                      )),
                ),
              );
            });
      },
    );
  }
}
