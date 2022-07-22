import 'package:appartapp/utils_classes/email_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Email validator ...', () {
    test('Emails are correct', () {
      expect(EmailValidator.isEmailValid('mario.roca21@gmail.com'), true);
      expect(EmailValidator.isEmailValid('A@B.C'), true);
      expect(EmailValidator.isEmailValid('A.A.A@B.C'), true);
    });
    test('Emails are not correct', () {
      expect(EmailValidator.isEmailValid('mario.roca21gmail.com'), false);
      expect(EmailValidator.isEmailValid('A.AB.C'), false);
      expect(EmailValidator.isEmailValid('A@BC'), false);
      expect(EmailValidator.isEmailValid('A.A@@B.C'), false);
      expect(EmailValidator.isEmailValid('A@.C'), false);
      expect(EmailValidator.isEmailValid('A@B.'), false);
      expect(EmailValidator.isEmailValid('@B.C'), false);
      expect(EmailValidator.isEmailValid('A'), false);
    });
  });
}
