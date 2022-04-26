import 'package:appartapp/classes/apartment.dart';
import 'package:appartapp/classes/apartment_handler.dart';
import 'package:appartapp/widgets/apartment_model.dart';
import 'package:appartapp/widgets/tab_widget.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Houses extends StatefulWidget {
  Houses({required this.child});

  final Widget child;

  @override
  _Houses createState() => _Houses();
}

class _Houses extends State<Houses> {
  int _currentRoute = 0;

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
                  currentApartmentFuture: ApartmentHandler().getNewApartment(),
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
  Apartment currentApartment=Apartment(
      id: 0,
      listingTitle: "LOADING",
      description: "LOADING",
      price: 350,
      address: "Via di Paperone, Paperopoli",
      additionalExpenseDetail: "No, pagamento trimestrale",
      imagesUrl: [
        "assets/house1/img1.jpeg",
        "assets/house1/img2.jpeg",
        "assets/house1/img3.jpeg",
        "assets/house1/img4.jpeg",
        "assets/house1/img5.jpeg",
      ]);

  Future<Apartment> nextApartmentFuture=ApartmentHandler().getNewApartment();

  @override
  void initState() {
    super.initState();

    widget.currentApartmentFuture.then((value) {
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
                child: SlidingUpPanel(
                  color: Colors.transparent.withOpacity(0.7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  ),
                  panelBuilder: (scrollController) => TabWidget(
                      scrollController: scrollController,
                      currentApartment: currentApartment),
                  body: ApartmentModel(currentApartment: currentApartment),
                ),
              );
            });
      },
    );
  }
}
