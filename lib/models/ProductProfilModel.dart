// ignoreforfile: filenames, prefertypinguninitializedvariables, typeannotatepublicapis

// ignore_for_file: file_names, avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';

class ProductProfilModel extends ChangeNotifier {
  ProductProfilModel({
    this.id,
    this.name,
    this.price,
    this.stock,
    this.image,
    this.categoryId,
    this.producerId,
    this.description,
    this.producerName,
    this.categoryName,
    this.discountValue,
    this.minValue,
  });

  factory ProductProfilModel.fromJson(Map<dynamic, dynamic> json) {
    return ProductProfilModel(
      id: json['id'],
      price: json['price'],
      stock: json['stock'],
      image: json['destination'],
      categoryId: json['category_id'],
      producerId: json['producer_id'],
      name: json['name'],
      description: json['description'],
      producerName: json['producer_name'],
      categoryName: json['category_name'],
      discountValue: json['discount_value'],
      minValue: json['min_value'],
    );
  }

  final int? id;
  final String? price;
  final String? stock;
  final String? image;
  final int? categoryId;
  final int? producerId;
  final String? name;
  final String? description;
  final String? producerName;
  final String? categoryName;
  final int? discountValue;
  final int? minValue;

  Future<ProductProfilModel> getRealEstatesById(int? id) async {
    languageCode();
    final response = await http.get(
        Uri.parse(
          "$serverURL/api/$lang/get-product/$id",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      return ProductProfilModel.fromJson(jsonDecode(response.body)["rows"]);
    } else {
      return ProductProfilModel();
    }
  }
}
