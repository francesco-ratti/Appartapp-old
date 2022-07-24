import 'package:appartapp/widgets/retry_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('RetryWidget has a retry button', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp(
          home: RetryWidget(
            retryCallback: () => {},
            textColor: Colors.black,
          ),
        )));

    // Create the Finders.
    final retryTextFinder = find.text("Riprova");

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(retryTextFinder, findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
