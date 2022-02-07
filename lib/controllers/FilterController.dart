// ignore_for_file: file_names, always_declare_return_types, type_annotate_public_apis, unnecessary_null_comparison, avoid_void_async, avoid_dynamic_calls, unrelated_type_equality_checks

import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';
import 'package:sharaf_yabi_ecommerce/models/ProductsModel.dart';

class FilterController extends GetxController {
  int addCart = 0;
  RxList list = [].obs;
  RxList categoryID = [].obs;
  RxList categoryIDOnlyID = [].obs;
  RxList producersID = [].obs;
  RxList brandList = [].obs;
  RxList categoryList = [].obs;
  RxInt loading = 0.obs;
  RxInt page = 1.obs;
  RxInt mainCategoryID = 0.obs;
  RxBool discountBool = false.obs;
  RxString sortName = "".obs;
  RxString sortColumnName = "".obs;
  RxBool recomended = false.obs;
  RxBool newInCome = false.obs;
  RxString search = "".obs;
  RxInt pageNumberFilterController = 0.obs;
  RxBool favButton = false.obs;

  void fetchProducts() async {
    if (categoryID.isNotEmpty) {
      categoryIDOnlyID.clear();
      for (final element in categoryID) {
        categoryIDOnlyID.add(element["id"]);
      }
    } else {
      categoryIDOnlyID.clear();
    }

    final products = await ProductsModel().getProducts(parametrs: {
      "page": '${page.value}',
      "limit": '20',
      "sort_direction": "$sortName",
      "sort_column": "$sortColumnName",
      "recomended": "${recomended == false ? "" : true}",
      "discounts": "${discountBool == false ? "" : true}",
      "new_in_come": "${newInCome == false ? "" : true}",
      "producer_id": "$producersID",
      "category_id": "$categoryIDOnlyID",
      "main_category_id": "${mainCategoryID == 0 ? "" : mainCategoryID}",
      "search": "$search"
    });
    if (products.isNotEmpty) {
      for (final element in products) {
        addCart = 1;
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

  addPage() {
    int a = 0;
    a = pageNumberFilterController.value;
    if ((a / 20) > page.value + 1) {
      page.value += 1;
      fetchProducts();
    }
  }

  refreshPage() {
    page.value = 1;
    list.clear();
    loading.value = 0;
    fetchProducts();
  }

  ///////////////////////////////////////Brand PART//////////////////////////////////////////////////
  writeBrandList(int? id, String? name) {
    bool valueMine = false;
    bool branValue = false;
    for (final element in brandList) {
      if (element["id"] == id) {
        valueMine = true;
        branValue = element["value"];
      }
    }
    if (valueMine == false) {
      brandList.add({"id": id, "name": name, "value": branValue});
    } else {
      for (final element in brandList) {
        if (element["id"] == id) {
          element["value"] = branValue;
        }
      }
    }
  }

// ///////////////////////////////////////Brand PART//////////////////////////////////////////////////
  writeCategoryList(int? id, String? name, int? mainCategoryID) {
    bool valueMine = false;
    bool categoryValue = false;

    for (final element in categoryList) {
      if (element["id"] == id) {
        valueMine = true;
        categoryValue = element["value"];
      }
    }
    if (valueMine == false) {
      categoryList.add({"id": id, "name": name, "value": categoryValue, "mainCategoryID": mainCategoryID});
    } else {
      for (final element in brandList) {
        if (element["id"] == id) {
          element["value"] = categoryValue;
        }
      }
    }
  }
}
