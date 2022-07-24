import 'package:appartapp/entities/apartment.dart';
import 'package:appartapp/entities/user.dart';
import 'package:appartapp/widgets/tab_widget.dart';
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
    'bio': "test bio",
    'reason': 'study',
    'month': 'Settembre',
    'job': 'studente',
    'income': '1600',
    'smoker': 'No',
    'pets': 'Gatto'
  };
  User usr = User.fromMap(mapUsr);

  Apartment apartment = Apartment(
      id: 000,
      listingTitle: 'test title',
      description: 'test description',
      price: 500,
      address: 'test address',
      additionalExpenseDetail: 'test expenses',
      imagesDetails: [],
      images: []);

  testWidgets('TabWidget has all the information of the apartment',
      (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp(
          home: TabWidget(
              scrollController: ScrollController(),
              owner: usr,
              currentApartment: apartment,
              showContact: false),
        )));

    // Create the Finders.
    final titleTextFinder = find.text("test title");
    final descTextFinder = find.text("test description");
    final addressTextFinder = find.text("test address");
    final expensesTextFinder = find.text("test expenses");

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(titleTextFinder, findsOneWidget);
    expect(descTextFinder, findsOneWidget);
    expect(addressTextFinder, findsOneWidget);
    expect(expensesTextFinder, findsOneWidget);
  });

  testWidgets('TabWidget has the owner and chat button', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp(
          home: TabWidget(
              scrollController: ScrollController(),
              owner: usr,
              currentApartment: apartment,
              showContact: true),
        )));

    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });

  testWidgets('TabWidget has chat button when showContact: false',
      (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp(
          home: TabWidget(
              scrollController: ScrollController(),
              owner: usr,
              currentApartment: apartment,
              showContact: false),
        )));

    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('TabWidget has owner button when owner: null', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp(
          home: TabWidget(
              scrollController: ScrollController(),
              currentApartment: apartment,
              showContact: false),
        )));

    expect(find.byType(ElevatedButton), findsNothing);
  });
}
