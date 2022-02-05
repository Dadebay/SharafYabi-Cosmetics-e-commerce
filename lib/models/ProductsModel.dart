// ignore_for_file: file_names, avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';

class ProductsModel extends ChangeNotifier {
  ProductsModel({
    this.id,
    this.productName,
    this.minValue,
    this.discountValue,
    this.price,
    this.imagePath,
  });

  factory ProductsModel.fromJson(Map<dynamic, dynamic> json) {
    return ProductsModel(
      id: json["id"],
      productName: json["name"],
      minValue: json["min_value"],
      discountValue: json["discount_value"],
      price: json["price"],
      imagePath: json["destination"],
    );
  }

  final int? id;
  final int? minValue;
  final int? discountValue;
  final String? productName;
  final String? price;
  final String? imagePath;

  Future<List<ProductsModel>> getProducts({Map<String, dynamic>? parametrs}) async {
    final List<ProductsModel> products = [];
    languageCode();
    final response = await http.get(
        Uri.parse(
          "$serverURL/api/$lang/get-products",
        ).replace(queryParameters: parametrs),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });
    // print(parametrs);
    // print(response.body);
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"]["products"];
      final responseCount = jsonDecode(response.body)["rows"]["count"];
      if (jsonDecode(response.body)["rows"]["products"] != null) {
        pageNumber = int.parse(responseCount);
        for (final Map product in responseJson) {
          products.add(ProductsModel.fromJson(product));
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
