import 'package:appartapp/classes/User.dart';
import 'package:appartapp/classes/apartment.dart';

class FirstArguments {
  late Future<Apartment> firstApartmentFuture;
  late Future<User> firstTenantFuture;

  FirstArguments(this.firstApartmentFuture, this.firstTenantFuture);
}
