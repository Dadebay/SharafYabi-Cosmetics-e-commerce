// ignore_for_file: file_names, avoid_dynamic_calls, duplicate_ignore

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';

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

  Future<List<NewsModel>> getNews() async {
    final List<NewsModel> products = [];
    String lang = Get.locale!.languageCode;
    if (lang == "tr") lang = "tm";
    final response = await http.get(
        Uri.parse(
          "$serverURL/api/$lang/get-news",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
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
    String lang = Get.locale!.languageCode;
    if (lang == "tr") lang = "tm";
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

class VideoModel extends ChangeNotifier {
  VideoModel({this.imagePath, this.title, this.videoPath});

  factory VideoModel.fromJson(Map<dynamic, dynamic> json) {
    return VideoModel(imagePath: json["poster"], videoPath: json["video"], title: json["title"]);
  }

  final String? imagePath;
  final String? videoPath;
  final String? title;
  Future<List<VideoModel>> getVideos() async {
    final List<VideoModel> products = [];
    String lang = Get.locale!.languageCode;
    if (lang == "tr") lang = "tm";
    final response = await http.get(
        Uri.parse(
          "$serverURL/api/$lang/get-videos",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"] as List;
      for (final Map product in responseJson) {
        products.add(VideoModel.fromJson(product));
      }
      return products;
    } else {
      return [];
    }
  }
}
