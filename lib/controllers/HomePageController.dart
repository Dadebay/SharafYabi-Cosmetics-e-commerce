// ignore_for_file: file_names, always_declare_return_types, type_annotate_public_apis, unnecessary_null_comparison, avoid_void_async, avoid_dynamic_calls, unrelated_type_equality_checks

import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';
import 'package:sharaf_yabi_ecommerce/models/ProductsModel.dart';

class HomePageController extends GetxController {
  ///discounted
  int addCart = 0;
  RxList list = [].obs;
  RxInt loading = 0.obs;

  ///newIncome
  int addCartNewInCome = 0;
  RxList listNewInCome = [].obs;
  RxInt loadingNewInCome = 0.obs;

  // /recomended
  int addCartRecomended = 0;
  RxList listRecomended = [].obs;
  RxInt loadingRecomended = 0.obs;
  // /otherList
  // int addCartOtherList = 0;
  // RxList listOtherList = [].obs;
  // RxInt loadingOtherList = 0.obs;
  void fetchDiscountedProducts() async {
    final products = await ProductsModel().getProducts(parametrs: {
      "page": '${1}',
      "limit": '30',
      "discounts": "${true}",
    });
    if (products.isNotEmpty) {
      for (final element in products) {
        addCart = 0;
        for (final element2 in Get.find<Fav_Cart_Controller>().cartList) {
          if (element.id == element2["id"]) {
            addCart = element2["count"];
          }
        }
        list.add({
          "id": element.id ?? 0,
          "name": element.productName ?? "Ady",
          "price": element.price ?? "0",
          "image": element.imagePath ?? "",
          "discountValue": element.discountValue ?? 0,
          "count": addCart
        });
      }

      loading.value = 1;
    } else if (products.isEmpty || products == null) {
      loading.value = 2;
    } else {
      loading.value = 3;
    }
  }

  void fetchNewInComeProducts() async {
    final products = await ProductsModel().getProducts(parametrs: {
      "page": '${1}',
      "limit": '30',
      "new_in_come": "${true}",
    });
    if (products.isNotEmpty) {
      for (final element in products) {
        addCartNewInCome = 0;
        for (final element2 in Get.find<Fav_Cart_Controller>().cartList) {
          if (element.id == element2["id"]) {
            addCartNewInCome = element2["count"];
          }
        }
        listNewInCome.add({
          "id": element.id ?? 0,
          "name": element.productName ?? "Ady",
          "price": element.price ?? "0",
          "image": element.imagePath ?? "",
          "discountValue": element.discountValue ?? 0,
          "count": addCartNewInCome
        });
      }

      loadingNewInCome.value = 1;
    } else if (products.isEmpty || products == null) {
      loadingNewInCome.value = 2;
    } else {
      loadingNewInCome.value = 3;
    }
  }

  void fetchPopularProducts() async {
    final products = await ProductsModel().getProducts(parametrs: {
      "page": '${1}',
      "limit": '30',
      "recomended": "${true}",
    });
    if (products.isNotEmpty) {
      for (final element in products) {
        addCartRecomended = 0;
        for (final element2 in Get.find<Fav_Cart_Controller>().cartList) {
          if (element.id == element2["id"]) {
            addCartRecomended = element2["count"];
          }
        }
        listRecomended.add({
          "id": element.id ?? 0,
          "name": element.productName ?? "Ady",
          "price": element.price ?? "0",
          "image": element.imagePath ?? "",
          "discountValue": element.discountValue ?? 0,
          "count": addCartRecomended
        });
      }

      loadingRecomended.value = 1;
    } else if (products.isEmpty || products == null) {
      loadingRecomended.value = 2;
    } else {
      loadingRecomended.value = 3;
    }
  }

  addDiscountedItemCart(int id, String price) {
    if (list.isEmpty) {
      list.add({"id": id, "count": 1, "price": price});
    } else {
      bool value = false;
      for (final element in list) {
        if (element["id"] == id) {
          element["count"] += 1;
          value = true;
        }
      }
      if (value == false) {
        list.add({"id": id, "count": 1, "price": price});
      }
    }
  }

  removeDiscountedItemCart(int id) {
    for (final element in list) {
      if (element["id"] == id) {
        element["count"] -= 1;
      }
    }
  }

  addNewInComeCart(int id, String price) {
    if (listNewInCome.isEmpty) {
      listNewInCome.add({"id": id, "count": 1, "price": price});
    } else {
      bool value = false;
      for (final element in listNewInCome) {
        if (element["id"] == id) {
          element["count"] += 1;
          value = true;
        }
      }
      if (value == false) {
        listNewInCome.add({"id": id, "count": 1, "price": price});
      }
    }
  }

  removeNewInComeCart(int id) {
    for (final element in listNewInCome) {
      if (element["id"] == id) {
        element["count"] -= 1;
      }
    }
  }

  addRecommendedCart(int id, String price) {
    if (listRecomended.isEmpty) {
      listRecomended.add({"id": id, "count": 1, "price": price});
    } else {
      bool value = false;
      for (final element in listRecomended) {
        if (element["id"] == id) {
          element["count"] += 1;
          value = true;
        }
      }
      if (value == false) {
        listRecomended.add({"id": id, "count": 1, "price": price});
      }
    }
  }

  removeRecommendedCart(int id) {
    for (final element in listRecomended) {
      if (element["id"] == id) {
        element["count"] -= 1;
      }
    }
  }

  searchAndAdd(int iD, String priceMine) {
    bool value = false;
    for (final element in list) {
      if (element["id"] == iD) {
        value = true;
        addDiscountedItemCart(iD, priceMine);
      }
    }
    if (value == false) {
      for (final element in listNewInCome) {
        if (element["id"] == iD) {
          value = true;
          addNewInComeCart(iD, priceMine);
        }
      }
    }
    if (value == false) {
      for (final element in listRecomended) {
        if (element["id"] == iD) {
          value = true;
          addRecommendedCart(iD, priceMine);
        }
      }
    }
  }

  searchAndRemove(int iD) {
    bool value = false;
    for (final element in list) {
      if (element["id"] == iD) {
        value = true;
        removeDiscountedItemCart(
          iD,
        );
      }
    }
    if (value == false) {
      for (final element in listNewInCome) {
        if (element["id"] == iD) {
          value = true;
          removeNewInComeCart(
            iD,
          );
        }
      }
    }
    if (value == false) {
      for (final element in listRecomended) {
        if (element["id"] == iD) {
          value = true;
          removeRecommendedCart(
            iD,
          );
        }
      }
    }
  }
}
