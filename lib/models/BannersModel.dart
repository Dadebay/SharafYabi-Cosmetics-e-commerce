// ignore_for_file: file_names, avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';

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
    String lang = Get.locale!.languageCode;
    if (lang == "tr") lang = "tm";
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

class AboutUSModel extends ChangeNotifier {
  final int? id;
  final String? phoneNumber1;
  final String? phoneNumber2;
  final String? address;
  final String? email;
  AboutUSModel({this.id, this.phoneNumber1, this.phoneNumber2, this.address, this.email});

  factory AboutUSModel.fromJson(Map<dynamic, dynamic> json) {
    return AboutUSModel(id: json["id"], phoneNumber1: json["phone1"], phoneNumber2: json["phone2"], address: json["address"], email: json["email"]);
  }
  Future<AboutUSModel> getAboutUS() async {
    String lang = Get.locale!.languageCode;
    if (lang == "tr") lang = "tm";
    final response = await http.get(
        Uri.parse(
          "$serverURL/api/$lang/get-shop-data",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      return AboutUSModel.fromJson(jsonDecode(response.body)["rows"]);
    } else {
      return AboutUSModel();
    }
  }
}

class SendAdminMessage extends ChangeNotifier {
  SendAdminMessage({
    this.count,
    this.comments,
  });

  factory SendAdminMessage.fromJson(Map<dynamic, dynamic> json) {
    return SendAdminMessage(
      count: json["count"],
      comments: ((json['comments'] ?? []) as List).map((json) => SendAdminMessage.fromJson(json)).toList(),
    );
  }
  final int? count;
  final List<SendAdminMessage>? comments;

  Future sendAdminMessage({String? name, String? mail, String? phone, String? message}) async {
    String lang = Get.locale!.languageCode;
    if (lang == "tr") lang = "tm";
    final response = await http.post(
        Uri.parse(
          "$serverURL/api/$lang/send-admin-message",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "name": name!,
          "email": mail!,
          "phone": phone!,
          "message": message!,
        }));
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
