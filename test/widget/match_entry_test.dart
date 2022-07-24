import 'package:appartapp/entities/apartment.dart';
import 'package:appartapp/entities/lessor_match.dart';
import 'package:appartapp/widgets/match_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('Match entry testing ...', () {
    MockBuildContext _mockContext;
    _mockContext = MockBuildContext();

    testWidgets('Match entry has a CircleAvatar', (tester) async {
      Apartment apartment = Apartment(
          id: 000,
          listingTitle: 'test title',
          description: 'test description',
          price: 500,
          address: 'test address',
          additionalExpenseDetail: 'test expenses',
          imagesDetails: [],
          images: [const Image(image: AssetImage('assets/appart.jpg'))]);

      LessorMatch lessorMatch = LessorMatch(apartment, DateTime.now());

      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(MediaQuery(
        //MediaQuery required to avoid compilation error
        //MaterialApp required to set a text direction in the widget to test
        data: const MediaQueryData(),
        child: MaterialApp(
          home: Scaffold(
            body: MatchEntry(
              match: lessorMatch,
              onTileTap: (_mockContext, lessorMatch) {},
            ),
          ),
        ),
      ));

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that the CircleAvatar widgets appear exactly once in the widget tree.
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('No CircleAvatar if the apartment has no images',
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

      LessorMatch lessorMatch = LessorMatch(apartment, DateTime.now());

      await tester.pumpWidget(MediaQuery(
        //MediaQuery required to avoid compilation error
        //MaterialApp required to set a text direction in the widget to test
        data: const MediaQueryData(),
        child: MaterialApp(
          home: Scaffold(
            body: MatchEntry(
              match: lessorMatch,
              onTileTap: (_mockContext, lessorMatch) {},
            ),
          ),
        ),
      ));

      expect(find.byType(CircleAvatar), findsNothing);
    });
  });
}
