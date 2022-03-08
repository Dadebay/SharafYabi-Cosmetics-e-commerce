// ignore_for_file: avoid_redundant_argument_values, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/controllers/AuthController.dart';

class AgreeButton extends StatelessWidget {
  AgreeButton({
    required this.name,
    required this.onTap,
  });

  final Function() onTap;
  final AuthController authController = Get.put(AuthController());
  final String name;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: onTap,
        child: PhysicalModel(
          elevation: 4,
          borderRadius: borderRadius10,
          color: kPrimaryColor,
          shadowColor: Colors.black,
          child: AnimatedContainer(
            decoration: const BoxDecoration(
              borderRadius: borderRadius10,
              color: kPrimaryColor,
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            curve: Curves.ease,
            width: authController.signInAnimation.value ? 70 : Get.size.width,
            duration: const Duration(milliseconds: 1000),
            child: authController.signInAnimation.value
                ? const Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  )
                : Text(
                    name.tr,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, fontFamily: montserratSemiBold, color: Colors.white),
                  ),
          ),
        ),
      );
    });
  }
}
