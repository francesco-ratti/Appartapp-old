import 'package:appartapp/entities/user.dart';
import 'package:appartapp/widgets/tenant_model.dart';
import 'package:blur/blur.dart';
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

  group('Tenant model testing -->', () {
    testWidgets('Blur is present if there is no match', (tester) async {
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(MediaQuery(
        //MediaQuery required to avoid compilation error
        //MaterialApp required to set a text direction in the widget to test
        data: const MediaQueryData(),
        child: MaterialApp(
          home: TenantModel(
            currentTenant: usr,
            lessor: false,
            match: false,
          ),
        ),
      ));

      expect(find.byType(Blur), findsOneWidget);
    });

    testWidgets('Blur is not present if there is a match', (tester) async {
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(MediaQuery(
        //MediaQuery required to avoid compilation error
        //MaterialApp required to set a text direction in the widget to test
        data: const MediaQueryData(),
        child: MaterialApp(
          home: TenantModel(
            currentTenant: usr,
            lessor: false,
            match: true,
          ),
        ),
      ));

      expect(find.byType(Blur), findsNothing);
    });

    testWidgets('Tenant model correctly notifies that there are no images',
        (tester) async {
      await tester.pumpWidget(MediaQuery(
        //MediaQuery required to avoid compilation error
        //MaterialApp required to set a text direction in the widget to test
        data: const MediaQueryData(),
        child: MaterialApp(
          home: TenantModel(
            currentTenant: usr,
            lessor: false,
            match: true,
          ),
        ),
      ));

      // Create the Finders.
      final noImagesFinder = find.text("No images");

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that the Text widgets appear exactly once in the widget tree.
      expect(noImagesFinder, findsOneWidget);
    });
  });
}
