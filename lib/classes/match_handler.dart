import 'package:appartapp/classes/lessor_match.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';

class MatchHandler {
  //SINGLETON PATTERN

  static final MatchHandler _matchHandler = MatchHandler._internal();

  factory MatchHandler() {
    return _matchHandler;
  }

  MatchHandler._internal();

  static const urlStr =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/getmatchedapartments";
  static const urlStrFromDate =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/getmatchedapartmentsfromdate";
  List<LessorMatch>? _currentMatches = [];
  List? oldResData = null;

  DateTime lastMatchDateTime = new DateTime(1980);

  bool _stop = true;

  bool _unseenChanges =
      false; //set true when there are changes and reset false when user click on explore tenants

  List<Function(List<LessorMatch>?)> updateCallbacks =
      <Function(List<LessorMatch>?)>[];

  Function deepEq = const DeepCollectionEquality().equals;
  bool firstRun = true;

  /*
  Future<void> doUpdate(Function(List<LessorMatch>?) callback) async {
    var dio = RuntimeStore().dio;
    try {
      Response response = await dio.post(
        urlStr,
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
      } else {
        List newResData = response.data as List;

        if (oldResData == null || !deepEq(oldResData, newResData)) {
          _currentMatches = [];
          if (newResData != null) {
            for (final el in newResData) {
              _currentMatches?.add(LessorMatch.fromMap(el));
            }
            oldResData = newResData;

            callback(_currentMatches);
            for (final Function(List<LessorMatch>?) cbk in updateCallbacks) {
              cbk(_currentMatches);
            }
            if (newResData.isNotEmpty) unseenChanges = true;
          }
        }
      }
    } on DioError catch (e) {
      /*if (e.response?.statusCode == 401)
        return [null, null, LoginResult.wrong_credentials];
      else
        return [null, null, LoginResult.server_error];*/
    }
  }*/
  void initLastViewedMatchDate() {
    if (_stop) {
      int? lastViewedMatchNew =
          RuntimeStore().getSharedPreferences()?.getInt("lastviewedmatch");
      if (lastViewedMatchNew != null) {
        lastMatchDateTime =
            DateTime.fromMillisecondsSinceEpoch(lastViewedMatchNew);
      } else {
        lastMatchDateTime = DateTime(1980);
      }
    } else {
      throw Exception(
          "Last match Datetime can be set only when matchhandler isn't running");
    }
  }

  void removeLastViewedMatchDate() {
    RuntimeStore().getSharedPreferences()?.remove("lastviewedmatch");
    lastMatchDateTime = DateTime(1980);
  }

  void setChangesAsSeen() {
    _unseenChanges = false;
    RuntimeStore()
        .getSharedPreferences()
        ?.setInt("lastviewedmatch", lastMatchDateTime.millisecondsSinceEpoch);
  }

  bool hasUnseenChanges() {
    return _unseenChanges;
  }

  Future<void> doUpdateFromDate(Function(List<LessorMatch>?) callback) async {
    var dio = RuntimeStore().dio;
    try {
      Response response = await dio.post(
        urlStrFromDate,
        data: {"date": lastMatchDateTime.millisecondsSinceEpoch},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode == 200) {
        if (response.data != null) {
          List newResData = response.data as List;

          /*if (oldResData == null || !deepEq(oldResData, newResData)) {
            //_currentMatches = [];
            */
          if (newResData.isNotEmpty) {
            for (final el in newResData) {
              _currentMatches?.add(LessorMatch.fromMap(el));
            }
            lastMatchDateTime = LessorMatch.fromMap(newResData[0]).time;
            //oldResData = newResData;

            callback(_currentMatches);
            for (final Function(List<LessorMatch>?) cbk in updateCallbacks) {
              cbk(_currentMatches);
            }
            _unseenChanges = true;
          } else if (firstRun) {
            callback(_currentMatches);
            for (final Function(List<LessorMatch>?) cbk in updateCallbacks) {
              cbk(_currentMatches);
            }
          }
        } else if (firstRun) {
          callback(_currentMatches);
          for (final Function(List<LessorMatch>?) cbk in updateCallbacks) {
            cbk(_currentMatches);
          }
        }
        //  }
        if (!firstRun) {
          firstRun = false;
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
    callback(_currentMatches);
  }

  void removeUpdateCallback(Function(List<LessorMatch>?) callback) {
    updateCallbacks.remove(callback);
  }

  void startPeriodicUpdate() async {
    _stop = false;

    firstRun = true;
    _unseenChanges = false;
    _currentMatches = [];
    oldResData = null;

    while (!_stop) {
      //await doUpdate((res) {});
      await doUpdateFromDate((res) {});
      await Future.delayed(Duration(seconds: 30));
    }
  }

  void stopPeriodicUpdate() {
    _stop = true;

    firstRun = true;
    _unseenChanges = false;
    _currentMatches = [];
    oldResData = null;
  }

  getMatches() {
    return _currentMatches;
  }
}