import 'package:appartapp/widgets/tab_widget_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TabWidgetLoading shows "Caricamento in corso..."',
      (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(const MediaQuery(
        data: MediaQueryData(), child: MaterialApp(home: TabWidgetLoading())));

    // Create the Finders.
    final loadingTextFinder = find.text("Caricamento in corso...");

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(loadingTextFinder, findsOneWidget);
  });
}
