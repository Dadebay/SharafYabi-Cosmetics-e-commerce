// ignore_for_file: file_names, always_use_package_imports

import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/controllers/BannerController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';

import 'AuthController.dart';
import 'CartPageController.dart';
import 'Fav_Cart_Controller.dart';
import 'SettingsController.dart';

class AllControllerBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<CartPageController>(() => CartPageController());
    Get.lazyPut<Fav_Cart_Controller>(() => Fav_Cart_Controller());
    Get.lazyPut<BannerController>(() => BannerController());
    Get.lazyPut<SettingsController>(() => SettingsController());
    Get.lazyPut<FilterController>(() => FilterController());
  }
}
