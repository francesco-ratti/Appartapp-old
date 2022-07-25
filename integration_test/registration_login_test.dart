import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:appartapp/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Log in succesfull for a registered user', (tester) async {
    app.main();
    // await tester.pumpWidget(const MediaQuery(
    //     data: MediaQueryData(), child: MaterialApp(home: LoginOrSignup())));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2)); // Wait some time

    // Finds the floating action button to tap on.
    final Finder accedi = find.text('Accedi');

    // Emulate a tap on the floating action button.
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
  });
}
