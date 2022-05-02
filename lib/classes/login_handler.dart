import 'package:appartapp/classes/User.dart';
import 'package:appartapp/classes/credentials.dart';
import 'package:appartapp/classes/enum%20LoginResult.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginHandler {
  static String urlStr = "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/login";

  static Future<List> doLogin(String email, String password) async { //TODO make it return user instead of credentials
    var dio = Dio();
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
          return [null,null,LoginResult.wrong_credentials];
        else
          return [null,null,LoginResult.server_error];
      }
      else {
        Map responseMap = response.data;
        Credentials credentials=Credentials(email: responseMap['email'], password: responseMap['password']);
        User user=User.fromMap(responseMap);

        return [credentials, user, LoginResult.ok];
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401)
        return [null, null, LoginResult.wrong_credentials];
      else
        return [null, null, LoginResult.server_error];
    }
  }}