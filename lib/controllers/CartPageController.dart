// ignore_for_file: file_names, type_annotate_public_apis, always_declare_return_types, avoid_dynamic_calls, always_use_package_imports

import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sharaf_yabi_ecommerce/models/CartModel.dart';

import '../components/constants/constants.dart';
import 'Fav_Cart_Controller.dart';

class CartPageController extends GetxController {
  RxList list = [].obs;
  RxInt loading = 0.obs;
  RxInt nagt = 1.obs;
  RxBool sendButtonValue = false.obs;
  void addToCard(int id) {
    for (final element in list) {
      if (element["id"] == id) {
        element["count"] += 1;
      }
    }
    list.refresh();
  }

  void removeCard(int id) {
    for (final element in list) {
      if (element["id"] == id) {
        element["count"] -= 1;
      }
    }
    list.removeWhere((element) => element["count"] == 0);
    list.refresh();
  }

  void removeCardClear(int id) {
    for (final element in list) {
      if (element["id"] == id) {
        element["count"] = 0;
        Get.find<Fav_Cart_Controller>().removeCartClear(id);
      }
    }
    list.removeWhere((element) => element["count"] == 0);
    list.refresh();
  }

  Future<List<CartModel>> loadData({Map<String, String>? parametrs}) async {
    String lang = Get.locale!.languageCode;
    if (lang == "tr") lang = "tm";
    final response = await http.get(
        Uri.parse(
          "$serverURL/api/$lang/get-cart-products",
        ).replace(queryParameters: parametrs),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200 && (jsonDecode(response.body)["rows"]) != null) {
      loading.value = 1;
      list.clear();
      final responseJson = jsonDecode(response.body)["rows"];
      for (final Map product in responseJson) {
        list.add({
          "id": CartModel.fromJson(product).id,
          "name": CartModel.fromJson(product).name,
          "count": 0,
          "discountValue": CartModel.fromJson(product).discountValue,
          "image": CartModel.fromJson(product).image,
          "price": CartModel.fromJson(product).price,
          "stockMin": CartModel.fromJson(product).stock
        });
      }
      for (int i = 0; i < list.length; i++) {
        for (int j = 0; j < Get.find<Fav_Cart_Controller>().cartList.length; j++) {
          if (list[i]["id"] == Get.find<Fav_Cart_Controller>().cartList[j]["id"]) {
            list[i]["count"] = Get.find<Fav_Cart_Controller>().cartList[j]["count"];
          }
        }
      }
      return [];
    } else {
      loading.value = 2;
      return [];
    }
  }
}
