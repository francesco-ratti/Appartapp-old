import 'package:appartapp/classes/connection_exception.dart';
import 'package:appartapp/classes/enum_loginresult.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/classes/user.dart';
import 'package:dio/dio.dart';

class LoginHandler {
  static String urlStr =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/login";

  static Future<List> doLogin(String email, String password) async {
    //TODO make it return user instead of credentials
    var dio = RuntimeStore().dio;
    try {
      Response response = await dio.post(
        urlStr,
        data: {"email": email, "password": password},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode != 200) {
        if (response.statusCode == 401)
          return [null,LoginResult.wrong_credentials];
        else
          return [null,LoginResult.server_error];
      }
      else {
        Map responseMap = response.data;
        User user=User.fromMap(responseMap);

        return [user, LoginResult.ok];
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.other ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.cancel) {
        throw ConnectionException();
      }
      if (e.response?.statusCode == 401)
        return [null, LoginResult.wrong_credentials];
      return [null, LoginResult.server_error];
    }
  }

  static Future<List> doLoginWithCookies() async { //TODO make it return user instead of credentials
    var dio = RuntimeStore().dio;
    try {
      Response response = await dio.post(
        urlStr,
        //data: {"email": email, "password": password},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode != 200) {
        if (response.statusCode == 401)
          return [null,LoginResult.wrong_credentials];
        else
          return [null,LoginResult.server_error];
      }
      else {
        Map responseMap = response.data;
        User user=User.fromMap(responseMap);

        return [user, LoginResult.ok];
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.other ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.cancel) {
        throw ConnectionException();
      }
      if (e.response?.statusCode == 401)
        return [null, LoginResult.wrong_credentials];
      return [null, LoginResult.server_error];
    }
  }
}