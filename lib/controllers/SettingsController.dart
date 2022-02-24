// ignore_for_file: file_names, always_declare_return_types, type_annotate_public_apis, avoid_dynamic_calls

import 'dart:convert';
import 'dart:ui';

import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  final storage = GetStorage();
  RxList orderList = [].obs;
  RxBool connectionState = false.obs;
  RxInt bannerSelectedIndex = 0.obs;
  RxInt bottomBadgeCount = 0.obs;
  RxInt addressCount = 0.obs;

  var tm = const Locale(
    'tr',
  );
  var ru = const Locale(
    'ru',
  );
  var en = const Locale(
    'en',
  );

  saveID(int? id) {
    orderList.add({"id": id});
    final String jsonString = jsonEncode(orderList);
    storage.write("order", jsonString);
  }

  returnOrderList() {
    orderList.clear();
    final result = storage.read('order') ?? "[]";
    final List jsonData = jsonDecode(result);
    for (final element in jsonData) {
      orderList.add({"id": element["id"]});
    }
  }

  switchLang(String value) {
    if (value == "en") {
      Get.updateLocale(en);
      storage.write('langCode', 'en');
    } else if (value == "ru") {
      Get.updateLocale(ru);
      storage.write('langCode', 'ru');
    } else {
      Get.updateLocale(tm);
      storage.write('langCode', 'tr');
    }
    update();
  }
}
