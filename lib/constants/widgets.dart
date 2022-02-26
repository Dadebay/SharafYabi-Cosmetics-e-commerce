// ignore_for_file: deprecated_member_use, duplicate_ignore, implementation_imports, avoid_positional_boolean_parameters, unnecessary_null_comparison, always_use_package_imports

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:shimmer/shimmer.dart';

import 'constants.dart';

SnackbarController showSnackBar(String title, String subtitle, Color color) {
  return Get.snackbar(
    title,
    subtitle,
    snackStyle: SnackStyle.FLOATING,
    titleText: title == ""
        ? const SizedBox.shrink()
        : Text(
            title.tr,
            style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 16, color: Colors.white),
          ),
    messageText: Text(
      subtitle.tr,
      style: const TextStyle(fontFamily: montserratRegular, fontSize: 14, color: Colors.white),
    ),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: color,
    borderRadius: 10.0,
    margin: const EdgeInsets.all(8),
  );
}

void showCustomToast(BuildContext context, String name) {
  showToast(
    name.tr,
    textStyle: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: montserratSemiBold),
    context: context,
    alignment: Alignment.bottomCenter,
    backgroundColor: kPrimaryColor,
    axis: Axis.horizontal,
    position: StyledToastPosition.bottom,
    curve: Curves.decelerate,
    reverseCurve: Curves.decelerate,
    animation: StyledToastAnimation.none,
    reverseAnimation: StyledToastAnimation.none,
    duration: const Duration(seconds: 3),
    animDuration: const Duration(seconds: 1),
    dismissOtherToast: true,
    fullWidth: false,
    isHideKeyboard: false,
    isIgnoring: true,
  );
}

Widget errorConnection({
  required Function() onTap,
  double? sizeWidth,
}) {
  return Container(
    color: Colors.white,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(noConnection, animate: true, fit: BoxFit.contain, height: sizeWidth! > 800 ? 500 : 300, width: sizeWidth > 800 ? 500 : 400),
          Container(
            color: Colors.white,
            width: Get.size.width,
            transform: Matrix4.translationValues(0, -30, 0),
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              children: [
                Text(
                  "noConnection1".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: sizeWidth > 800 ? 32 : 18, fontFamily: montserratMedium),
                ),
                const SizedBox(height: 15),
                Text(
                  "error404".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: sizeWidth > 800 ? 26 : 16, fontFamily: montserratRegular),
                ),
              ],
            ),
          ),
          RaisedButton(
            padding: sizeWidth > 800 ? const EdgeInsets.symmetric(horizontal: 15, vertical: 10) : const EdgeInsets.symmetric(horizontal: 5),
            onPressed: onTap,
            shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
            color: kPrimaryColor,
            child: Text(
              "retry".tr,
              style: TextStyle(color: Colors.white, fontSize: sizeWidth > 800 ? 30 : 16, fontFamily: montserratSemiBold),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget emptyData({required String errorTitle, required String errorSubtitle, String? imagePath}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (imagePath == "")
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Icon(
              CupertinoIcons.info_circle,
              color: Colors.black,
              size: 80,
            ),
          )
        else
          Image.asset(
            imagePath!,
            color: kPrimaryColor,
            fit: BoxFit.contain,
            height: 200,
          ),
        Padding(
          padding: const EdgeInsets.only(top: 25, bottom: 15),
          child: Text(
            errorTitle.tr,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratSemiBold),
          ),
        ),
        Text(
          errorSubtitle.tr,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: montserratMedium),
        ),
      ],
    ),
  );
}

Widget emptyDataLottie({required String errorTitle, required String errorSubtitle, String? imagePath}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      if (imagePath == "")
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Icon(
            CupertinoIcons.info_circle,
            color: Colors.black,
            size: 80,
          ),
        )
      else
        Lottie.asset(imagePath!, height: 400, fit: BoxFit.cover),
      Container(
        transform: Matrix4.translationValues(0, -50, 0),
        child: Column(
          children: [
            Text(
              errorTitle.tr,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratSemiBold),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              errorSubtitle.tr,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: montserratMedium),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget noImage() {
  return Container(
    padding: const EdgeInsets.all(6.0),
    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: borderRadius15),
    child: Image.asset(
      appLogo,
      color: Colors.grey,
    ),
  );
}

Widget dividerr() {
  return Container(
    color: Colors.grey[300],
    margin: const EdgeInsets.symmetric(horizontal: 20),
    width: double.infinity,
    height: 1,
  );
}

Widget spinKit() {
  return Lottie.asset(spinKitLoading, animate: true, width: 200, height: 200);
}

CustomFooter loadMore() {
  Text myText(String name) {
    return Text(name.tr,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
          fontFamily: montserratMedium,
        ));
  }

  return CustomFooter(builder: (BuildContext context, LoadStatus? mode) {
    Widget body;
    if (mode == LoadStatus.idle) {
      body = Obx(() {
        return myText(Get.find<FilterController>().scroltoName.value);
      });
    } else if (mode == LoadStatus.loading) {
      body = const CupertinoActivityIndicator(
        radius: 15,
      );
    } else if (mode == LoadStatus.failed) {
      body = myText("retry");
    } else if (mode == LoadStatus.canLoading) {
      body = const Icon(
        IconlyBroken.arrowDown,
        color: Colors.black,
        size: 35,
      );
    } else {
      body = myText("retry");
    }
    return SizedBox(
      height: 55.0,
      child: Center(child: body),
    );
  });
}

Padding namePart({Function()? onTap, String? name, double? sizeWidth, double? sizeHeight}) {
  return Padding(
    padding: const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name!, style: TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: sizeWidth! > 800 ? 28 : 18)),
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Text("all".tr, style: TextStyle(color: kPrimaryColor, fontFamily: montserratMedium, fontSize: sizeWidth > 800 ? 22 : 14)),
              const SizedBox(
                width: 8,
              ),
              Icon(IconlyLight.arrowRightCircle, size: sizeWidth > 800 ? 25 : 20, color: kPrimaryColor),
            ],
          ),
        )
      ],
    ),
  );
}

Widget discountText(String discountText) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
    decoration: const BoxDecoration(color: Colors.red, borderRadius: borderRadius5),
    child: Text("- $discountText %", style: const TextStyle(color: Colors.white, fontFamily: montserratRegular, fontSize: 12)),
  );
}

Center retryButton(Function() onTap) {
  return Center(
      child: RaisedButton(
          onPressed: onTap,
          shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
          color: kPrimaryColor,
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.refresh, color: Colors.white, size: 35),
              const SizedBox(
                width: 10,
              ),
              Text(
                "tryagain".tr,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: montserratSemiBold),
              ),
            ],
          )));
}

Widget cachedMyImage(String image) {
  return CachedNetworkImage(
      fadeInCurve: Curves.ease,
      imageUrl: image,
      imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius15,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
      placeholder: (context, url) => Center(child: spinKit()),
      errorWidget: (context, url, error) => noImage());
}
