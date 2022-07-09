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
        //body: "Fai swipe agli appartamenti.\n\nFai swipe agli inquilini.",
        bodyWidget:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 50),
            child: Text(
              "Fai swipe agli appartamenti\nFai swipe agli inquilini",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Raleway",
                  wordSpacing: 2,
                  letterSpacing: 0.6),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 30, top: 30),
            child: Column(children: [
              Container(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Image.asset(
                    'assets/swipe-left.png',
                    height: 34,
                    width: 34,
                  )),
              Text(
                "swipe",
                style: TextStyle(letterSpacing: 2),
              ),
            ]),
          )
        ]),
        image: Image.asset('assets/appart.jpg')),
    PageViewModel(
        title: "Non lasciare nulla al caso ",
        //body:"Vedrai sempre tutte le informazioni necessarie per una scelta informata.  ",
        bodyWidget: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 50),
                child: Text(
                  "Vedrai sempre tutte le informazioni necessarie per una scelta informata.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Raleway",
                      wordSpacing: 2,
                      letterSpacing: 0.6),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 30, top: 30),
                child: Column(children: [
                  Container(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Image.asset(
                        'assets/swipe-left.png',
                        height: 34,
                        width: 34,
                      )),
                  Text(
                    "swipe",
                    style: TextStyle(letterSpacing: 2),
                  ),
                ]),
              )
            ])),
        image: Image.asset('assets/simmetria.jpg')),
    PageViewModel(
        title: "Abbattiamo i costi",
        //body: "Nessuna agenzia. Nessuna sorpresa.",
        bodyWidget: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 50),
                child: Text(
                  "Nessuna agenzia. Nessuna sorpresa.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Raleway",
                      wordSpacing: 2,
                      letterSpacing: 0.6),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 30, top: 30),
                child: Column(children: [
                  Container(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Image.asset(
                        'assets/swipe-left.png',
                        height: 34,
                        width: 34,
                      )),
                  Text(
                    "swipe",
                    style: TextStyle(letterSpacing: 2),
                  ),
                ]),
              )
            ])),
        image: Image.asset('assets/soldi.jpg')),
    PageViewModel(
        title: "Senza discriminazioni",
        //body:"La foto di un inquilino sarà disponibile solo dopo aver espresso una preferenza alla sua biografia.",
        bodyWidget: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 50),
                child: Text(
                  "Non importa chi sei, da dove vieni o che aspetto hai.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Raleway",
                      wordSpacing: 2,
                      letterSpacing: 0.6),
                ),
              ),
            ])),
        image: Image.asset('assets/noDiscriminazione.jpg')),
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
