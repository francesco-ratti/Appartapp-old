import 'package:appartapp/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:mockito/mockito.dart';
//import 'package:mockito/annotations.dart';
//import 'user.mocks.dart';

//@GenerateMocks([User])
void main() {
  group('Testing user...', () {
    test('Checking a complete profile', () {
      var mapUsr = {
        'id': 000,
        "email": 'email@email.it',
        'name': 'Mario',
        'surname': 'Roca',
        'birthday': 919551600000,
        'gender': 'M',
        'images': [],
        'bio': "text",
        'reason': 'study',
        'month': 'Settembre',
        'job': 'studente',
        'income': '1600',
        'smoker': 'No',
        'pets': 'Gatto'
      };
      User usr = User.fromMap(mapUsr);

      expect(usr.isProfileComplete(), true);
      expect(usr.hasPets(), true);
    });

    test('Checking an incomplete profile', () {
      var mapUsr = {
        'id': 000,
        "email": 'email@email.it',
        'name': 'Mario',
        'surname': 'Roca',
        'birthday': 919551600000,
        'gender': 'M',
        'images': [],
        'bio': "text",
        'reason': '', //ABSENT INFO
        'month': 'Settembre',
        'job': 'studente',
        'income': '1600',
        'smoker': 'No',
        'pets': 'Gatto'
      };
      User usr = User.fromMap(mapUsr);

      expect(usr.isProfileComplete(), false);
    });

    test('Checking an incomplete profile', () {
      var mapUsr = {
        'id': 000,
        "email": 'email@email.it',
        'name': 'Mario',
        'surname': 'Roca',
        'birthday': 919551600000,
        'gender': 'M',
        'images': [],
        'bio': "text",
        'reason': 'study',
        'month': 'Settembre',
        'job': 'studente',
        'income': '', //ABSENT INFO
        'smoker': 'No',
        'pets': 'Gatto'
      };
      User usr = User.fromMap(mapUsr);

      expect(usr.isProfileComplete(), false);
    });

    test('Checking an incomplete profile', () {
      var mapUsr = {
        'id': 000,
        "email": 'email@email.it',
        'name': 'Mario',
        'surname': 'Roca',
        'birthday': 919551600000,
        'gender': 'M',
        'images': [],
        'bio': "", //ABSENT INFO
        'reason': 'study',
        'month': 'Settembre',
        'job': 'studente',
        'income': '1600',
        'smoker': 'No',
        'pets': 'Gatto'
      };
      User usr = User.fromMap(mapUsr);

      expect(usr.isProfileComplete(), false);
    });

    test('Checking an incomplete profile', () {
      var mapUsr = {
        'id': 000,
        "email": 'email@email.it',
        'name': 'Mario',
        'surname': 'Roca',
        'birthday': 919551600000,
        'gender': 'M',
        'images': [],
        'bio': "text",
        'reason': 'study',
        'month': 'Settembre',
        'job': '', //ABSENT INFO
        'income': '1600',
        'smoker': 'No',
        'pets': 'Gatto'
      };
      User usr = User.fromMap(mapUsr);

      expect(usr.isProfileComplete(), false);
    });

    test('Checking a complete profile without pets', () {
      var mapUsr = {
        'id': 000,
        "email": 'email@email.it',
        'name': 'Mario',
        'surname': 'Roca',
        'birthday': 919551600000,
        'gender': 'M',
        'images': [],
        'bio': "text",
        'reason': 'study',
        'month': 'Settembre',
        'job': 'student',
        'income': '1600',
        'smoker': 'No',
        'pets': ''
      };
      User usr = User.fromMap(mapUsr);

      expect(usr.isProfileComplete(), true);
      expect(usr.hasPets(), false);
    });
  });
}
