import 'package:appartapp/classes/match_handler.dart';
import 'package:appartapp/classes/user.dart';
import 'package:appartapp/classes/apartment.dart';
import 'package:appartapp/classes/apartment_handler.dart';
import 'package:appartapp/classes/first_arguments.dart';
import 'package:appartapp/classes/like_from_user.dart';
import 'package:appartapp/classes/login_handler.dart';
import 'package:appartapp/classes/user_handler.dart';
import 'package:appartapp/classes/credentials.dart';
import 'package:appartapp/classes/enum_loginresult.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void doInitialisation(BuildContext context, User user, SharedPreferences sharedPreferences) async {
  sharedPreferences.setBool("logged", true);

  RuntimeStore().setUser(user);

  RuntimeStore().matchHandler = MatchHandler();
  RuntimeStore().matchHandler.startPeriodicUpdate();

  Apartment? firstApartment =
  await ApartmentHandler().getNewApartment((Apartment apartment) {
    for (final Image im in apartment.images) {
      precacheImage(im.image, context);
    }
  });

  Future<Apartment?> firstApartmentFuture = Future(() {
    return firstApartment;
  });

  RuntimeStore()
      .setOwnedApartmentsFuture(ApartmentHandler().getOwnedApartments());

// Navigator.pushReplacementNamed(context, '/home',
//     arguments: firstApartmentFuture);

  LikeFromUser? firstTenant =
  await UserHandler().getNewLikeFromUser((LikeFromUser likeFromUser) {
    for (final Image im in likeFromUser.user.images) {
      precacheImage(im.image, context);
    }
  });

  Future<LikeFromUser?> firstTenantFuture = Future(() {
    return firstTenant;
  });

  FirstArguments firstArguments =
  FirstArguments(firstApartmentFuture, firstTenantFuture);

  Navigator.pushReplacementNamed(context, '/home', arguments: firstArguments);
}

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void setup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    RuntimeStore().setSharedPreferences(prefs);
    //await Future.delayed(Duration(seconds: 1));
    bool? TourCompleted = prefs.getBool('tourcompleted');
    bool? logged=prefs.getBool('logged');
    RuntimeStore().initDio().then((value) {
      if (TourCompleted != null && TourCompleted) {
        if (logged==null || logged==false) {
          Navigator.pushReplacementNamed(context, '/loginorsignup');
        } else {
          LoginHandler.doLoginWithCookies().then((res) async {
            User user = res[0];
            LoginResult loginResult = res[1];
            switch (loginResult) {
              case LoginResult.ok:
                doInitialisation(context, user, prefs);
                break;
              case LoginResult.wrong_credentials:
                Navigator.pushReplacementNamed(context, '/loginorsignup');
                break;
              case LoginResult.server_error:
                print("internal server error");
                break;
              default:
              //TODO showerror: network error
            }
          });
        }
      } else {
        Navigator.pushReplacementNamed(context, '/first', arguments: prefs);
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
    return Scaffold(
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
