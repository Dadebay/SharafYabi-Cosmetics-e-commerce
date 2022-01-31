// ignore_for_file: type_annotate_public_apis, always_declare_return_types, file_names

import 'package:get/state_manager.dart';

class AuthController extends GetxController {
  RxBool signInAnimation = true.obs;
  RxBool loginInAnimation = true.obs;
  RxBool signInObscure = true.obs;
  RxBool profileSettingsObscure = true.obs;
  RxBool profileSettingsEnabled = false.obs;
  RxString userId = "".obs;
  @override
  void onInit() {
    signInObscure.value = true;
    signInAnimation.value = false;
    loginInAnimation.value = false;
    super.onInit();
  }

  changeSignInObscure() {
    if (signInObscure.isTrue) {
      signInObscure.toggle();
    } else {
      signInObscure.value = true;
    }
  }

  changeSignInAnimation() {
    if (signInAnimation.isTrue) {
      signInAnimation.toggle();
    } else {
      signInAnimation.value = true;
    }
  }

  changeLoginInAnimation() {
    if (loginInAnimation.isTrue) {
      loginInAnimation.toggle();
    } else {
      loginInAnimation.value = true;
    }
  }
}
