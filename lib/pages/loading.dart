import 'package:appartapp/classes/User.dart';
import 'package:appartapp/classes/apartment.dart';
import 'package:appartapp/classes/apartment_handler.dart';
import 'package:appartapp/classes/first_arguments.dart';
import 'package:appartapp/classes/like_from_user.dart';
import 'package:appartapp/classes/login_handler.dart';
import 'package:appartapp/classes/user_handler.dart';
import 'package:appartapp/classes/credentials.dart';
import 'package:appartapp/classes/enum%20LoginResult.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
    if (TourCompleted != null && TourCompleted) {
      String? email = prefs.getString("email");
      String? password = prefs.getString("password");

      if (email == null || password == null) {
        Navigator.pushReplacementNamed(context, '/loginorsignup');
      } else {
        LoginHandler.doLogin(email, password).then((res) async {
          Credentials credentials = res[0];
          User user = res[1];
          LoginResult loginResult = res[2];
          switch (loginResult) {
            case LoginResult.ok:
              RuntimeStore().setCredentials(credentials);
              RuntimeStore().setUser(user);

              prefs.setString("email", credentials.email);
              prefs.setString("password", credentials.password);

              Apartment firstApartment = await ApartmentHandler()
                  .getNewApartment((Apartment apartment) {
                for (final Image im in apartment.images) {
                  precacheImage(im.image, context);
                }
              });

              Future<Apartment> firstApartmentFuture = Future(() {
                return firstApartment;
              });

              RuntimeStore().setOwnedApartmentsFuture(
                  ApartmentHandler().getOwnedApartments());

              // Navigator.pushReplacementNamed(context, '/home',
              //     arguments: firstApartmentFuture);

              LikeFromUser firstTenant = await UserHandler().getNewLikeFromUser((LikeFromUser likeFromUser) {
                for (final Image im in likeFromUser.user.images) {
                  precacheImage(im.image, context);
                }
              });

              Future<LikeFromUser> firstTenantFuture = Future(() {
                return firstTenant;
              });

              FirstArguments firstArguments =
                  FirstArguments(firstApartmentFuture, firstTenantFuture);

              Navigator.pushReplacementNamed(context, '/home',
                  arguments: firstArguments);

              break;
            case LoginResult.wrong_credentials:
              Navigator.pushReplacementNamed(context, '/loginorsignup');
              break;
            default:
            //TODO showerror: network error
          }
        });
      }
    } else {
      Navigator.pushReplacementNamed(context, '/first', arguments: prefs);
    }
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
        child: SpinKitSquareCircle(
          color: Colors.white,
          size: 80.0,
        ),
      ),
    );
  }
}
