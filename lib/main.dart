

import 'package:appartapp/pages/login.dart';
import 'package:flutter/material.dart';

import 'package:appartapp/pages/loading.dart';
import 'package:appartapp/pages/home.dart';
import 'package:appartapp/pages/first.dart';

import 'pages/loginorsignup.dart';

void main() {
  //HttpOverrides.global = new MyHttpOverrides();
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Loading(),
      '/first': (context) => First(),
      '/home': (context) => Home(),
      '/loginorsignup': (context) => LoginOrSignup(),
      '/login': (context) => Login(),
    },
  ));
}
