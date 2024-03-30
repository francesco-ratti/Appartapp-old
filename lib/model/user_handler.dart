import 'dart:io';

import 'package:appartapp/entities/like_from_user.dart';
import 'package:appartapp/entities/user.dart';
import 'package:appartapp/enums/enum_gender.dart';
import 'package:appartapp/enums/enum_month.dart';
import 'package:appartapp/enums/enum_temporalq.dart';
import 'package:appartapp/exceptions/connection_exception.dart';
import 'package:appartapp/utils_classes/runtime_store.dart';
import 'package:dio/dio.dart';

class UserHandler {
  static const String urlStrGetNextNewUser =
      "http://localhost:8080/appart-1.0-SNAPSHOT/api/reserved/getnextnewuser";

  static const String editUserUrlStr =
      "http://localhost:8080/appart-1.0-SNAPSHOT/api/reserved/edituser";

  /*final String urlStrGetAllNewUsers =
      "http://localhost:8080/appart-1.0-SNAPSHOT/api/reserved/getallnewusers";*/

  static const String editSensitiveUrlStr =
      "http://localhost:8080/appart-1.0-SNAPSHOT/api/reserved/editsensitive";

  static const likeUserUrlStr =
      "http://localhost:8080/appart-1.0-SNAPSHOT/api/reserved/likeuser";
  static const ignoreUserUrlStr =
      "http://localhost:8080/appart-1.0-SNAPSHOT/api/reserved/ignoreuser";

  static const String addImagesUrlStr =
      "http://localhost:8080/appart-1.0-SNAPSHOT/api/reserved/adduserimage";
  static const String removeImagesUrlStr =
      "http://localhost:8080/appart-1.0-SNAPSHOT/api/reserved/deleteuserimage";

  static Future<LikeFromUser?> getNewLikeFromUser(
      Function(LikeFromUser) callback) async {
    var dio = RuntimeStore().dio; //ok

    try {
      Response response = await dio.post(
        urlStrGetNextNewUser,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode == 200) {
        if (response.data == null) return null;
        LikeFromUser likeFromUser = LikeFromUser.fromMap(response.data as Map);
        callback(likeFromUser);
        return likeFromUser;
      }
      throw ConnectionException();
    } on DioException {
      throw ConnectionException();
    }
  }

  static void updatePassword(String email, String oldpassword,
      String newpassword, Function onComplete, Function onError) async {
    var dio = RuntimeStore().dio; //ok
    try {
      Response response = await dio.post(
        editSensitiveUrlStr,
        data: {"password": oldpassword, "newpassword": newpassword},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode == 200) {
        onComplete();
      } else {
        onError();
      }
    } on DioException {
      onError();
    }
  }

  static void editTenantInformation(String bio,
      String reason,
      String job,
      String income,
      String pets,
      Month? month,
      TemporalQ? smoker,
      Function(User) onComplete,
      Function onError) async {
    var dio = RuntimeStore().dio; //ok
    try {
      Response response = await dio.post(
        editUserUrlStr,
        data: {
          "bio": bio,
          "reason": reason,
          "job": job,
          "income": income,
          "pets": pets,
          "month": month == null ? "" : month.toShortString(),
          "smoker": smoker == null ? "" : smoker.toShortString()
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode == 200) {
        Map responseMap = response.data;
        User user = User.fromMap(responseMap);

        onComplete(user);
      } else {
        onError();
      }
    } on DioException {
      onError();
    }
  }

  static Future<void> _likeIgnoreNetworkFunction(String urlString, int userId, int apartmentId, Function onError) async {
    var dio = RuntimeStore().dio; //ok
    try {
      Response response = await dio.post(
        urlString,
        data: {
          "userid": userId, //the tenant I like or ignore
          "apartmentid": apartmentId
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

  static void likeUser(int tenantId, int apartmentId, Function onError) async {
    await _likeIgnoreNetworkFunction(
        likeUserUrlStr, tenantId, apartmentId, onError);
  }

  static void ignoreUser(
      int tenantId, int apartmentId, Function onError) async {
    await _likeIgnoreNetworkFunction(
        ignoreUserUrlStr, tenantId, apartmentId, onError);
  }

  static void addImages(
      Function cbk, List<File> files, Function onError) async {
    var dio = RuntimeStore().dio; //ok
    try {
      var formData = FormData();

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

      if (response.statusCode != 200) {
        onError();
      }

      cbk();
    } on DioException {
      onError();
      cbk();
    }
  }

  static void removeImage(Function cbk, String id, Function onError) async {
    var dio = RuntimeStore().dio; //ok
    try {
      Response response = await dio.post(
        removeImagesUrlStr,
        data: {"id": id},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode != 200) {
        onError();
      }

      cbk();
    } on DioException {
      onError();
      cbk();
    }
  }

  static void editInformation(Function cbk, String name, String surname,
      DateTime birthday, Gender gender, Function onError) async {
    var dio = RuntimeStore().dio; //ok
    try {
      Response response = await dio.post(
        editUserUrlStr,
        data: {
          "name": name,
          "surname": surname,
          "birthday": birthday.millisecondsSinceEpoch.toString(),
          "gender": gender.toShortString(),
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode != 200) {
        onError();
      }
      cbk();
    } on DioException {
      onError();
      cbk();
    }
  }

  static void updateEmail(
      String email,
      String password,
      Function(bool, String) updateUi,
      Function(User) onComplete,
      Function onConnectionError) async {
    updateUi(true, "");
    var dio = RuntimeStore().dio; //ok
    try {
      Response response = await dio.post(
        editSensitiveUrlStr,
        data: {
          "newemail": email,
          "password": password,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode == 200) {
        Map responseMap = response.data;
        User newUser = User.fromMap(responseMap);

        onComplete(newUser);
      } else if (response.statusCode == 401) {
        //unauthorized
        updateUi(false, "Password errata");
      } else {
        updateUi(false, "");
        onConnectionError();
      }
    } on DioException catch (e) {
      updateUi(false, "");

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.cancel) {
        onConnectionError();
      } else if (e.response?.statusCode == 401) {
        //unauthorized
        updateUi(false, "Password errata");
      } else {
        onConnectionError();
      }
    }
  }

  static Future<String?> getCreditInfo() async {
    // TODO(Mario): fetch credit info from the server
    await Future.delayed(Duration(seconds: 1)); // Simulating network delay
    return null;
    return "Credit info: €100";
  }

  static Future<void> addCreditInfo(File file) async {
    // TODO(Mario): save the file and update the credit info accordingly
    await Future.delayed(Duration(seconds: 1)); // Simulating file upload delay
    print('File uploaded: ${file.path}');
  }
}
