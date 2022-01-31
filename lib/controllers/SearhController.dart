// ignore_for_file: file_names, always_declare_return_types, type_annotate_public_apis, camel_case_types

import 'package:get/state_manager.dart';

class Fav_Cart_Controller extends GetxController {
  RxInt sortValue = 1.obs;
  changeSortValue(int index) {
    sortValue.value = index;
  }
}
