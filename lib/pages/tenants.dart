import 'package:appartapp/entities/like_from_user.dart';
import 'package:appartapp/entities/user.dart';
import 'package:appartapp/enums/enum_background.dart';
import 'package:appartapp/enums/enum_gender.dart';
import 'package:appartapp/enums/enum_month.dart';
import 'package:appartapp/enums/enum_temporalq.dart';
import 'package:appartapp/model/user_handler.dart';
import 'package:appartapp/utils_classes/runtime_store.dart';
import 'package:appartapp/widgets/error_dialog_builder.dart';
import 'package:appartapp/widgets/ignore_background.dart';
import 'package:appartapp/widgets/like_background.dart';
import 'package:appartapp/widgets/retry_widget.dart';
import 'package:appartapp/widgets/tenant_viewer.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';

class Tenants extends StatefulWidget {
  final Future<LikeFromUser?> firstTenantFuture;

  const Tenants(
      {Key? key, required this.child, required this.firstTenantFuture})
      : super(key: key);

  final Widget child;

  @override
  _Tenants createState() => _Tenants();
}

class _Tenants extends State<Tenants> {
  late BackgroundType backgroundType;

  bool match = false;

  @override
  void initState() {
    super.initState();
    backgroundType = BackgroundType.like;
  }

  void updateUI(bool value) {
    setState(() {
      match = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return /*Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/background.gif"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: */
                Stack(children: [
              backgroundType == BackgroundType.like
                  ? const LikeBackground()
                  : (backgroundType == BackgroundType.ignore
                      ? const IgnoreBackground()
                      : const SizedBox()),
              ContentPage(
                  currentTenantFuture: widget.firstTenantFuture,
                  updateUI: updateUI,
                  match: match,
                  whoCreatedMe: "Tenants creation",
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
                  })
            ]);
          },
        );
      },
    );
  }
}

class ContentPage extends StatefulWidget {
  final bool match;
  final String whoCreatedMe;

  final Function(BackgroundType) backgroundUpdateCbk;

  final Future<LikeFromUser?> currentTenantFuture;
  final Function(bool value) updateUI;

  @override
  _ContentPage createState() =>
      _ContentPage(currentTenantFuture: currentTenantFuture);

  const ContentPage(
      {Key? key,
      required this.currentTenantFuture,
      required this.updateUI,
      required this.match,
      required this.whoCreatedMe,
      required this.backgroundUpdateCbk})
      : super(key: key);
}

class _ContentPage extends State<ContentPage> {
  Future<LikeFromUser?> currentTenantFuture;

  _ContentPage({
    required this.currentTenantFuture,
  });

  LikeFromUser? currentTenant = LikeFromUser(
      null,
      User.temp(
          000,
          "Caricamento in corso...",
          "Caricamento in corso...",
          "Caricamento in corso...",
          DateTime(2022),
          Gender.NB,
          [],
          [],
          "Caricamento in corso...",
          "Caricamento in corso...",
          Month.Luglio,
          "Caricamento in corso...",
          "Caricamento in corso...",
          TemporalQ.Sometimes,
          "Caricamento in corso..."));

  late Future<LikeFromUser?> nextTenantFuture;
  bool _tenantLoaded = false;
  bool _networkerror = false;

  bool firstDrag = true;
  double initialCoord = 0.0;
  double finalCoord = 0.0;

  Future<LikeFromUser?> getNewTenant() {
    return UserHandler.getNewLikeFromUser((LikeFromUser likeFromUser) {
      for (final Image im in likeFromUser.user.images) {
        precacheImage(im.image, context);
      }
    });
  }

  void showCurrentTenantFromFuture({bool retryIfEmptyOrError = false}) {
    currentTenantFuture.then((value) {
      if (value != null || !retryIfEmptyOrError) {
        setState(() {
          _tenantLoaded = true;
          currentTenant = value;
        });
      } else {
        showCurrentTenantFromFuture(retryIfEmptyOrError: false);
      }
    }).onError((error, stackTrace) {
      if (retryIfEmptyOrError) {
        currentTenantFuture =
            getNewTenant(); //maybe the error was at previous page, long time ago, retry
        showCurrentTenantFromFuture(retryIfEmptyOrError: false);
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
    showCurrentTenantFromFuture(retryIfEmptyOrError: true);
    nextTenantFuture = getNewTenant();

    _networkerror = false;
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
                    widget.updateUI(false);
                    if (currentTenant != null) {
                      if (finalCoord < initialCoord) {
                        UserHandler.likeUser(currentTenant!.user.id,
                            currentTenant!.apartment!.id, () {
                          //onError
                          Navigator.restorablePush(context,
                              ErrorDialogBuilder.buildConnectionErrorRoute);
                        });
                      } else {
                        UserHandler.ignoreUser(currentTenant!.user.id,
                            currentTenant!.apartment!.id, () {
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
                                  currentTenantFuture: nextTenantFuture,
                                  updateUI: widget.updateUI,
                                  match: widget.match,
                                  whoCreatedMe: "Content creation",
                                  backgroundUpdateCbk:
                                      widget.backgroundUpdateCbk,
                                )));
                  },
                  direction: widget.match
                      ? DismissiblePageDismissDirection.endToStart
                      : DismissiblePageDismissDirection.horizontal,
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
                  disabled: !_tenantLoaded || currentTenant == null,
                  child: _networkerror
                      ? RetryWidget(
                          textColor: Colors.white,
                          backgroundColor: RuntimeStore.backgroundColor,
                          retryCallback: () {
                            setState(() {
                              _networkerror = false;
                            });
                            currentTenantFuture = getNewTenant();
                            showCurrentTenantFromFuture();
                          })
                      : (_tenantLoaded && currentTenant == null
                          ? RetryWidget(
                              message:
                                  "Nessun nuovo locatario è interessato ai tuoi appartamenti",
                              textColor: Colors.white,
                              backgroundColor: RuntimeStore.backgroundColor,
                              retryButtonText: "Cerca ancora",
                              retryCallback: () {
                                setState(() {
                                  // print('_tenantLoaded   :');
                                  // print(_tenantLoaded);
                                  // print('currentTenant   :');
                                  // print(currentTenant);
                                  _tenantLoaded = false;
                                });
                                currentTenantFuture = getNewTenant();
                                showCurrentTenantFromFuture();
                              },
                            )
                          : TenantViewer(
                              tenantLoaded: _tenantLoaded,
                              lessor: false,
                              currentLikeFromUser: currentTenant,
                              updateUI: widget.updateUI,
                              match: widget.match,
                            )));
            });
      },
    );
  }
}
