import 'package:appartapp/entities/like_from_user.dart';
import 'package:appartapp/exceptions/connection_exception.dart';
import 'package:appartapp/utils_classes/runtime_store.dart';
import 'package:dio/dio.dart';

class UserHandler {

  static final String urlStrGetNextNewUser =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/getnextnewuser";

  /*final String urlStrGetAllNewUsers =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/getallnewusers";*/

  static String editSensitiveUrlStr =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/editsensitive";

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
    } on DioError {
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
    } on DioError {
      onError();
    }
  }
}
