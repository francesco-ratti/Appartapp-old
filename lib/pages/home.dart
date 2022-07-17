import 'package:appartapp/entities/apartment.dart';
import 'package:appartapp/entities/user.dart';
import 'package:appartapp/model/apartment_handler.dart';
import 'package:appartapp/model/match_handler.dart';
import 'package:appartapp/pages/add_apartment.dart';
import 'package:appartapp/pages/houses.dart';
import 'package:appartapp/pages/matches.dart';
import 'package:appartapp/pages/profile_apartments.dart';
import 'package:appartapp/pages/tenants.dart';
import 'package:appartapp/utils_classes/first_arguments.dart';
import 'package:appartapp/utils_classes/runtime_store.dart';
import 'package:appartapp/widgets/retry_widget.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _pageIndex = 0;
  User user = RuntimeStore().getUser() as User;
  bool _loadingOwnedApartments = true;
  bool _networkError = false;
  bool _ownsApartments = true;

  void callbck(bool ownsApartments) {
    setState(() {
      _ownsApartments = ownsApartments;
      _networkError = false;
      _loadingOwnedApartments = false;

      Future<List<Apartment>> newOwnedApartments =
          ApartmentHandler().getOwnedApartments();
      RuntimeStore().setOwnedApartmentsFuture(newOwnedApartments);
    });
  }

  @override
  void dispose() {
    super.dispose();
    RuntimeStore().removeApartmentAddedCbk(callbck);
  }

  @override
  void initState() {
    super.initState();
    RuntimeStore().addApartmentAddedCbk(callbck);

    RuntimeStore().getOwnedApartments()!.then((value) {
      setState(() {
        _loadingOwnedApartments = false;
        _ownsApartments = value.isNotEmpty;
      });
    }).onError((error, stackTrace) {
      RuntimeStore()
          .setOwnedApartmentsFuture(ApartmentHandler().getOwnedApartments());
      RuntimeStore().getOwnedApartments()!.then((value) {
        setState(() {
          _loadingOwnedApartments = false;
          _ownsApartments = value.isNotEmpty;
        });
      }).onError((error, stackTrace) {
        setState(() {
          _loadingOwnedApartments = false;
          _networkError = true;
        });
      });
    });
  }

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
                : RetryWidget(
              textColor: Colors.white,
              backgroundColor: RuntimeStore.backgroundColor,
              message:
              "Aggiungi le tue informazioni da locatario per cercare appartamenti.\nSe non lo farai, potrai solamente inserire appartamenti da locatore.",
              retryButtonText: "Completa profilo",
              retryCallback: () {
                Navigator.pushNamed(context, "/edittenants");
              },
            ),
            Matches(),
            _loadingOwnedApartments
                ? const Center(
                child: CircularProgressIndicator(
                  value: null,
                ))
                : (_networkError
                ? RetryWidget(
              retryCallback: () {
                setState(() {
                  _networkError = false;
                  _loadingOwnedApartments = true;
                });
                RuntimeStore().setOwnedApartmentsFuture(
                    ApartmentHandler().getOwnedApartments());
                RuntimeStore().getOwnedApartments()!.then((value) {
                  setState(() {
                    _loadingOwnedApartments = false;
                    _ownsApartments = value.isNotEmpty;
                  });
                }).onError((error, stackTrace) {
                  setState(() {
                    _loadingOwnedApartments = false;
                    _networkError = true;
                  });
                });
              },
              textColor: Colors.white,
              backgroundColor: RuntimeStore.backgroundColor,
            )
                : (_ownsApartments
                ? Tenants(
                child: const Text('Esplora'),
                firstTenantFuture: ((ModalRoute.of(context)!
                    .settings
                    .arguments) as FirstArguments)
                    .firstTenantFuture)
                : RetryWidget(
              retryCallback: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AddApartment()));
                            },
              textColor: Colors.white,
              backgroundColor: RuntimeStore.backgroundColor,
              message:
              "Devi aggiungere un appartamento prima di poter vedere e mettere like alle persone interessate ai tuoi appartamenti.",
              retryButtonText: "Aggiungi un appartamento",
            ))),
            /*EmptyPage(child: const Text('Chat')),*/
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
                //const Icon(Icons.checklist_rounded, color: Colors.black),
                const Icon(Icons.chat_bubble_rounded, color: Colors.black),
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
              label: "Locatari",
              backgroundColor: Colors.white),
          /*const BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_bubble_rounded,
              color: Colors.black,
            ),
            label: 'I miei appartamenti',
          ),*/
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
