// ignore_for_file: file_names, always_use_package_imports, avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';

import 'UserModels/AuthModel.dart';

class OrdersModel extends ChangeNotifier {
  OrdersModel({
    this.id,
    this.totalPrice,
    this.createdAT,
  });

  factory OrdersModel.fromJson(Map<dynamic, dynamic> json) {
    return OrdersModel(
      id: json["id"],
      totalPrice: json["total_price"],
      createdAT: json["created_at"],
    );
  }
  final int? id;
  final String? totalPrice;
  final String? createdAT;

  Future<List<OrdersModel>> getOrders({Map<String, dynamic>? parametrs}) async {
    final List<OrdersModel> products = [];
    final token = await Auth().getToken();
    String lang = Get.locale!.languageCode;
    if (lang == "tr") lang = "tm";
    final response = await http.get(
        Uri.parse(
          "$serverURL/api/user/$lang/get-orders",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"];
      for (final Map product in responseJson) {
        products.add(OrdersModel.fromJson(product));
      }
      return products;
    } else {
      return [];
    }
  }

  Future<List<OrdersModel>> getOrdersNotLogin({required Map<String, String> parametrs}) async {
    final List<OrdersModel> products = [];
    String lang = Get.locale!.languageCode;
    if (lang == "tr") lang = "tm";
    final response = await http.get(
        Uri.parse(
          "$serverURL/api/$lang/get-orders-mobile",
        ).replace(queryParameters: parametrs),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"];
      for (final Map product in responseJson) {
        products.add(OrdersModel.fromJson(product));
      }
      return products;
    } else {
      return [];
    }
  }
}

class OrdersModelById extends ChangeNotifier {
  OrdersModelById({this.id, this.price, this.quantity, this.discountValue, this.productName, this.imagePath, this.categoryName, this.producerName});

  factory OrdersModelById.fromJson(Map<dynamic, dynamic> json) {
    return OrdersModelById(
        id: json["id"],
        price: json["price"],
        quantity: json["quantity"],
        discountValue: json["discount_value"],
        productName: json["name"],
        imagePath: json["destination"],
        categoryName: json["category_name"],
        producerName: json["producer_name"]);
  }
  final int? id;
  final String? price;
  final int? quantity;
  final int? discountValue;
  final String? productName;
  final String? imagePath;
  final String? categoryName;
  final String? producerName;

  Future<List<OrdersModelById>> getOrderById({int? id}) async {
    final List<OrdersModelById> products = [];
    final token = await Auth().getToken();
    String lang = Get.locale!.languageCode;
    if (lang == "tr") lang = "tm";
    final response = await http.get(
        Uri.parse(
          "$serverURL/api/user/$lang/get-order/$id",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"];
      for (final Map product in responseJson) {
        products.add(OrdersModelById.fromJson(product));
      }
      return products;
    } else {
      return [];
    }
  }

  Future<List<OrdersModelById>> getOrderByIdNotLogin({int? id}) async {
    final List<OrdersModelById> products = [];
    String lang = Get.locale!.languageCode;
    if (lang == "tr") lang = "tm";
    final response = await http.get(
        Uri.parse(
          "$serverURL/api/$lang/get-order/$id",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"];
      for (final Map product in responseJson) {
        products.add(OrdersModelById.fromJson(product));
      }
      return products;
    } else {
      return [];
    }
  }
}
