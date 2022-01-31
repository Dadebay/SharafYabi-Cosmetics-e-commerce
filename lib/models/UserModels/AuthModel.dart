// ignore_for_file: file_names, require_trailing_commas, avoid_void_async, avoid_bool_literals_in_conditional_expressions

import 'package:get_storage/get_storage.dart';

class Auth {
  final storage = GetStorage();

  void login(String? data) async {
    storage.write("data", data);
  }

  Future<bool> logout() async {
    storage.remove("data");
    return storage.read("data") == null ? true : false;
  }

  /////////////////////////////////////////User Token///////////////////////////////////
  Future<bool> setToken(String token) async {
    storage.write("AccessToken", token);
    return storage.read("AccessToken") == null ? false : true;
  }

  Future<String?> getToken() async {
    return storage.read("AccessToken");
  }

  Future<bool> removeToken() async {
    storage.remove("AccessToken");
    return storage.read("AccessToken") == null ? true : false;
  }

/////////////////////////////////////////User Refresh Token///////////////////////////////////

  Future<bool> setRefreshToken(String token) async {
    storage.write("RefreshToken", token);
    return storage.read("AccessToken") == null ? false : true;
  }

  Future<String?> getRefreshToken() async {
    return storage.read("RefreshToken");
  }

  Future<bool> removeRefreshToken() async {
    storage.remove("RefreshToken");
    return storage.read("RefreshToken") == null ? true : false;
  }
}
