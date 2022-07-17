import 'package:appartapp/entities/apartment.dart';
import 'package:appartapp/enums/enum_background.dart';
import 'package:appartapp/model/apartment_handler.dart';
import 'package:appartapp/utils_classes/runtime_store.dart';
import 'package:appartapp/widgets/apartment_viewer.dart';
import 'package:appartapp/widgets/error_dialog_builder.dart';
import 'package:appartapp/widgets/ignore_background.dart';
import 'package:appartapp/widgets/like_background.dart';
import 'package:appartapp/widgets/retry_widget.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';

class Houses extends StatefulWidget {
  Future<Apartment?> firstApartmentFuture;

  /*
  final String bothBackgroundImgStr="assets/background.gif";
  final String likeBackgroundImgStr="assets/GreenBackground.jpg";
  final String ignoreBackgroundImgStr="assets/RedBackground.jpg";
   */
  Houses({Key? key, required this.child, required this.firstApartmentFuture})
      : super(key: key);

  final Widget child;

  @override
  _HousesState createState() => _HousesState();
}

class _HousesState extends State<Houses> {

  late BackgroundType backgroundType;

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
  void initState() {
    super.initState();
    //backgroundImgStr=widget.likeBackgroundImgStr;
    backgroundType = BackgroundType.like;
  }

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
            return /*Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(backgroundImgStr),
                    fit: BoxFit.cover,
                  ),
                ),
                child:*/
                Stack(children: [
              backgroundType == BackgroundType.like
                  ? LikeBackground()
                  : (backgroundType == BackgroundType.ignore
                      ? IgnoreBackground()
                      : SizedBox()),
              ContentPage(
                  currentApartmentFuture: widget.firstApartmentFuture,
                  backgroundUpdateCbk: (BackgroundType newBackground) {
                    if (backgroundType != newBackground) {
                      setState(() {
                        backgroundType = newBackground;
                        /*
                          switch (newBackground) {
                            case BackgroundType.both:
                              backgroundImgStr = widget.bothBackgroundImgStr;
                              break;

                            case BackgroundType.like:
                              backgroundType = widget.likeBackgroundImgStr;
                              break;
                            case BackgroundType.ignore:
                              backgroundType = widget.ignoreBackgroundImgStr;
                              break;
                            default:
                              backgroundImgStr = widget.bothBackgroundImgStr;
                              break;
                          }*/
                      });
                    }
                  }
                  // updateHouses: () {setState(() {

                  // });}
                  )
            ]);
          },
        );
      },
    );
  }
}

class ContentPage extends StatefulWidget {
  final Function(BackgroundType) backgroundUpdateCbk;



//Function updateHouses;
  Future<Apartment?> currentApartmentFuture;

  @override
  _ContentPage createState() =>
      _ContentPage(currentApartmentFuture: currentApartmentFuture);

  ContentPage({
    required this.currentApartmentFuture,
    required this.backgroundUpdateCbk,
    //required this.updateHouses,
  });
}

class _ContentPage extends State<ContentPage> {
  Future<Apartment?> currentApartmentFuture;

  _ContentPage({required this.currentApartmentFuture});

  Apartment? currentApartment = Apartment.withLocalImages(
      0,
      "Caricamento in corso...",
      "Caricamento in corso...",
      0,
      "Caricamento in corso...",
      "Caricamento in corso...", <String>[]);

  late Future<Apartment?> nextApartmentFuture;
  bool _apartmentLoaded = false;
  bool _networkerror = false;

  bool firstDrag = true;
  double initialCoord = 0.0;
  double finalCoord = 0.0;

  Future<Apartment?> getNewApartment() {
    return ApartmentHandler.getNewApartment((Apartment apartment) {
      for (final Image im in apartment.images) {
        precacheImage(im.image, context);
      }
    });
  }

  void showCurrentApartmentFromFuture({bool retryIfEmptyOrError = false}) {
    currentApartmentFuture.then((value) {
      if (value != null || !retryIfEmptyOrError) {
        setState(() {
          _apartmentLoaded = true;
          currentApartment = value;
        });
      } else {
        showCurrentApartmentFromFuture(retryIfEmptyOrError: false);
      }
    }).onError((error, stackTrace) {
      if (retryIfEmptyOrError) {
        currentApartmentFuture =
            getNewApartment(); //maybe the error was at previous page, long time ago, retry
        showCurrentApartmentFromFuture(retryIfEmptyOrError: false);
      } else {
        setState(() {
          _networkerror = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _networkerror = false;

    showCurrentApartmentFromFuture(retryIfEmptyOrError: true);
    nextApartmentFuture = getNewApartment();
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
                        //widget.backgroundImgStrUpdateCbk(BackgroundType.like);
                        ApartmentHandler.likeApartment(currentApartment!.id,
                            () {
                          //onError
                          Navigator.restorablePush(context,
                              ErrorDialogBuilder.buildConnectionErrorRoute);
                        });
                      } else {
                        //widget.backgroundImgStrUpdateCbk(BackgroundType.ignore);
                        ApartmentHandler.ignoreApartment(currentApartment!.id,
                            () {
                          //onError
                          Navigator.restorablePush(context,
                              ErrorDialogBuilder.buildConnectionErrorRoute);
                        });
                      }
                    }
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContentPage(
                                  currentApartmentFuture: nextApartmentFuture,
                                  backgroundUpdateCbk:
                                      widget.backgroundUpdateCbk,
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
                      if (finalCoord < initialCoord) {
                        widget.backgroundUpdateCbk(BackgroundType.like);
                      } else {
                        widget.backgroundUpdateCbk(BackgroundType.ignore);
                      }
                    }
                  },
                  dragSensitivity: 0.5,
                  disabled: !_apartmentLoaded || currentApartment == null,
                  child: _networkerror
                      ? RetryWidget(
                          textColor: Colors.white,
                          backgroundColor: RuntimeStore.backgroundColor,
                          retryCallback: () {
                            setState(() {
                              _networkerror = false;
                            });
                            currentApartmentFuture = getNewApartment();
                            showCurrentApartmentFromFuture();
                          })
                      : (_apartmentLoaded && currentApartment == null
                          ? RetryWidget(
                              message:
                                  "Nessun nuovo appartamento da mostrare nella tua zona",
                              textColor: Colors.white,
                              backgroundColor: RuntimeStore.backgroundColor,
                              retryButtonText: "Cerca ancora",
                              retryCallback: () {
                                setState(() {
                                  _apartmentLoaded = false;
                                });
                                currentApartmentFuture = getNewApartment();
                                showCurrentApartmentFromFuture();
                              },
                            )
                          : ApartmentViewer(
                              apartmentLoaded: _apartmentLoaded,
                              currentApartment: currentApartment,
                            )));
            });
      },
    );
  }
}
