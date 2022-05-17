import 'package:appartapp/classes/user.dart';
import 'package:appartapp/classes/apartment.dart';
import '../exceptions/unauthorized_exception.dart';
import 'package:dio/dio.dart';
import '../exceptions/network_exception.dart';
import 'like_from_user.dart';
import 'runtime_store.dart';

import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

class UserHandler {
  //SINGLETON PATTERN
  //useful as singleton since network functions will store session cookie here, in cookie jar

  final String urlStrGetNextNewUser =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/getnextnewuser";
  final String urlStrGetAllNewUsers =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/getallnewusers";

  var cookieJar = CookieJar();

  static final UserHandler _user = UserHandler._internal();

  factory UserHandler() {
    return _user;
  }

  UserHandler._internal();

  Future<LikeFromUser> getNewLikeFromUser(Function(LikeFromUser) callback) async {
    //TODO test

    var dio = Dio();
    dio.interceptors.add(CookieManager(cookieJar));

    try {
      Response response = await dio.post(
        urlStrGetNextNewUser,
        data: {
          "email": RuntimeStore().getEmail(),
          "password": RuntimeStore().getPassword()
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode == 401)
        throw new UnauthorizedException();
      else if (response.statusCode == 200) {
        LikeFromUser likeFromUser=LikeFromUser.fromMap(response.data as Map);
        callback(likeFromUser);
        return likeFromUser;
      } else
        throw new NetworkException();
    } on DioError catch (e) {
      if (e.response?.statusCode == 401)
        throw new UnauthorizedException();
      else
        throw new NetworkException();
    }
  }

  Future<List<User>> getAllUsers() async {
    //TODO
    return <User>[];
  }
}
