// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class First extends StatelessWidget {
  late SharedPreferences prefs;
  bool gotPrefs = false;

  @override
  void initState() {}

  List<PageViewModel> listPagesViewModel = [
    PageViewModel(
        title: "Benvenuto!\n",
        body: "Fai swipe agli appartamenti.\n\nFai swipe agli inquilini.",
        decoration: const PageDecoration(
          pageColor: Colors.white,
        ),
        image: Image.asset('assets/appart.tiff')),
    PageViewModel(
        title: "Simmetria informativa",
        body:
            "Vedrai sempre tutte le informazioni necessarie per una scelta informata.  ",
        image: Image.asset('assets/simmetria.tiff')),
    PageViewModel(
        title: "Abbattiamo i costi",
        body: "Nessuna agenzia. Nessuna sorpresa.",
        image: Image.asset('assets/soldi.tiff')),
    PageViewModel(
        title: "Senza discriminazioni",
        body:
            "La foto di un inquilino sarà disponibile solo dopo aver espresso una preferenza alla sua biografia.",
        image: Image.asset('assets/noDiscriminazione.tiff')),
  ];
  @override
  Widget build(BuildContext context) {
    if (!gotPrefs) {
      prefs = ModalRoute.of(context)!.settings.arguments as SharedPreferences;
      gotPrefs = true;
    }

    return IntroductionScreen(
      pages: listPagesViewModel,
      done: const Text("Done",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
      next: const Icon(
        Icons.arrow_forward,
        color: Colors.black,
      ),
      globalBackgroundColor: Colors.white,
      onDone: () {
        // When done button is press
        prefs.setBool('tourcompleted', true);
        Navigator.pushReplacementNamed(context, '/loginorsignup');
      },
      dotsDecorator: const DotsDecorator(activeColor: Colors.black),
    ); //Material App
  }
}
