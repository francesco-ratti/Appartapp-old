import '../exceptions/unauthorized_exception.dart';
import 'apartment.dart';
import 'package:dio/dio.dart';
import '../exceptions/network_exception.dart';
import 'runtime_store.dart';

import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

class ApartmentHandler {
  //SINGLETON PATTERN
  final String urlStrGetNextNewApartment="http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/getnextnewapartment";
  final String urlStrGetAllNewApartments="http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/getallnewapartments";

  var cookieJar=CookieJar();

  static final ApartmentHandler _apartment = ApartmentHandler._internal();

  factory ApartmentHandler() {
    return _apartment;
  }

  ApartmentHandler._internal();

  //useful as singleton since network functions will store session cookie here

  Future<Apartment> getNewApartment() async {
    //TODO test

    /*
    var dio = Dio();
    dio.interceptors.add(CookieManager(cookieJar));

    try {
      Response response = await dio.post(
        urlStrGetNextNewApartment,
        data: {"email": RuntimeStore().getEmail(), "password": RuntimeStore().getPassword()},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode == 401)
        throw new UnauthorizedException();
      else if (response.statusCode == 200) {
        return Apartment.fromMap(response.data as Map);
      }
      else
        throw new NetworkException();
    } on DioError catch (e) {
      if (e.response?.statusCode == 401)
        throw new UnauthorizedException();
      else
        throw new NetworkException();
    }*/

    return Apartment(listingTitle: "Bilocale Milano 2", description: "Casa molto carina 2, senza soffitto, senza cucina", price: 350, address: "Via di Paperone, Paperopoli", additionalExpenseDetail: "No, pagamento trimestrale", imagesUrl: [
      "assets/house2/img1.jpeg",
      "assets/house2/img2.jpeg",
      "assets/house2/img3.jpeg",
      "assets/house2/img4.jpeg",
    ]);
  }

  Future<List<Apartment>> getAllApartments() async {
    //TODO
    return <Apartment>[];
  }
}