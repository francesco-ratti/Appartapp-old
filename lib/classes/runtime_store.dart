
import 'package:shared_preferences/shared_preferences.dart';

import 'credentials.dart';

class RuntimeStore {
  //SINGLETON PATTERN

  static final RuntimeStore _runtimeStore = RuntimeStore._internal();

  factory RuntimeStore() {
    return _runtimeStore;
  }

  RuntimeStore._internal();


  //useful as singleton since this will be our temporary application state store
  Credentials? _credentials=null;
  SharedPreferences? _sharedPreferences=null;

  SharedPreferences? getSharedPreferences() {
    return _sharedPreferences;
  }

  void setSharedPreferences(SharedPreferences sharedPreferences) {
    _sharedPreferences=sharedPreferences;
  }

  void setCredentialsByString(String email, String password) {
    _credentials=new Credentials(email: email, password: password);
  }

  void setCredentials(Credentials credentials) {
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