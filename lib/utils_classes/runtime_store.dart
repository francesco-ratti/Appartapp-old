import 'dart:io';
import 'dart:ui';

import 'package:appartapp/entities/apartment.dart';
import 'package:appartapp/entities/user.dart';
import 'package:appartapp/model/match_handler.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RuntimeStore {
  //SINGLETON PATTERN

  static const backgroundColor = Color(0xff404040);

  //static const backgroundColor = Color(0xff282828);
  //static const backgroundColor = Color.fromRGBO(105, 105, 105, 100);

  static final RuntimeStore _runtimeStore = RuntimeStore._internal();

  factory RuntimeStore() {
    return _runtimeStore;
  }

  RuntimeStore._internal();

  Future<List<Apartment>>? _ownedApartments;

  late MatchHandler matchHandler;

  late Function() tenantInfoUpdated;

  late bool credentialsLogin;

  late bool useMobileLayout;

  List<Function(bool)> apartmentAddedCbk = [];

  void addApartmentAddedCbk(Function(bool) cbk) {
    apartmentAddedCbk.add(cbk);
  }

  void removeApartmentAddedCbk(Function(bool) cbk) {
    apartmentAddedCbk.remove(cbk);
  }

  bool getCredentialsLogin() {
    return credentialsLogin;
  }

  void setCredentialsLogin(bool credentialsLogin) {
    this.credentialsLogin = credentialsLogin;
  }

  Future<List<Apartment>>? getOwnedApartments() {
    return _ownedApartments;
  }

  void setOwnedApartmentsFuture(Future<List<Apartment>> ownedApartments) {
    _ownedApartments = ownedApartments;
  }

  //useful as singleton since this will be our temporary application state store

  User? _user;

  late CookieJar cookieJar;

  Dio dio = Dio(BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20))
  );

  SharedPreferences? _sharedPreferences;

  User? getUser() {
    return _user;
  }

  void setUser(User user) {
    _user = user;
  }

  SharedPreferences? getSharedPreferences() {
    return _sharedPreferences;
  }

  void setSharedPreferences(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }

  Future<void> initDio() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    cookieJar = PersistCookieJar(
        persistSession: true,
        storage: FileStorage(appDocDir.path + '/.cookies/'));
    dio.interceptors.add(CookieManager(RuntimeStore().cookieJar));

    /*
    List<FileSystemEntity> file = io.Directory(appDocDir.path + '/.cookies/').listSync();
    for (FileSystemEntity obj in file) {
      print(obj.toString());
    }
    print("end");*/
  }
}
