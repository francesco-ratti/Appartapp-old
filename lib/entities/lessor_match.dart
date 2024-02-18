import 'package:appartapp/entities/apartment.dart';

class LessorMatch {
  Apartment apartment;
  DateTime time;

  LessorMatch(this.apartment, this.time);

  LessorMatch.fromMap(Map map)
      : apartment = Apartment.fromMap(map['apartment']),
        time = DateTime.fromMillisecondsSinceEpoch(map['matchDate']);
}