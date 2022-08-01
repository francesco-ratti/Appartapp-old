import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:appartapp/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Log out for a logged in user', (tester) async {
    app.main();
    // await tester.pumpWidget(const MediaQuery(
    //     data: MediaQueryData(), child: MaterialApp(home: LoginOrSignup())));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2)); // Wait some time

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
  });
}
