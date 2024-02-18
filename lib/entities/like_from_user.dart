import 'package:appartapp/entities/apartment.dart';
import 'package:appartapp/entities/user.dart';

class LikeFromUser {
  Apartment? apartment; //TODO REMOVE ?
  User user;

  LikeFromUser(this.apartment, this.user);

  LikeFromUser.fromMap(Map responseMap)
      : apartment = Apartment.fromMap(responseMap["apartment"]),
        user = User.fromMap(responseMap["user"]);
}