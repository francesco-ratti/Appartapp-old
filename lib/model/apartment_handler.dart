import 'dart:io';

import 'package:appartapp/entities/apartment.dart';
import 'package:appartapp/exceptions/connection_exception.dart';
import 'package:dio/dio.dart';

import '../utils_classes/runtime_store.dart';

class ApartmentHandler {
  static const String urlStrGetNextNewApartment =
      "http://10.0.2.2/appart-1.0-SNAPSHOT/api/reserved/getnextnewapartment";
  static const String urlStrGetAllNewApartments =
      "http://10.0.2.2/appart-1.0-SNAPSHOT/api/reserved/getallnewapartments";
  static const String urlStrGetOwnedApartments =
      "http://10.0.2.2/appart-1.0-SNAPSHOT/api/reserved/getownedapartments";
  static const likeApartmentUrlStr =
      "http://10.0.2.2/appart-1.0-SNAPSHOT/api/reserved/likeapartment";
  static const ignoreApartmentUrlStr =
      "http://10.0.2.2/appart-1.0-SNAPSHOT/api/reserved/ignoreapartment";
  static const String createApartmentUrlStr =
      "http://10.0.2.2/appart-1.0-SNAPSHOT/api/reserved/createapartment";

  static const String editApartmentUrlStr =
      "http://10.0.2.2/appart-1.0-SNAPSHOT/api/reserved/editapartment";

  static const String removeImagesUrlStr =
      "http://10.0.2.2/appart-1.0-SNAPSHOT/api/reserved/deleteapartmentimage";

  static const String addImagesUrlStr =
      "http://10.0.2.2/appart-1.0-SNAPSHOT/api/reserved/addapartmentimage";

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
        for (var element in apList) {
          ownedApartments.add(Apartment.fromMap(element));
        }
        return ownedApartments;
      }
      throw ConnectionException();
    } on DioException {
      throw ConnectionException();
    }
  }

  static Future<Apartment?> getNewApartment(Function(Apartment) callback) async {
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
    } on DioException {
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

  static Future<void> _likeDislikeApartment(String urlString, int apartmentId, Function onError) async {
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
    } on DioException {
      onError();
    }
  }

  static void likeApartment(int apartmentId, Function onError) async {
    await _likeDislikeApartment(likeApartmentUrlStr, apartmentId, onError);
  }

  static void ignoreApartment(int apartmentId, Function onError) async {
    await _likeDislikeApartment(ignoreApartmentUrlStr, apartmentId, onError);
  }

  static void createApartment(
      Function cbk,
      String listingTitle,
      String description,
      String additionalExpenseDetail,
      int price,
      String address,
      List<File> files,
      Function onError) async {
    var dio = RuntimeStore().dio; //ok
    try {
      var formData = FormData();

      formData.fields.add(MapEntry("listingtitle", listingTitle));
      formData.fields.add(MapEntry("description", description));
      formData.fields
          .add(MapEntry("additionalexpensedetail", additionalExpenseDetail));
      formData.fields.add(MapEntry("price", price.toString()));
      formData.fields.add(MapEntry("address", address));

      for (final File file in files) {
        MultipartFile mpfile =
            await MultipartFile.fromFile(file.path, filename: "filename.jpg");
        formData.files.add(MapEntry("images", mpfile));
      }

      Response response = await dio.post(
        createApartmentUrlStr,
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "multipart/form-data"},
        ),
      );

      if (response.statusCode != 200) onError();

      cbk();
    } on DioException {
      onError();
      cbk();
    }
  }

  static void removeImage(Function cbk, String imageId, String apartmentId,
      Function onError) async {
    var dio = RuntimeStore().dio; //ok
    try {
      Response response = await dio.post(
        removeImagesUrlStr,
        data: {"imageid": imageId, "apartmentid": apartmentId},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode != 200) onError();

      cbk();
    } on DioException {
      onError();
      cbk();
    }
  }

  static void editApartment(
      Function cbk,
      int id,
      String listingTitle,
      String description,
      String additionalExpenseDetail,
      int price,
      String address,
      Function onError) async {
    var dio = RuntimeStore().dio; //ok
    try {
      Response response = await dio.post(
        editApartmentUrlStr,
        data: {
          "id": id,
          "listingtitle": listingTitle,
          "description": description,
          "additionalexpensedetail": additionalExpenseDetail,
          "price": price.toString(),
          "address": address
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode != 200) onError();

      cbk();
    } on DioException {
      onError();
      cbk();
    }
  }

  static void addImages(
      Function cbk, int id, List<File> files, Function onError) async {
    var dio = RuntimeStore().dio; //ok
    try {
      var formData = FormData();

      formData.fields.add(MapEntry("id", id.toString()));

      for (final File file in files) {
        MultipartFile mpfile =
            await MultipartFile.fromFile(file.path, filename: "filename.jpg");
        formData.files.add(MapEntry("images", mpfile));
      }

      Response response = await dio.post(
        addImagesUrlStr,
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "multipart/form-data"},
        ),
      );

      if (response.statusCode != 200) onError();

      cbk();
    } on DioException {
      onError();
      cbk();
    }
  }
}
