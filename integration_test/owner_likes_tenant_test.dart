import 'package:appartapp/widgets/tenant_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:appartapp/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2)); // Wait some time

    //   ################        LOG IN OWNER

    // Finds the floating action button to tap on.
    final Finder accedi = find.text('Accedi');

    // Emulate a tap on the floating action button.
    await tester.tap(accedi);

    // Trigger a frame.
    await tester.pumpAndSettle();

    final Finder email = find.byKey(const Key('email'));
    final Finder password = find.byKey(const Key('password'));

    await tester.enterText(email, 'owner@test.it');
    await tester.pumpAndSettle();
    await tester.enterText(password, 'test');
    await tester.pumpAndSettle();

    final Finder button = find.byType(ElevatedButton);

    await tester.pump(const Duration(seconds: 1)); // Wait some time

    await tester.tap(button);
    await tester.pumpAndSettle();

    // Verify we are no more in the access page
    expect(find.text('Accedi'), findsNothing);

    //   #########   OPEN TENANTS EXPLORATION

    final Finder tenants = find.byIcon(Icons.people_sharp);
    await tester.tap(tenants);
    await tester.pumpAndSettle();

    expect(find.byType(TenantViewer), findsOneWidget);

    //  ################   OWNER  LIKES  TENANT

    //the center of origin by default is the top left corner of the screen
    await tester.flingFrom(const Offset(350, 500), const Offset(-350, 0), 5000);
    await tester.pumpAndSettle();

    //################    LOG OUT  OWNER

    final Finder profile = find.byIcon(Icons.person_outline_rounded);
    await tester.tap(profile);
    await tester.pumpAndSettle();

    final Finder exitBtn = find.byKey(const Key('esci'));

    await tester.dragUntilVisible(
        exitBtn, // what I want to find
        find.byKey(const Key('scroll')),
        // widget you want to scroll
        const Offset(0, -100), // delta to move
        duration: const Duration(seconds: 2));

    await tester.tap(exitBtn);
    await tester.pumpAndSettle();

    //  ############    LOG IN TENANT

    // Finds the floating action button to tap on.
    final Finder accedi2 = find.text('Accedi');

    // Emulate a tap on the floating action button.
    await tester.tap(accedi2);

    // Trigger a frame.
    await tester.pumpAndSettle();

    final Finder email2 = find.byKey(const Key('email'));
    final Finder password2 = find.byKey(const Key('password'));

    await tester.enterText(email2, 'tenant@test.it');
    await tester.pumpAndSettle();
    await tester.enterText(password2, 'test');
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 1));

    final Finder button2 = find.byType(ElevatedButton);

    await tester.tap(button2);
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 1)); // Wait some time

    // Verify we are no more in the access page
    expect(find.text('Accedi'), findsNothing);

    //   #########   OPEN MATCH EXPLORATION

    final Finder matches = find.byIcon(Icons.chat_bubble_rounded);
    await tester.tap(matches);
    await tester.pumpAndSettle();

    expect(find.text('Test Apartment'), findsOneWidget);
  });
}
