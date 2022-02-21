// ignore_for_file: file_names, avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/models/UserModels/AuthModel.dart';

class AddressModel extends ChangeNotifier {
  AddressModel({
    this.id,
    this.address,
    this.comment,
  });

  factory AddressModel.fromJson(Map<dynamic, dynamic> json) {
    return AddressModel(
      id: json["id"],
      address: json["address"],
      comment: json["comment"],
    );
  }

  final String? id;
  final String? address;
  final String? comment;
  Future<List<AddressModel>> getAddress() async {
    final List<AddressModel> products = [];
    final token = await Auth().getToken();

    languageCode();
    final response = await http.get(
        Uri.parse(
          "$serverURL/api/user/$lang/get-my-locations",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"] as List;
      for (final Map product in responseJson) {
        products.add(AddressModel.fromJson(product));
      }
      return products;
    } else {
      return [];
    }
  }

  Future deleteLocation(int? id) async {
    final token = await Auth().getToken();
    languageCode();
    final response = await http.post(
      Uri.parse(
        "$serverURL/api/user/$lang/delete-location/$id",
      ),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }

  Future addLocation(String? address, String? comment) async {
    final token = await Auth().getToken();
    final body = json.encode({
      "address": address,
      "comment": comment,
    });
    languageCode();
    final response = await http.post(
        Uri.parse(
          "$serverURL/api/user/$lang/add-user-location",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
