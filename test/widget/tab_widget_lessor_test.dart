import 'package:appartapp/entities/user.dart';
import 'package:appartapp/widgets/tab_widget_lessor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var mapUsr = {
    'id': 000,
    "email": 'email@email.it',
    'name': 'Mario',
    'surname': 'Roca',
    'birthday': 919551600000,
    'gender': 'M',
    'images': [],
    'bio': "test bio",
    'reason': 'study',
    'month': 'Settembre',
    'job': 'studente',
    'income': '1600',
    'smoker': 'No',
    'pets': 'Gatto'
  };
  User usr = User.fromMap(mapUsr);

  testWidgets('TabWidgetLessor has all the information of the lessor',
      (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp(
          home: TabWidgetLessor(
            scrollController: ScrollController(),
            currentLessor: usr,
          ),
        )));

    // Create the Finders.
    final nameTextFinder = find.text("Mario Roca");
    final bioTextFinder = find.text("test bio");
    final sexTextFinder = find.text("Maschile");
    final birthdayTextFinder = find.text(
        "${usr.birthday.day.toString().padLeft(2, '0')}-${usr.birthday.month.toString().padLeft(2, '0')}-${usr.birthday.year.toString()}");

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(nameTextFinder, findsOneWidget);
    expect(bioTextFinder, findsOneWidget);
    expect(sexTextFinder, findsOneWidget);
    expect(birthdayTextFinder, findsOneWidget);
  });
}
