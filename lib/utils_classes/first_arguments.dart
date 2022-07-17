import 'package:appartapp/entities/apartment.dart';
import 'package:appartapp/entities/like_from_user.dart';

class FirstArguments {
  late Future<Apartment?> firstApartmentFuture;
  late Future<LikeFromUser?> firstTenantFuture;

  FirstArguments(this.firstApartmentFuture, this.firstTenantFuture);
}
