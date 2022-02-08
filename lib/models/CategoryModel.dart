// ignore_for_file: file_names, avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';

class CategoryModel extends ChangeNotifier {
  CategoryModel({this.id, this.name, this.count, this.imagePath, this.discount, this.newInCome, this.recomended, this.sub});

  factory CategoryModel.fromJson(Map<dynamic, dynamic> json) {
    return CategoryModel(
        id: json["id"],
        name: json["name"],
        count: json["count"],
        imagePath: json["destination"],
        discount: json["discount"],
        newInCome: json["new_in_come"],
        recomended: json["recomended"],
        sub: ((json['sub'] ?? []) as List).map((json) => Sub.fromJson(json)).toList());
  }
  final int? id;
  final String? name;
  final int? count;
  final int? recomended;
  final int? newInCome;
  final int? discount;
  final String? imagePath;
  final List<Sub>? sub;

  Future<List<CategoryModel>> getCategory() async {
    final List<CategoryModel> category = [];
    languageCode();
    final response = await http.get(
        Uri.parse(
          "$serverURL/api/$lang/get-categories",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"] as List;
      for (final Map product in responseJson) {
        category.add(CategoryModel.fromJson(product));
      }
      return category;
    } else {
      return [];
    }
  }

  Future<List<CategoryModel>> getBrand() async {
    final List<CategoryModel> category = [];
    languageCode();
    final response = await http.get(
        Uri.parse(
          "$serverURL/api/$lang/get-producers",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"] as List;
      for (final Map product in responseJson) {
        category.add(CategoryModel.fromJson(product));
      }
      return category;
    } else {
      return [];
    }
  }
}

class Sub {
  String? name;
  int? id;

  Sub({this.name, this.id});

  Sub.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}
