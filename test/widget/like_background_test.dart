import 'package:appartapp/widgets/like_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  //TODO: run this test because at the moment the image is not in the assets
  testWidgets('LikeBackground has an image from the assets', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(const MediaQuery(
      //MediaQuery required to avoid compilation error
      //MaterialApp required to set a text direction in the widget to test
      data: MediaQueryData(),
      child: MaterialApp(
        home: LikeBackground(),
      ),
    ));

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Image widgets appear exactly once in the widget tree.
    expect(find.byType(Image), findsOneWidget);
  });
}
