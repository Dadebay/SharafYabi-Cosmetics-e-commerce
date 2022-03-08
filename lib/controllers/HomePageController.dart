// ignore_for_file: file_names, always_declare_return_types, type_annotate_public_apis, unnecessary_null_comparison, avoid_void_async, avoid_dynamic_calls, unrelated_type_equality_checks, non_constant_identifier_names

import 'dart:convert';

import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';
import 'package:sharaf_yabi_ecommerce/models/ProductsModel.dart';

class HomePageController extends GetxController {
  Fav_Cart_Controller fav_cart_controller = Get.put(Fav_Cart_Controller());

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

  // /recomended
  int addCartFavlist = 0;
  RxList listFavlist = [].obs;
  RxInt loadingFavlist = 0.obs;

  refreshList() {
    list.clear();
    listNewInCome.clear();
    listRecomended.clear();
    listFavlist.clear();
    loading.value = 0;
    loadingNewInCome.value = 0;
    loadingRecomended.value = 0;
    loadingFavlist.value = 0;

    fetchDiscountedProducts();
    fetchPopularProducts();
    fetchNewInComeProducts();
    fetcbFavListProducts();
  }

  void fetchDiscountedProducts() async {
    print("home Page cekdi");
    final products = await ProductsModel().getProducts(parametrs: {
      "page": '${1}',
      "limit": '4',
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
          "count": addCart,
          "stockCount": element.stockCount ?? 0
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
      "limit": '4',
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
          "count": addCartNewInCome,
          "stockCount": element.stockCount ?? 0
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
      "limit": '10',
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
          "count": addCartRecomended,
          "stockCount": element.stockCount ?? 0
        });
      }

      loadingRecomended.value = 1;
    } else if (products.isEmpty || products == null) {
      loadingRecomended.value = 2;
    } else {
      loadingRecomended.value = 3;
    }
  }

  void fetcbFavListProducts() async {
    listFavlist.clear();
    final products = await ProductsModel().getFavorites(parametrs: {"products": jsonEncode(fav_cart_controller.favList)});
    if (products.isNotEmpty) {
      for (final element in products) {
        addCartFavlist = 0;
        for (final element2 in Get.find<Fav_Cart_Controller>().cartList) {
          if (element.id == element2["id"]) {
            addCartFavlist = element2["count"];
          }
        }
        listFavlist.add({
          "id": element.id ?? 0,
          "name": element.productName ?? "Ady",
          "price": element.price ?? "0",
          "image": element.imagePath ?? "",
          "discountValue": element.discountValue ?? 0,
          "count": addCartFavlist,
          "stockCount": element.stockCount ?? 0
        });
      }

      loadingFavlist.value = 1;
    } else if (products.isEmpty || products == null) {
      loadingFavlist.value = 2;
    } else {
      loadingFavlist.value = 3;
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

  addFavListCart(int id, String price) {
    if (listFavlist.isEmpty) {
      listFavlist.add({"id": id, "count": 1, "price": price});
    } else {
      bool value = false;
      for (final element in listFavlist) {
        if (element["id"] == id) {
          element["count"] += 1;
          value = true;
        }
      }
      if (value == false) {
        listFavlist.add({"id": id, "count": 1, "price": price});
      }
    }
  }

  removeFavListCart(int id) {
    for (final element in listFavlist) {
      if (element["id"] == id) {
        element["count"] -= 1;
      }
    }
  }

  searchAndAdd(int iD, String priceMine) {
    bool value = false;
    chechFavAndSame(iD, priceMine);
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

  chechFavAndSame(int iD, String priceMine) {
    for (final element in listFavlist) {
      if (element["id"] == iD) {
        addFavListCart(iD, priceMine);
      }
    }
  }

  chechFavAndSameRemove(int iD) {
    for (final element in listFavlist) {
      if (element["id"] == iD) {
        removeFavListCart(iD);
      }
    }
  }

  searchAndRemove(int iD) {
    bool value = false;
    chechFavAndSameRemove(iD);

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
