import 'package:appartapp/pages/edit_password.dart';
import 'package:appartapp/pages/edit_tenant_information.dart';
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
      '/': (context) => const Loading(),
      '/tour': (context) => Tour(),
      '/home': (context) => const HomeParent(),
      '/loginorsignup': (context) => const LoginOrSignup(),
      '/login': (context) => const Login(),
      '/signup': (context) => const Signup(),
      '/editpassword': (context) => const EditPassword(),
      '/edittenants': (context) => EditTenantInformation(),
      '/matches': (context) => const Matches(),
    },
  ));
}
