import 'package:appartapp/classes/runtime_store.dart';
import 'package:dio/dio.dart';
import 'package:appartapp/classes/lessor_match.dart';

class MatchHandler {
  //SINGLETON PATTERN
  /*
  static final MatchHandler _matchHandler = MatchHandler._internal();
   */
  static final urlStr="http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/getmatchedapartments";
  List<LessorMatch>? _currentMatches=null;
  List? oldResData=null;

  bool _stop=false;

  List<Function(List<LessorMatch>?)> updateCallbacks=<Function(List<LessorMatch>?)>[];

  Future<void> doUpdate(Function(List<LessorMatch>?) callback) async { //TODO make it return user instead of credentials
    var dio = Dio();
    try {
      Response response = await dio.post(
        urlStr,
        data: {"email": RuntimeStore().getEmail(), "password": RuntimeStore().getPassword()},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode != 200) {
        /*if (response.statusCode == 401)
          return [null,null,LoginResult.wrong_credentials];
        else
          return [null,null,LoginResult.server_error];*/
      }
      else {
        List newResData=response.data as List;
        if (oldResData==null || oldResData!=newResData) {
          _currentMatches = [];
          if (newResData!=null) {
            for (final el in newResData) {
              _currentMatches?.add(LessorMatch.fromMap(el));
            }
            oldResData = newResData;

            callback(_currentMatches);
            for (final Function(List<LessorMatch>?) cbk in updateCallbacks) {
              cbk(_currentMatches);
            }
          }
        }
      }
    } on DioError catch (e) {
      /*if (e.response?.statusCode == 401)
        return [null, null, LoginResult.wrong_credentials];
      else
        return [null, null, LoginResult.server_error];*/
    }
  }

  void addUpdateCallback(Function(List<LessorMatch>?) callback) {
    updateCallbacks.add(callback);
  }

  void removeUpdateCallback(Function(List<LessorMatch>?) callback) {
    updateCallbacks.remove(callback);
  }

  void startPeriodicUpdate () async {
    _stop=false;
    while (!_stop) {
      await doUpdate((res) {});
      await Future.delayed(Duration(seconds: 30));
    }
  }

  void stopPeriodicUpdate () {
    _stop=true;
  }
/*
  factory MatchHandler() {
    return _matchHandler;
  }

      MatchHandler._internal();
 */


  getMatches() {
    return _currentMatches;
  }
}