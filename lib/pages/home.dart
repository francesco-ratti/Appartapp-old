// ignore_for_file: prefer_const_constructors

import 'package:appartapp/pages/empty_page.dart';
import 'package:appartapp/pages/houses.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.yellowAccent;

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: true,
        child: IndexedStack(
          index: _pageIndex,
          children: <Widget>[
            Houses(
              child: Text('Esplora'),
            ),
            EmptyPage(
              child: Text('Filtri'),
            ),
            EmptyPage(
              child: Text('Chat'),
            ),
            EmptyPage(
              child: Text('Profilo'),
            ),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: Colors.white, //try transparent
        type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_rounded,
              color: Colors.black,
            ),
            label: 'Esplora',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.filter_list_rounded,
              color: Colors.black,
            ),
            label: 'Filtri',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_bubble_rounded,
              color: Colors.black,
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline_rounded,
              color: Colors.black,
            ),
            label: 'Profilo',
          ),
        ],
        currentIndex: _pageIndex,
        onTap: (int index) {
          setState(
            () {
              _pageIndex = index;
            },
          );
        },
      ),
    );
  }
}
