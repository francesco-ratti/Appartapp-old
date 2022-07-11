import 'package:appartapp/classes/first_arguments.dart';
import 'package:appartapp/classes/match_handler.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/classes/user.dart';
import 'package:appartapp/pages/empty_page.dart';
import 'package:appartapp/pages/houses.dart';
import 'package:appartapp/pages/matches.dart';
import 'package:appartapp/pages/profile_apartments.dart';
import 'package:appartapp/pages/tenants.dart';
import 'package:appartapp/widgets/add_tenant_informations.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _pageIndex = 0;
  User user = RuntimeStore().getUser() as User;

  @override
  Widget build(BuildContext context) {
    //Color bgColor = Colors.yellowAccent;

    for (final Image im in user.images) {
      precacheImage(im.image, context);
    }

    RuntimeStore().tenantInfoUpdated = () {
      setState(() {
        user = RuntimeStore().getUser() as User;
      });
    };

    return Scaffold(
      //backgroundColor: RuntimeStore.backgroundColor,
      body: SafeArea(
        top: false,
        bottom: true,
        child: IndexedStack(
          index: _pageIndex,
          children: <Widget>[
            user.isProfileComplete()
                ? Houses(
                    child: const Text('Esplora'),
                    firstApartmentFuture: ((ModalRoute.of(context)!
                            .settings
                            .arguments) as FirstArguments)
                        .firstApartmentFuture)
                : const AddTenantInformations(textColor: Colors.black),
            Matches(),
            Tenants(
                child: const Text('Esplora'),
                firstTenantFuture: ((ModalRoute.of(context)!.settings.arguments)
                        as FirstArguments)
                    .firstTenantFuture),
            EmptyPage(child: const Text('Chat')),
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
          const BottomNavigationBarItem(
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
                const Icon(Icons.checklist_rounded, color: Colors.black),
                !MatchHandler().isLastShowedMatchDateTimeAvailable() ||
                        MatchHandler().hasUnseenChanges()
                    ? Positioned(
                        left: 2,
                        bottom: 7,
                        child: Container(
                            padding: const EdgeInsets.all(2),
                            child: const Icon(Icons.fiber_new_outlined,
                                color: Colors.red, size: 23)),
                      )
                    : const SizedBox()
              ],
            ),
            label: 'Matches',
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.people_sharp, color: Colors.black),
              label: "Tenants",
              backgroundColor: Colors.white),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_bubble_rounded,
              color: Colors.black,
            ),
            label: 'I miei appartamenti',
          ),
          const BottomNavigationBarItem(
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
                MatchHandler().setChangesAsSeen();
                //print(index);
              }
            },
          );
        },
      ),
    );
  }
}
