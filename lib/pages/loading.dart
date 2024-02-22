import 'package:appartapp/entities/apartment.dart';
import 'package:appartapp/entities/like_from_user.dart';
import 'package:appartapp/entities/user.dart';
import 'package:appartapp/enums/enum_loginresult.dart';
import 'package:appartapp/model/apartment_handler.dart';
import 'package:appartapp/model/login_handler.dart';
import 'package:appartapp/model/match_handler.dart';
import 'package:appartapp/model/user_handler.dart';
import 'package:appartapp/utils_classes/first_arguments.dart';
import 'package:appartapp/utils_classes/runtime_store.dart';
import 'package:appartapp/widgets/error_dialog_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void doInitialisation(BuildContext context, User user,
    SharedPreferences sharedPreferences) async {
  sharedPreferences.setBool("logged", true);
  RuntimeStore().credentialsLogin =
      sharedPreferences.getBool("credentialslogin")!;

  RuntimeStore().setUser(user);

  Apartment? firstApartment =
      await ApartmentHandler.getNewApartment((Apartment apartment) {
    for (final Image im in apartment.images) {
      precacheImage(im.image, context);
    }
  }).onError((error, stackTrace) {
    Navigator.restorablePush(
        context, ErrorDialogBuilder.buildConnectionErrorReloadAppRoute);
    return;
  });

  Future<Apartment?> firstApartmentFuture = Future(() {
    return firstApartment;
  });

  RuntimeStore()
      .setOwnedApartmentsFuture(ApartmentHandler.getOwnedApartments());

// Navigator.pushReplacementNamed(context, '/home',
//     arguments: firstApartmentFuture);

  LikeFromUser? firstTenant =
      await UserHandler.getNewLikeFromUser((LikeFromUser likeFromUser) {
    for (final Image im in likeFromUser.user.images) {
      precacheImage(im.image, context);
    }
  }).onError((error, stackTrace) {
    Navigator.restorablePush(
        context, ErrorDialogBuilder.buildConnectionErrorReloadAppRoute);
    return;
  });

  Future<LikeFromUser?> firstTenantFuture = Future(() {
    return firstTenant;
  });

  RuntimeStore().matchHandler = MatchHandler();
  RuntimeStore().matchHandler.initLastViewedMatchDate();
  RuntimeStore().matchHandler.startPeriodicUpdate();

  FirstArguments firstArguments =
      FirstArguments(firstApartmentFuture, firstTenantFuture);

  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false,
      arguments: firstArguments);
}

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void setup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    RuntimeStore().setSharedPreferences(prefs);
    //await Future.delayed(Duration(seconds: 1));
    bool? tourCompleted = prefs.getBool('tourcompleted');
    bool? logged = prefs.getBool('logged');
    RuntimeStore().initDio().then((value) {
      if (tourCompleted != null && tourCompleted) {
        if (logged == false) {
          RuntimeStore().cookieJar.deleteAll();
          Navigator.pushReplacementNamed(context, '/loginorsignup');
        } else {
          LoginHandler.invalidateSession()
              .then((value) =>
                  LoginHandler.doLoginWithCookies().then((res) async {
                    LoginResult loginResult = res[1];
                    switch (loginResult) {
                      case LoginResult.ok:
                        User user = res[0];
                        doInitialisation(context, user, prefs);
                        break;
                      case LoginResult.wrong_credentials:
                        RuntimeStore().cookieJar.deleteAll();
                        Navigator.pushReplacementNamed(
                            context, '/loginorsignup');
                        break;
                      case LoginResult.server_error:
                        if (kDebugMode) {
                          print("internal server error");
                        }
                        Navigator.restorablePush(
                            context,
                            ErrorDialogBuilder
                                .buildConnectionErrorReloadAppRoute);
                        break;
                      default:
                        Navigator.restorablePush(
                            context,
                            ErrorDialogBuilder
                                .buildConnectionErrorReloadAppRoute);
                        break;
                    }
                  }))
              .onError((error, stackTrace) {
            Navigator.restorablePush(
                context, ErrorDialogBuilder.buildConnectionErrorReloadAppRoute);
          });
        }
      } else {
        Navigator.pushReplacementNamed(context, '/tour', arguments: prefs);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    RuntimeStore().useMobileLayout = shortestSide < 600;
    return const Scaffold(
      backgroundColor: Colors.brown,
      body: Center(
        child: SpinKitSquareCircle(
          color: Colors.white,
          size: 80.0,
        ),
      ),
    );
  }
}
