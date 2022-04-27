import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/pages/login.dart';
import 'package:flutter/material.dart';

import 'package:appartapp/pages/loading.dart';
import 'package:appartapp/pages/home.dart';
import 'package:appartapp/pages/first.dart';

import 'pages/loginorsignup.dart';
import 'pages/signup.dart';

void main() {
  //HttpOverrides.global = new MyHttpOverrides();
  runApp(MaterialApp(
    initialRoute: '/',
    theme: ThemeData(
      scaffoldBackgroundColor: RuntimeStore.backgroundColor
    ),
    routes: {
      //'/': (context) => Home(), //to delete
      '/': (context) => Loading(), //to uncomment
      '/first': (context) => First(),
      '/home': (context) => Home(),
      '/loginorsignup': (context) => LoginOrSignup(),
      '/login': (context) => Login(),
      '/signup': (context) => Signup(),
    },
  ));
}
