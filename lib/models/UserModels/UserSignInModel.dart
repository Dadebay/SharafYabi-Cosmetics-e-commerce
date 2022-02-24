// ignore_for_file: file_names, always_use_package_imports, avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';

import 'AuthModel.dart';

class UserSignInModel {
  UserSignInModel({this.name, this.phoneNumber, this.ownerId});

  factory UserSignInModel.fromJson(Map<String, dynamic> json) {
    return UserSignInModel(name: json["fullname"] as String, phoneNumber: json["phone"] as String, ownerId: json['owner_id'] as int);
  }

  final String? name;
  final int? ownerId;
  final String? phoneNumber;

  Future signUp({
    String? fullname,
    String? phoneNumber,
    String? password,
  }) async {
    final response = await http.post(Uri.parse("$authServerUrl/api/user/tm/registration"),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "full_name": fullname,
          "phone": phoneNumber,
          "password": password,
        }));
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      Auth().setToken(responseJson["token"]);
      Auth().setRefreshToken(responseJson["refresh_token"]);
      Auth().login(jsonEncode(responseJson["data"]));

      return true;
    } else {
      return response.statusCode;
    }
  }

  Future login({String? phone, String? password}) async {
    final response = await http.post(Uri.parse("$authServerUrl/api/user/tm/login"),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "phone": phone!,
          "password": password!,
        }));
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      Auth().setToken(jsonDecode(response.body)["token"]);
      Auth().setRefreshToken(jsonDecode(response.body)["refresh_token"]);
      Auth().login(jsonEncode(responseJson["data"]));

      return true;
    } else {
      return response.statusCode;
    }
  }

  Future forgotPassword({
    required String phoneNumber,
  }) async {
    final response = await http.post(Uri.parse("$authServerUrl/api/user/ru/forgot-password"),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "phone": phoneNumber,
        }));
    if (response.statusCode == 200) {
      Auth().setToken(jsonDecode(response.body)["token"]);

      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }

  Future changePassword({
    required String newPassword,
    required String code,
  }) async {
    final token = await Auth().getToken();
    final response = await http.post(Uri.parse("$authServerUrl/api/user/tm/change-password"),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "password": newPassword,
          "code": code,
        }));
    if (response.statusCode == 200) {
      Auth().removeToken();
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }
}
