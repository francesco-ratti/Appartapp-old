import 'package:appartapp/classes/apartment.dart';
import 'package:appartapp/classes/like_from_user.dart';

class FirstArguments {
  late Future<Apartment> firstApartmentFuture;
  late Future<LikeFromUser> firstTenantFuture;

  FirstArguments(this.firstApartmentFuture, this.firstTenantFuture);
}
