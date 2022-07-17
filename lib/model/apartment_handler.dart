import 'package:appartapp/entities/apartment.dart';
import 'package:appartapp/exceptions/connection_exception.dart';
import 'package:dio/dio.dart';

import '../utils_classes/runtime_store.dart';

class ApartmentHandler {

  static final String urlStrGetNextNewApartment =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/getnextnewapartment";
  static final String urlStrGetAllNewApartments =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/getallnewapartments";
  static final String urlStrGetOwnedApartments =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/getownedapartments";
  static final likeApartmentUrlStr =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/likeapartment";
  static final ignoreApartmentUrlStr =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/ignoreapartment";

  static Future<List<Apartment>> getOwnedApartments() async {
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

  static Future<Apartment?> getNewApartment(
      Function(Apartment) callback) async {
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

  static Future<void> _likeDislikeApartment(
      String urlString, int apartmentId, Function onError) async {
    var dio = RuntimeStore().dio; //ok
    try {
      Response response = await dio.post(
        urlString,
        data: {
          "apartmentid": apartmentId,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode != 200) {
        onError();
      }
    } on DioError {
      onError();
    }
  }

  static void likeApartment(int apartmentId, Function onError) async {
    await _likeDislikeApartment(likeApartmentUrlStr, apartmentId, onError);
  }

  static void ignoreApartment(int apartmentId, Function onError) async {
    await _likeDislikeApartment(ignoreApartmentUrlStr, apartmentId, onError);
  }
}
