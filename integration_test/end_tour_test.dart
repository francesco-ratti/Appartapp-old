import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:appartapp/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Tour correctly completed', (tester) async {
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
  });
}
