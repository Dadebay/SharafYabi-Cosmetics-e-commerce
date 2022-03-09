// ignore_for_file: file_names, always_declare_return_types, type_annotate_public_apis, camel_case_types, avoid_dynamic_calls

import 'dart:convert';

import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';

class Fav_Cart_Controller extends GetxController {
  RxList cartList = [].obs;
  RxList favList = [].obs;
  RxDouble priceAll = 0.0.obs;

  RxInt orderTick = 0.obs;
  RxInt promoDiscount = 0.obs;
  RxBool promoLottie = false.obs;
  final storage = GetStorage();

  ///////////////////////////////////////FAVORITE PART//////////////////////////////////////////////////
  toggleFav(int id) {
    if (favList.isEmpty) {
      favList.add({"id": id});
    } else {
      bool value = false;
      for (final element in favList) {
        if (element["id"] == id) {
          value = true;
        }
      }
      if (value == true) {
        favList.removeWhere((element) => element["id"] == id);
      } else if (value == false) {
        favList.add({"id": id});
      }
    }
    favList.refresh();
    final String jsonString = jsonEncode(favList);
    storage.write("favList", jsonString);
  }

  returnFavList() {
    final result = storage.read('favList') ?? "[]";
    final List jsonData = jsonDecode(result);
    if (jsonData.isNotEmpty) {
      for (final element in jsonData) {
        toggleFav(element["id"]);
      }
    }
  }

  clearFavList() {
    favList.clear();
    final String jsonString = jsonEncode(favList);
    storage.write("favList", jsonString);
  }

///////////////////////////////////////CART PART//////////////////////////////////////////////////
  addCart(int id, String price) {
    if (cartList.isEmpty) {
      cartList.add({"id": id, "count": 1, "price": price});
    } else {
      bool value = false;
      for (final element in cartList) {
        if (element["id"] == id) {
          element["count"] += 1;
          value = true;
        }
      }
      if (value == false) {
        cartList.add({"id": id, "count": 1, "price": price});
      }
    }
    final String jsonString = jsonEncode(cartList);
    storage.write("cartList", jsonString);
    findSumma();
  }

  removeCart(int id) {
    for (final element in cartList) {
      if (element["id"] == id) {
        element["count"] -= 1;
      }
    }
    cartList.removeWhere((element) => element["count"] == 0);
    final String jsonString = jsonEncode(cartList);
    storage.write("cartList", jsonString);
    findSumma();
  }

  findSumma() {
    priceAll.value = 0.0;
    for (final element in cartList) {
      final double price = double.parse(element["price"]);
      priceAll.value += price * element["count"];
    }
  }

  returnCartList() {
    final result = storage.read('cartList') ?? "[]";
    final List jsonData = jsonDecode(result);
    if (jsonData.isNotEmpty) {
      for (final element in jsonData) {
        cartList.add({"id": element["id"], "count": element["count"], "price": element["price"]});
      }
    }
    findSumma();
  }

  clearCartList() {
    cartList.clear();
    final String jsonString = jsonEncode(cartList);
    storage.write("cartList", jsonString);
    findSumma();
  }

  removeCartClear(int id) {
    for (final element in cartList) {
      if (element["id"] == id) {
        element["count"] = 0;
      }
    }
    cartList.removeWhere((element) => element["count"] == 0);
    final String jsonString = jsonEncode(cartList);
    storage.write("cartList", jsonString);
    findSumma();
  }

  //
  RxInt fucking = 0.obs;
}
