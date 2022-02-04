// ignore_for_file: file_names, avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';

class BannerModel extends ChangeNotifier {
  BannerModel({this.id, this.imagePath, this.pathID, this.itemID});

  factory BannerModel.fromJson(Map<dynamic, dynamic> json) {
    return BannerModel(id: json["id"], imagePath: json["destination"], pathID: json["path_id"], itemID: json["item_id"]);
  }

  final int? id;
  final String? imagePath;
  final int? pathID;
  final int? itemID;
  Future<List<BannerModel>> getBanners() async {
    final List<BannerModel> products = [];
    languageCode();
    final response = await http.get(
        Uri.parse(
          "$serverURL/api/$lang/get-banners/1",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"] as List;
      for (final Map product in responseJson) {
        products.add(BannerModel.fromJson(product));
      }
      return products;
    } else {
      return [];
    }
  }
}
