import 'package:appartapp/classes/user.dart';
import '../exceptions/unauthorized_exception.dart';
import 'package:dio/dio.dart';
import '../exceptions/network_exception.dart';
import 'like_from_user.dart';
import 'runtime_store.dart';

import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class UserHandler {
  //SINGLETON PATTERN
  //useful as singleton since network functions will store session cookie here, in cookie jar

  final String urlStrGetNextNewUser =
      "http://192.168.20.108:8080/appartapp_war_exploded/api/reserved/getnextnewuser";
  final String urlStrGetAllNewUsers =
      "http://192.168.20.108:8080/appartapp_war_exploded/api/reserved/getallnewusers";

  static final UserHandler _user = UserHandler._internal();

  factory UserHandler() {
    return _user;
  }

  UserHandler._internal();

  Future<LikeFromUser?> getNewLikeFromUser(Function(LikeFromUser) callback) async {
    //TODO test

    var dio = RuntimeStore().dio;

    try {
      Response response = await dio.post(
        urlStrGetNextNewUser,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode == 401)
        throw new UnauthorizedException();
      else if (response.statusCode == 200) {
        if (response.data == null)
          return null;
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
