import 'package:appartapp/classes/apartment.dart';
import 'package:appartapp/classes/connection_exception.dart';
import 'package:dio/dio.dart';

import 'runtime_store.dart';

class ApartmentHandler {
  //SINGLETON PATTERN
  //useful as singleton since network functions will store session cookie here, in cookie jar

  final String urlStrGetNextNewApartment =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/getnextnewapartment";
  final String urlStrGetAllNewApartments =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/getallnewapartments";
  final String urlStrGetOwnedApartments =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/getownedapartments";

  static final ApartmentHandler _apartment = ApartmentHandler._internal();

  factory ApartmentHandler() {
    return _apartment;
  }

  ApartmentHandler._internal();

  Future<List<Apartment>> getOwnedApartments() async {
    var dio = RuntimeStore().dio; //ok

    try {
      Response response = await dio.post(
        urlStrGetOwnedApartments,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode == 200) {
        List apList = response.data as List;

        List<Apartment> ownedApartments = [];
        apList.forEach((element) {
          ownedApartments.add(Apartment.fromMap(element));
        });
        return ownedApartments;
      }
      throw ConnectionException();
    } on DioError {
      throw ConnectionException();
    }
  }

  Future<Apartment?> getNewApartment(Function(Apartment) callback) async {
    var dio = RuntimeStore().dio; //ok

    try {
      Response response = await dio.post(
        urlStrGetNextNewApartment,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode == 200) {
        if (response.data == null) {
          return null;
        }
        Apartment apartment = Apartment.fromMap(response.data as Map);
        callback(apartment);
        return apartment;
      }
      throw ConnectionException();
    } on DioError {
      throw ConnectionException();
    }

    /*
    return Apartment(
        id: 0,
        listingTitle: "Bilocale Milano 2",
        description: "Casa molto carina 2, senza soffitto, senza cucina",
        price: 350,
        address: "Via di Paperone, Paperopoli",
        additionalExpenseDetail: "No, pagamento trimestrale",
        imagesUrl: [
          "assets/house2/img1.jpeg",
          "assets/house2/img2.jpeg",
          "assets/house2/img3.jpeg",
          "assets/house2/img4.jpeg",
        ]);

     */
  }
/*
  Future<List<Apartment>> getAllApartments() async {
    //TODO
    return <Apartment>[];
  }
 */
}
