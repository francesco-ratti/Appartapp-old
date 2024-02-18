import 'package:appartapp/pages/edit_profile.dart';
import 'package:appartapp/pages/owned_apartments.dart';
import 'package:appartapp/utils_classes/runtime_store.dart';
import 'package:flutter/material.dart';

class ProfileApartments extends StatefulWidget {
  const ProfileApartments({Key? key}) : super(key: key);

  @override
  _ProfileApartments createState() => _ProfileApartments();
}

class _ProfileApartments extends State<ProfileApartments> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RuntimeStore().useMobileLayout ? mobileLayout() : mobileLayout();
  }
}

DefaultTabController mobileLayout() {
  return DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        elevation: 0,
        title: const TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.person_sharp),
              text: "Il tuo profilo",
            ),
            Tab(
              icon: Icon(Icons.apartment_rounded),
              text: "I tuoi appartamenti",
            ),
          ],
        ),
      ),
      body: const TabBarView(
        children: [
          EditProfile(),
          OwnedApartments(),
        ],
      ),
    ),
  );
}

Scaffold tabletLayout() {
  return Scaffold(
    appBar: AppBar(
        backgroundColor: Colors.brown,
        elevation: 0,
        title: const Row(children: [
          Expanded(
              child: Row(children: [
            Icon(Icons.person_sharp),
            Text("Il tuo profilo")
          ])),
          Expanded(
            child: Row(children: [
              Icon(Icons.apartment_rounded),
              Text("I tuoi appartamenti")
            ]),
          )
        ])),
    body: Row(
      children: [
        const Expanded(flex: 50, child: EditProfile()),
        Expanded(flex: 1, child: Container(color: Colors.brown)),
        const Expanded(flex: 50, child: OwnedApartments())
      ],
    ),
  );
}
