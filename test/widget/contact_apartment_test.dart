import 'package:appartapp/entities/apartment.dart';
import 'package:appartapp/entities/user.dart';
import 'package:appartapp/widgets/contact_apartment.dart';
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
  User owner = User.fromMap(mapUsr);
  Apartment apartment = Apartment(
      id: 000,
      listingTitle: 'test title',
      description: 'test description',
      price: 500,
      address: 'test address',
      additionalExpenseDetail: 'test expenses',
      imagesDetails: [],
      images: [],
      owner: owner);
  group('Contact apartment testing -->', () {
    testWidgets('The button to write an email is present', (tester) async {
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(MediaQuery(
          data: const MediaQueryData(),
          child: MaterialApp(
            home: ContactApartment(
              textColor: Colors.black,
              apartment: apartment,
            ),
          )));

      // Create the Finders.
      final emailTextFinder = find.text("Scrivi un'email");

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that the Text widgets appear exactly once in the widget tree.
      expect(emailTextFinder, findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
