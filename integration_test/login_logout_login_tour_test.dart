import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:appartapp/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'A second user logs in after the first one skips the tour, logs in and logs out',
      (tester) async {
    app.main();

    // await tester.pumpWidget(const MediaQuery(
    //     data: MediaQueryData(), child: MaterialApp(home: LoginOrSignup())));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2)); // Wait some time

    // Finds the floating action button to tap on.
    final Finder welcome = find.text('swipe');
    expect(welcome, findsOneWidget);

    // Emulate a swipe on the floating action button.
    //benvenuto!
    Finder arrow = find.byIcon(Icons.arrow_forward);
    await tester.tap(arrow);
    await tester.pump(const Duration(seconds: 1));
    //non lasciare nulla al caso
    arrow = find.byIcon(Icons.arrow_forward);
    await tester.tap(arrow);
    await tester.pump(const Duration(seconds: 1));
    //abbattiamo i costi
    arrow = find.byIcon(Icons.arrow_forward);
    await tester.tap(arrow);
    await tester.pump(const Duration(seconds: 1));
    //senza discriminazioni
    final Finder done = find.text('Done');

    await tester.tap(done);
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 2)); // Wait some time

    // Verify we are no more in the access page
    expect(find.text("Iniziamo!"), findsOneWidget);

    // Finds the floating action button to tap on.
    Finder accedi = find.text('Accedi');
    await tester.tap(accedi);

    // Trigger a frame.
    await tester.pumpAndSettle();

    final Finder email = find.byKey(const Key('email'));
    final Finder password = find.byKey(const Key('password'));

    await tester.enterText(email, 'pippo@pippo.it');
    await tester.pumpAndSettle();
    await tester.enterText(password, 'pippo');
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 2));

    final Finder button = find.byType(ElevatedButton);

    await tester.tap(button);
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 5)); // Wait some time

    // Verify we are no more in the access page
    expect(find.text('Accedi'), findsNothing);

    //ACCESS DONE HERE - starting to exit

    final Finder profile = find.byIcon(Icons.person_outline_rounded);
    await tester.tap(profile);
    await tester.pumpAndSettle();

    final Finder exitBtn = find.byKey(const Key('esci'));

    await tester.dragUntilVisible(
        exitBtn, // what I want to find
        find.byKey(Key('scroll')),
        // widget you want to scroll
        const Offset(0, -100), // delta to move
        duration: Duration(seconds: 2));

    await tester.tap(exitBtn);
    await tester.pumpAndSettle();

    //EXIT DONE HERE

    expect(find.text("Iniziamo!"), findsOneWidget);

    // Finds the floating action button to tap on.
    Finder accedi2 = find.text('Accedi');
    await tester.tap(accedi2);

    // Trigger a frame.
    await tester.pumpAndSettle();

    final Finder email2 = find.byKey(const Key('email'));
    final Finder password2 = find.byKey(const Key('password'));

    await tester.enterText(email2, 'pippo@pippo.it');
    await tester.pumpAndSettle();
    await tester.enterText(password2, 'pippo');
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 2));

    final Finder button2 = find.byType(ElevatedButton);

    await tester.tap(button2);
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 5)); // Wait some time
  });
}
