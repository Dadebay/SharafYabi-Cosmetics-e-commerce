// ignore_for_file: file_names, avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';

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
