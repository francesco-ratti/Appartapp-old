import 'package:appartapp/pages/edit_password.dart';
import 'package:appartapp/pages/edit_tenant.dart';
import 'package:appartapp/pages/loading.dart';
import 'package:appartapp/pages/login.dart';
import 'package:appartapp/pages/loginorsignup.dart';
import 'package:appartapp/pages/matches.dart';
import 'package:appartapp/pages/signup.dart';
import 'package:appartapp/pages/tour.dart';
import 'package:appartapp/widgets/home_parent.dart';
import 'package:flutter/material.dart';

void main() {
  //HttpOverrides.global = new MyHttpOverrides();
  runApp(MaterialApp(
    initialRoute: '/',
    /* theme: ThemeData(
      scaffoldBackgroundColor: RuntimeStore.backgroundColor
    ),*/
    routes: {
      '/': (context) => Loading(),
      '/tour': (context) => Tour(),
      '/home': (context) => HomeParent(),
      '/loginorsignup': (context) => LoginOrSignup(),
      '/login': (context) => Login(),
      '/signup': (context) => Signup(),
      '/editpassword': (context) => EditPassword(),
      '/edittenants': (context) => EditTenant(),
      '/matches': (context) => Matches(),
    },
  ));
}
