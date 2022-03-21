import 'dart:io';

import 'package:flutter/material.dart';

import 'package:appartapp/pages/loading.dart';
import 'package:appartapp/pages/home.dart';
import 'package:appartapp/pages/first.dart';

void main() {
  //HttpOverrides.global = new MyHttpOverrides();
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Loading(),
      '/first': (context) => First(),
      '/home': (context) => Home(),
    },
  ));
}
