import 'package:appartapp/entities/apartment.dart';
import 'package:appartapp/utils_classes/runtime_store.dart';
import 'package:appartapp/widgets/apartment_model.dart';
import 'package:appartapp/widgets/apartment_viewer.dart';
import 'package:appartapp/widgets/tab_widget.dart';
import 'package:appartapp/widgets/tab_widget_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

void main() {
  Apartment apartment = Apartment(
      id: 000,
      listingTitle: 'test title',
      description: 'test description',
      price: 500,
      address: 'test address',
      additionalExpenseDetail: 'test expenses',
      imagesDetails: [],
      images: []);
  group('Apartment viewer testing for MOBILE  -->', () {
    testWidgets('Apartment viewer has a Sliding Up Panel', (tester) async {
      RuntimeStore().useMobileLayout = true;
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(MediaQuery(
        //MediaQuery required to avoid compilation error
        //MaterialApp required to set a text direction in the widget to test
        data: const MediaQueryData(),
        child: MaterialApp(
          home: ApartmentViewer(
            apartmentLoaded: true,
            currentApartment: apartment,
          ),
        ),
      ));

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that the SlidingUpPanel widgets appear exactly once in the widget tree.
      expect(find.byType(SlidingUpPanel), findsOneWidget);
    });

    testWidgets(
        'CircularProgressIndicator and TabWidgetLoading present if the apartment is not yet loaded',
        (tester) async {
      RuntimeStore().useMobileLayout = true;
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(MediaQuery(
        //MediaQuery required to avoid compilation error
        //MaterialApp required to set a text direction in the widget to test
        data: const MediaQueryData(),
        child: MaterialApp(
          home: ApartmentViewer(
            apartmentLoaded: false,
            currentApartment: apartment,
          ),
        ),
      ));

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that the CircularProgressIndicator and the TabWidgetLoading widgets appear exactly once in the widget tree.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(TabWidgetLoading), findsOneWidget);
    });

    testWidgets(
        'ApartmentModel and TabWidget present if the apartment is loaded',
        (tester) async {
      RuntimeStore().useMobileLayout = true;
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(MediaQuery(
        //MediaQuery required to avoid compilation error
        //MaterialApp required to set a text direction in the widget to test
        data: const MediaQueryData(),
        child: MaterialApp(
          home: ApartmentViewer(
            apartmentLoaded: true,
            currentApartment: apartment,
          ),
        ),
      ));

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that the ApartmentModel and the TabWidget widgets appear exactly once in the widget tree.
      expect(find.byType(ApartmentModel), findsOneWidget);
      expect(find.byType(TabWidget), findsOneWidget);
    });
  });

  group('Apartment viewer testing for TABLET  -->', () {
    testWidgets('No Sliding Up Panel', (tester) async {
      RuntimeStore().useMobileLayout = false;
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(MediaQuery(
        //MediaQuery required to avoid compilation error
        //MaterialApp required to set a text direction in the widget to test
        data: const MediaQueryData(),
        child: MaterialApp(
          home: ApartmentViewer(
            apartmentLoaded: true,
            currentApartment: apartment,
          ),
        ),
      ));

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that the ApartmentModel and the TabWidget widgets appear exactly once in the widget tree.
      expect(find.byType(SlidingUpPanel), findsNothing);
    });

    testWidgets(
        'CircularProgressIndicator and TabWidgetLoading present if the apartment is not yet loaded',
        (tester) async {
      RuntimeStore().useMobileLayout = false;
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(MediaQuery(
        //MediaQuery required to avoid compilation error
        //MaterialApp required to set a text direction in the widget to test
        data: const MediaQueryData(),
        child: MaterialApp(
          home: ApartmentViewer(
            apartmentLoaded: false,
            currentApartment: apartment,
          ),
        ),
      ));

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that the CircularProgressIndicator and the TabWidgetLoading widgets appear exactly once in the widget tree.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(TabWidgetLoading), findsOneWidget);
    });

    testWidgets(
        'ApartmentModel and TabWidget present if the apartment is loaded',
        (tester) async {
      RuntimeStore().useMobileLayout = false;
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(MediaQuery(
        //MediaQuery required to avoid compilation error
        //MaterialApp required to set a text direction in the widget to test
        data: const MediaQueryData(),
        child: MaterialApp(
          home: ApartmentViewer(
            apartmentLoaded: true,
            currentApartment: apartment,
          ),
        ),
      ));

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that the ApartmentModel and the TabWidget widgets appear exactly once in the widget tree.
      expect(find.byType(ApartmentModel), findsOneWidget);
      expect(find.byType(TabWidget), findsOneWidget);
    });
  });
}
