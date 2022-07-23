import 'package:appartapp/entities/apartment.dart';
import 'package:appartapp/entities/like_from_user.dart';
import 'package:appartapp/entities/user.dart';
import 'package:appartapp/model/match_handler.dart';
import 'package:appartapp/utils_classes/first_arguments.dart';
import 'package:appartapp/utils_classes/runtime_store.dart';
import 'package:appartapp/widgets/home_parent.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var mapUsr = {
    'id': 000,
    "email": 'email@email.it',
    'name': 'Mario',
    'surname': 'Roca',
    'birthday': 919551600000,
    'gender': 'M',
    'images': [],
    'bio': "text",
    'reason': 'study',
    'month': 'Settembre',
    'job': 'studente',
    'income': '1600',
    'smoker': 'No',
    'pets': 'Gatto'
  };
  User usr = User.fromMap(mapUsr);
  RuntimeStore().setUser(usr);

  Apartment apartment = Apartment(
      id: 000,
      listingTitle: 'test title',
      description: 'test description',
      price: 500,
      address: 'test address',
      additionalExpenseDetail: 'test expenses',
      imagesDetails: [],
      images: []);

  List<Apartment> apartments = [];
  apartments.add(apartment);

  LikeFromUser likeFromUser = LikeFromUser(apartment, usr);

  Future<List<Apartment>> ownedApartments = Future(() {
    Future.delayed(const Duration(seconds: 1));
    return apartments;
  });

  RuntimeStore().setOwnedApartmentsFuture(ownedApartments);

  Future<LikeFromUser?> firstTenantFuture = Future(() {
    Future.delayed(const Duration(seconds: 1));
    return likeFromUser;
  });

  Future<Apartment?> firstApartmentFuture = Future(() {
    Future.delayed(const Duration(seconds: 1));
    return apartment;
  });

  FirstArguments firstArguments =
      FirstArguments(firstApartmentFuture, firstTenantFuture);

  //Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false,
  //  arguments: firstArguments);

  RuntimeStore().matchHandler = MatchHandler();
  testWidgets('HomeParent has a stack', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(const MediaQuery(
        //MediaQuery required to avoid compilation error
        //MaterialApp required to set a text direction in the widget to test
        data: MediaQueryData(),
        child: MaterialApp(home: HomeParent())));

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Stack widgets appear exactly once in the widget tree.
    expect(find.byType(Stack), findsOneWidget);
  });

  // OTHER TESTS HERE
  // since there is no context in the test, they are skipped
}
