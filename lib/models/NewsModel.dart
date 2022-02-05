// ignore_for_file: file_names, avoid_dynamic_calls, duplicate_ignore

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/NewsController.dart';

class NewsModel extends ChangeNotifier {
  NewsModel({this.id, this.imagePath, this.createdAt, this.article, this.title});

  factory NewsModel.fromJson(Map<dynamic, dynamic> json) {
    return NewsModel(
      id: json["id"],
      imagePath: json["destination"],
      createdAt: json["created_at"],
      title: json["title"],
      article: json["article"],
    );
  }

  final int? id;
  final String? imagePath;
  final String? createdAt;
  final String? title;
  final String? article;

  Future<List<NewsModel>> getNews({required Map<String, String> parametrs}) async {
    final List<NewsModel> products = [];
    languageCode();
    final response = await http.get(
        Uri.parse(
          "$serverURL/api/$lang/get-news",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });
    print(response.body);

    if (response.statusCode == 200) {
      Get.find<NewsController>().pageNumberNews.value = 0;
      final responseJson = jsonDecode(response.body)["rows"]["news"] as List;
      for (final Map product in responseJson) {
        products.add(NewsModel.fromJson(product));
      }

      return products;
    } else {
      return [];
    }
  }

  Future<NewsModel?> getNewsProfil({int? id}) async {
    languageCode();
    final response = await http.get(
        Uri.parse(
          "$serverURL/api/$lang/get-news-by-id/$id",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      return NewsModel.fromJson(jsonDecode(response.body)["rows"]);
    } else {
      return null;
    }
  }
}
