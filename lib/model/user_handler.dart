import 'package:appartapp/entities/like_from_user.dart';
import 'package:appartapp/entities/user.dart';
import 'package:appartapp/exceptions/connection_exception.dart';
import 'package:appartapp/utils_classes/runtime_store.dart';
import 'package:dio/dio.dart';

class UserHandler {
  //SINGLETON PATTERN
  //useful as singleton since network functions will store session cookie here, in cookie jar

  final String urlStrGetNextNewUser =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/getnextnewuser";
  final String urlStrGetAllNewUsers =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/getallnewusers";

  static final UserHandler _user = UserHandler._internal();

  factory UserHandler() {
    return _user;
  }

  UserHandler._internal();

  Future<LikeFromUser?> getNewLikeFromUser(Function(LikeFromUser) callback) async {
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

  /*
      if (response.statusCode == 401)
        throw new UnauthorizedException();
      else if (response.statusCode == 200) {
        if (response.data == null) return null;
        LikeFromUser likeFromUser = LikeFromUser.fromMap(response.data as Map);
        callback(likeFromUser);
        return likeFromUser;
      } else
        throw ConnectionException();
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.other ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.cancel) {
        throw ConnectionException();
      }
      if (e.response?.statusCode == 401)
        throw new UnauthorizedException();
      else
        throw new NetworkException();
    }
  }*/

  Future<List<User>> getAllUsers() async {
    //TODO
    return <User>[];
  }
}
