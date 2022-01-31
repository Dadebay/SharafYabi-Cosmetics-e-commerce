// ignore_for_file: file_names, avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';

class FavoriteModel extends ChangeNotifier {
  FavoriteModel({
    this.id,
    this.productName,
    this.minValue,
    this.discountValue,
    this.price,
    this.imagePath,
    this.description,
  });

  factory FavoriteModel.fromJson(Map<dynamic, dynamic> json) {
    return FavoriteModel(
      id: json["id"],
      productName: json["name"],
      minValue: json["min_value"],
      discountValue: json["discount_value"],
      price: json["price"],
      imagePath: json["destination"],
      description: json["description"],
    );
  }

  final int? id;
  final int? minValue;
  final int? discountValue;
  final String? productName;
  final String? description;
  final String? price;
  final String? imagePath;

  Future<List<FavoriteModel>> getFavorites({Map<String, String>? parametrs}) async {
    final List<FavoriteModel> products = [];
    languageCode();
    final response = await http.get(
        Uri.parse(
          "$serverURL/api/$lang/get-wish-list",
        ).replace(queryParameters: parametrs),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"];
      if (responseJson != null) {
        for (final Map product in responseJson) {
          products.add(FavoriteModel.fromJson(product));
        }
        return products;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }
}
