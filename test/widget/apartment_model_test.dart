import 'package:appartapp/entities/apartment.dart';
import 'package:appartapp/widgets/apartment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Apartment model testing ...', () {
    testWidgets('Apartment model correctly notifies that there are no images',
        (tester) async {
      Apartment apartment = Apartment(
          id: 000,
          listingTitle: 'test title',
          description: 'test description',
          price: 500,
          address: 'test address',
          additionalExpenseDetail: 'test expenses',
          imagesDetails: [],
          images: []);
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(MediaQuery(
        //MediaQuery required to avoid compilation error
        //MaterialApp required to set a text direction in the widget to test
        data: const MediaQueryData(),
        child: MaterialApp(
          home: ApartmentModel(
            currentApartment: apartment,
          ),
        ),
      ));

      // Create the Finders.
      final noImagesFinder = find.text("No images");

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that the Text widgets appear exactly once in the widget tree.
      expect(noImagesFinder, findsOneWidget);
    });

    testWidgets('Apartment model shows the images if any', (tester) async {
      Apartment apartment = Apartment(
          id: 000,
          listingTitle: 'test title',
          description: 'test description',
          price: 500,
          address: 'test address',
          additionalExpenseDetail: 'test expenses',
          imagesDetails: [],
          images: [const Image(image: AssetImage('assets/appart.jpg'))]);
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(MediaQuery(
        //MediaQuery required to avoid compilation error
        //MaterialApp required to set a text direction in the widget to test
        data: const MediaQueryData(),
        child: MaterialApp(
          home: ApartmentModel(
            currentApartment: apartment,
          ),
        ),
      ));

      // Create the Finders.
      final noImagesFinder = find.text("No images");

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that the Text widgets appear exactly once in the widget tree.
      expect(noImagesFinder, findsNothing);
    });
  });
}
