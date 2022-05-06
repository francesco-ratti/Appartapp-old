
import 'dart:ui';

import 'package:appartapp/classes/User.dart';
import 'package:appartapp/classes/apartment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'credentials.dart';

class RuntimeStore {
  //SINGLETON PATTERN
  static const backgroundColor=Color( 0xff282828);

  static final RuntimeStore _runtimeStore = RuntimeStore._internal();

  factory RuntimeStore() {
    return _runtimeStore;
  }

  RuntimeStore._internal();

  Future<List<Apartment>>? _ownedApartments;

  Future<List<Apartment>>? getOwnedApartments() {
    return _ownedApartments;
  }

  void setOwnedApartmentsFuture(Future<List<Apartment>> ownedApartments) {
    _ownedApartments=ownedApartments;
  }

  //useful as singleton since this will be our temporary application state store
  Credentials? _credentials=null;

  User? _user=null;

  SharedPreferences? _sharedPreferences=null;

  User? getUser() {
    return _user;
  }

  void setUser(User user) {
    _user=user;
  }

  SharedPreferences? getSharedPreferences() {
    return _sharedPreferences;
  }

  void setSharedPreferences(SharedPreferences sharedPreferences) {
    _sharedPreferences=sharedPreferences;
  }

  void setCredentialsByString(String email, String password) {
    _credentials=new Credentials(email: email, password: password);
  }

  void setCredentials(Credentials? credentials) {
    _credentials=credentials;
  }

  Credentials? getCredentials() {
    return _credentials;
  }

  String? getEmail() {
    return _credentials?.email;
  }

  String? getPassword() {
    return _credentials?.password;
  }
}