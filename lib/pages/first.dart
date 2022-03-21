// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class First extends StatefulWidget {
  @override
  _First createState() => _First();
}

class _First extends State<First> {
  List<PageViewModel> listPagesViewModel = [
    PageViewModel(
        title: "Initial",
        body: "Welcome in appartapp",
        image: Image.asset('assets/Background.jpeg')),
    PageViewModel(
        title: "This is a tour",
        body: "Of this new application",
        image: Image.asset('assets/Background1.jpeg')),
    PageViewModel(
        title: "Are you ready?",
        body: "Discover what you can do",
        image: Image.asset('assets/Background2.jpeg')),
    PageViewModel(
        title: "Press Done",
        body: "Have a nice experiece",
        image: Image.asset('assets/Background3.jpeg')),
  ];
  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.red;

    return IntroductionScreen(
      pages: listPagesViewModel,
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      onDone: () {
        // When done button is press
      },
    ); //Material App
  }
}
