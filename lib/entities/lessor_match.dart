import 'package:appartapp/entities/apartment.dart';

class LessorMatch {
  Apartment apartment;
  DateTime time;

  LessorMatch(this.apartment, this.time);

  LessorMatch.fromMap(Map map)
      : this.apartment = Apartment.fromMap(map['apartment']),
        this.time = DateTime.fromMillisecondsSinceEpoch(map['matchDate']);
}