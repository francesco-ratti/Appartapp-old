import 'package:appartapp/classes/user.dart';
import 'package:appartapp/classes/apartment.dart';

class LikeFromUser {
  Apartment? apartment; //TODO REMOVE ?
  User user;

  LikeFromUser(this.apartment, this.user);

  LikeFromUser.fromMap(Map responseMap) :
      this.apartment=Apartment.fromMap(responseMap["apartment"]),
      this.user=User.fromMap(responseMap["user"]);

}