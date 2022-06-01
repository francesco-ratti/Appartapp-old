import 'package:appartapp/pages/add_apartment.dart';
import 'package:appartapp/pages/edit_profile.dart';
import 'package:appartapp/pages/owned_apartments.dart';
import 'package:flutter/material.dart';

class ProfileApartments extends StatefulWidget {
  ProfileApartments();

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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          elevation: 0,
          title: TabBar(
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
        body: TabBarView(
          children: [
            EditProfile(),
            OwnedApartments(),
          ],
        ),
      ),
    );
  }
}
