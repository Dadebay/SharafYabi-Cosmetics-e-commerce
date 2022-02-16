// ignore_for_file: file_names, always_declare_return_types, type_annotate_public_apis, camel_case_types, avoid_dynamic_calls

import 'package:get/state_manager.dart';

class ProductProfilController extends GetxController {
  RxBool favBool = false.obs;
  RxInt stockCount = 0.obs;
  RxInt quantity = 1.obs;
}
