// ignore_for_file: file_names, always_declare_return_types, type_annotate_public_apis, camel_case_types, avoid_dynamic_calls

import 'dart:convert';

import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';

class Fav_Cart_Controller extends GetxController {
  RxList cartList = [].obs;
  RxList favList = [].obs;

  RxInt promoDiscount = 0.obs;
  RxBool promoLottieADDCoin = false.obs;
  RxBool promoLottie = false.obs;
  RxBool favBool = false.obs;
  RxBool addCartBool = false.obs;
  RxInt stockCount = 0.obs;
  RxInt quantity = 1.obs;
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
  addCart(int id) {
    if (cartList.isEmpty) {
      cartList.add({"id": id, "count": 1});
    } else {
      bool value = false;
      for (final element in cartList) {
        if (element["id"] == id) {
          element["count"] += 1;
          value = true;
        }
      }
      if (value == false) {
        cartList.add({"id": id, "count": 1});
      }
    }
    final String jsonString = jsonEncode(cartList);
    storage.write("cartList", jsonString);
  }

  returnCartList() {
    final result = storage.read('cartList') ?? "[]";
    final List jsonData = jsonDecode(result);
    if (jsonData.isNotEmpty) {
      for (final element in jsonData) {
        cartList.add({"id": element["id"], "count": element["count"]});
      }
    }
  }

  clearCartList() {
    cartList.clear();
    final String jsonString = jsonEncode(cartList);
    storage.write("cartList", jsonString);
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
  }
}
