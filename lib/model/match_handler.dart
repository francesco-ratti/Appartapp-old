import 'package:appartapp/entities/lessor_match.dart';
import 'package:appartapp/exceptions/connection_exception.dart';
import 'package:appartapp/utils_classes/runtime_store.dart';
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
      "http://localhost:8080/appart-1.0-SNAPSHOT/api/reserved/getmatchedapartments";
  static const urlStrFromDate =
      "http://localhost:8080/appart-1.0-SNAPSHOT/api/reserved/getmatchedapartmentsfromdate";
  List<LessorMatch>? _currentMatches;
  List<LessorMatch>? _unseenMatches;

  //List? oldResData = null;

  DateTime? _lastShowedMatchDateTime;
  DateTime _lastReceivedMatchDateTime =
      DateTime.now().subtract(const Duration(days: 30));

  //DateTime? lastReceivedMatchDateTime = null;

  bool _firstUpdateRun = true;

  bool _stop = true;

  List<Function(List<LessorMatch>?)>
      updateCallbacks = ////cbk function to which only new matches will be passed
      <Function(List<LessorMatch>?)>[];

  List<Function(List<LessorMatch>?)>
      updateAllMatchesCallbacks = //cbk function to which all matches will be passed
      <Function(List<LessorMatch>?)>[];

  Function deepEq = const DeepCollectionEquality().equals;

  Future<void> initCurrentMatches(
      Function(List<LessorMatch>?)? callback) async {
    var dio = RuntimeStore().dio;
    Response response = await dio.post(
      urlStr,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
      ),
    );

    if (response.statusCode == 200) {
      _currentMatches ??= [];
      if (response.data != null) {
        List newResData = response.data as List;
        if (newResData.isNotEmpty) {
          for (final el in newResData) {
            _currentMatches?.add(LessorMatch.fromMap(el));
          }
          _lastReceivedMatchDateTime = _currentMatches![0].time;
        }
      }
      if (callback != null) {
        callback(_currentMatches);
      }
      for (final Function(List<LessorMatch>?) cbk
          in updateAllMatchesCallbacks) {
        cbk(_currentMatches);
      }
    } else {
      throw ConnectionException();
    }
  }

  void initLastViewedMatchDate() {
    if (_stop) {
      int? lastViewedMatchNew =
          RuntimeStore().getSharedPreferences()?.getInt("lastviewedmatch");
      _lastShowedMatchDateTime = lastViewedMatchNew == null ? DateTime.fromMillisecondsSinceEpoch(0) : DateTime.fromMillisecondsSinceEpoch(lastViewedMatchNew);
        } else {
      throw Exception(
          "Last match Datetime can be set only when matchhandler isn't running");
    }
  }

  void removeLastViewedMatchDate() {
    RuntimeStore().getSharedPreferences()?.remove("lastviewedmatch");
    _lastShowedMatchDateTime = null;
  }

  bool isLastShowedMatchDateTimeAvailable() {
    return _lastShowedMatchDateTime != null;
  }

  void setChangesAsSeen() {
    if (_currentMatches != null) {
      _unseenMatches = [];
      _lastShowedMatchDateTime = _lastReceivedMatchDateTime;
      if (_lastShowedMatchDateTime != null) {
        RuntimeStore().getSharedPreferences()?.setInt("lastviewedmatch",
            _lastShowedMatchDateTime!.millisecondsSinceEpoch);
      }
    }
  }

  bool hasUnseenChanges() {
    return _unseenMatches != null && _unseenMatches!.isNotEmpty;
  }

  Future<void> doUpdateFromDate(Function(List<LessorMatch>?)? callback) async {
    var dio = RuntimeStore().dio;
    try {
      Response response = await dio.post(
        urlStrFromDate,
        data: {
          "date": _firstUpdateRun && _lastShowedMatchDateTime != null
              ? _lastShowedMatchDateTime!.millisecondsSinceEpoch
              : _lastReceivedMatchDateTime.millisecondsSinceEpoch
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode == 200) {
        _unseenMatches ??= [];

        if (response.data != null) {
          List newResData = response.data as List;

          /*if (oldResData == null || !deepEq(oldResData, newResData)) {
            //_currentMatches = [];
            */
          if (newResData.isNotEmpty) {
            for (final el in newResData) {
              LessorMatch curr = LessorMatch.fromMap(el);
              _unseenMatches?.insert(0, curr);
              if (!_firstUpdateRun) {
                _currentMatches?.insert(0, curr);
              }
            }
            _lastReceivedMatchDateTime = _currentMatches![0].time;
            //lastReceivedMatchDateTime = LessorMatch.fromMap(newResData[0]).time;

            for (final Function(List<LessorMatch>?) cbk in updateCallbacks) {
              cbk(_unseenMatches);
            }
            if (_currentMatches != null) {
              for (final Function(List<LessorMatch>?) cbk
                  in updateAllMatchesCallbacks) {
                cbk(_currentMatches);
              }
            }
            if (callback != null && _currentMatches != null) {
              callback(_currentMatches);
            }
          }
        }
        if (_firstUpdateRun) {
          _firstUpdateRun = false;
        }
      }
    } on DioException {}
  }

  void addUpdateCallback(Function(List<LessorMatch>?) callback) {
    updateCallbacks.add(callback);
    if (_unseenMatches != null) {
      callback(_unseenMatches);
    }
  }

  void removeUpdateCallback(Function(List<LessorMatch>?) callback) {
    updateCallbacks.remove(callback);
  }

  void addUpdateAllMatchesCallback(Function(List<LessorMatch>?) callback) {
    updateAllMatchesCallbacks.add(callback);
    if (_currentMatches != null) {
      callback(_currentMatches);
    }
  }

  void removeUpdateAllMatchesCallback(Function(List<LessorMatch>?) callback) {
    updateAllMatchesCallbacks.remove(callback);
  }

  void startPeriodicUpdate() async {
    _stop = false;

    _currentMatches = null;
    _unseenMatches = null;
    _firstUpdateRun = true;
    _lastReceivedMatchDateTime =
        DateTime.now().subtract(const Duration(days: 30));

    try {
      await initCurrentMatches(null);
      while (!_stop) {
        await doUpdateFromDate(null);
        await Future.delayed(const Duration(seconds: 30));
      }
    } catch (e) {
      if (e is DioException || e is ConnectionException) {
        stopPeriodicUpdate();
        startPeriodicUpdate();
      } else {
        rethrow;
      }
    }
  }

  void stopPeriodicUpdate() {
    _stop = true;

    _currentMatches = null;
    _unseenMatches = null;
    _firstUpdateRun = true;
    _lastReceivedMatchDateTime =
        DateTime.now().subtract(const Duration(days: 30));
  }

  List<LessorMatch>? getMatches() {
    return _currentMatches;
  }

  List<LessorMatch>? getUnseenMatches() {
    return _unseenMatches;
  }
}