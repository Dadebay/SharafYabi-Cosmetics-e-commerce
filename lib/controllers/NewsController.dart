// ignore_for_file: file_names, always_declare_return_types, type_annotate_public_apis, unnecessary_null_comparison, avoid_void_async

import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/models/NewsModel.dart';

class NewsController extends GetxController {
  RxList list = [].obs;
  RxInt loading = 0.obs;
  RxInt page = 1.obs;
  RxInt pageNumberNews = 0.obs;

  void fetchProducts() async {
    loading.value = 0;
    final products = await NewsModel().getNews(parametrs: {
      "page": '${page.value}',
      "limit": '20',
    });
    if (products.isNotEmpty) {
      for (final element in products) {
        list.add({
          "id": element.id ?? 0,
          "image": element.imagePath ?? "",
          "title": element.title ?? "",
          "article": element.article ?? "",
          "createdAt": element.createdAt ?? "",
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
    a = pageNumberNews.value;
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
}
