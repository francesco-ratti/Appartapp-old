import 'package:appartapp/widgets/ignore_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Ignore background has an image from the assets', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(const MediaQuery(
      //MediaQuery required to avoid compilation error
      //MaterialApp required to set a text direction in the widget to test
      data: MediaQueryData(),
      child: MaterialApp(
        home: IgnoreBackground(),
      ),
    ));

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Image widgets appear exactly once in the widget tree.
    expect(find.byType(Image), findsOneWidget);
  });
}
