// ignore_for_file: prefer_const_constructors

import 'package:appartapp/classes/match_handler.dart';
import 'package:appartapp/classes/user.dart';
import 'package:appartapp/classes/first_arguments.dart';
import 'package:appartapp/pages/empty_page.dart';
import 'package:appartapp/pages/houses.dart';
import 'package:appartapp/pages/matches.dart';
import 'package:appartapp/pages/profile_apartments.dart';
import 'package:appartapp/pages/tenants.dart';
import 'package:flutter/material.dart';
import '../classes/runtime_store.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.yellowAccent;

    User? user = RuntimeStore().getUser();
    if (user != null) {
      for (final Image im in user.images) {
        precacheImage(im.image, context);
      }
    }

    return Scaffold(
      //backgroundColor: RuntimeStore.backgroundColor,
      body: SafeArea(
        top: false,
        bottom: true,
        child: IndexedStack(
          index: _pageIndex,
          children: <Widget>[
            Houses(
                child: Text('Esplora'),
                firstApartmentFuture: ((ModalRoute.of(context)!
                        .settings
                        .arguments) as FirstArguments)
                    .firstApartmentFuture),
            Matches(),
            Tenants(
                child: Text('Esplora'),
                firstTenantFuture: ((ModalRoute.of(context)!.settings.arguments)
                        as FirstArguments)
                    .firstTenantFuture),
            EmptyPage(child: Text('Chat')),
            ProfileApartments()
            //EditProfile(),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: Colors.white, //try transparent
        type: BottomNavigationBarType.shifting,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_rounded,
              color: Colors.black,
            ),
            label: 'Esplora',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.filter_list_rounded, color: Colors.black),
                MatchHandler().unseenChanges
                    ? Positioned(
                        left: 2,
                        bottom: 7,
                        child: Container(
                            padding: EdgeInsets.all(2),
                            child: Icon(Icons.fiber_new_outlined,
                                color: Colors.red, size: 23)),
                      )
                    : Container(
                        width: 0,
                        height: 0,
                      )
              ],
            ),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_sharp, color: Colors.black),
              label: "Tenants",
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_bubble_rounded,
              color: Colors.black,
            ),
            label: 'I miei appartamenti',
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
              if (index == 1) {
                MatchHandler().unseenChanges = false;
                //print(index);
              }
            },
          );
        },
      ),
    );
  }
}
