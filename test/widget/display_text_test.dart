import 'package:appartapp/widgets/display_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows building and interacting
  // with widgets in the test environment.
  testWidgets('DisplayText shows the title and the content', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(const MediaQuery(
        //MediaQuery required to avoid compilation error
        //MaterialApp required to set a text direction in the widget to test
        data: MediaQueryData(),
        child: MaterialApp(
            home: DisplayText(title: 'title test', content: 'content test'))));

    // Create the Finders.
    final titleFinder = find.text('title test');
    final contentFinder = find.text('content test');

    // Use the `findsOneWidget` matcher provided by flutter_test to
    // verify that the Text widgets appear exactly once in the widget tree.
    expect(titleFinder, findsOneWidget);
    expect(contentFinder, findsOneWidget);
  });
}
