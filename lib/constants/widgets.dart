// ignore_for_file: deprecated_member_use, duplicate_ignore, implementation_imports, avoid_positional_boolean_parameters, unnecessary_null_comparison, always_use_package_imports

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import 'constants.dart';

SnackbarController showSnackBar(String title, String subtitle, Color color) {
  return Get.snackbar(title, subtitle,
      titleText: Text(
        title.tr,
        style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 16, color: Colors.white),
      ),
      messageText: Text(
        subtitle.tr,
        style: const TextStyle(fontFamily: montserratRegular, fontSize: 14, color: Colors.white),
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color,
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20));
}

String lang = "ru";

Future<String> languageCode() async {
  if (Get.locale!.languageCode == null) {
    if (Get.locale!.languageCode == "en") {
      lang = "tm";
    } else if (Get.locale!.languageCode == "ru") {
      return lang = "ru";
    }
  } else {
    return lang = "ru";
  }
  return "ru";
}

Widget errorConnection({required Function() onTap}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset("assets/lottie/noconnection.json", animate: true, height: 300, width: 400),
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
                style: const TextStyle(color: Colors.black, fontSize: 20, fontFamily: montserratSemiBold),
              ),
              const SizedBox(height: 15),
              Text(
                "error404".tr,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratMedium),
              ),
            ],
          ),
        ),
        RaisedButton(
          onPressed: onTap,
          shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
          color: kPrimaryColor,
          child: Text(
            "retry".tr,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: montserratSemiBold),
          ),
        ),
      ],
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
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/icons/svgIcons/logo.svg",
          color: Colors.grey[500],
          width: 140,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "noImage".tr,
          style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold),
        )
      ],
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
  return const SpinKitWave(
    color: kPrimaryColor,
    size: 40,
  );
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
      body = myText("scrollTop");
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

Padding namePart({Function()? onTap, String? name}) {
  return Padding(
    padding: const EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name!, style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 18)),
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Text("all".tr, style: const TextStyle(color: kPrimaryColor, fontFamily: montserratMedium, fontSize: 14)),
              const SizedBox(
                width: 8,
              ),
              const Icon(IconlyLight.arrowRightCircle, size: 20, color: kPrimaryColor),
            ],
          ),
        )
      ],
    ),
  );
}

Container shimmerHomeCard() {
  return Container(
    width: 140,
    margin: const EdgeInsets.only(left: 15, top: 25),
    decoration: const BoxDecoration(color: Colors.white, borderRadius: borderRadius5),
    child: Column(
      children: [
        Expanded(
          flex: 2,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            period: const Duration(seconds: 2),
            highlightColor: Colors.grey.withOpacity(0.1),
            child: Container(
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))),
            ),
          ),
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                period: const Duration(seconds: 2),
                highlightColor: Colors.grey.withOpacity(0.1),
                child: Container(
                  color: Colors.white,
                  height: 20,
                  margin: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                    top: 8,
                  ),
                  width: Get.size.width,
                )),
            Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                period: const Duration(seconds: 2),
                highlightColor: Colors.grey.withOpacity(0.1),
                child: Container(
                  color: Colors.white,
                  height: 20,
                  margin: const EdgeInsets.only(
                    right: 8,
                    top: 8,
                    left: 8,
                  ),
                  width: 80,
                )),
          ],
        ))
      ],
    ),
  );
}

Widget image(
  String name,
) {
  return Container(
    height: Get.size.height,
    width: Get.size.width,
    margin: const EdgeInsets.all(4),
    decoration: const BoxDecoration(
      borderRadius: borderRadius10,
    ),
    child: CachedNetworkImage(
        fadeInCurve: Curves.ease,
        imageUrl: name,
        imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius10,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
        placeholder: (context, url) => Center(child: spinKit()),
        errorWidget: (context, url, error) => Padding(
              padding: const EdgeInsets.all(30.0),
              child: Image.asset(
                "assets/appLogo/greyLogo.png",
                color: Colors.grey,
              ),
            )),
  );
}

GridView shimmer(int count) {
  return GridView.builder(
      itemCount: count,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: Get.size.width <= 800 ? 2 : 4, childAspectRatio: 3 / 4.5),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.all(10),
          child: RaisedButton(
              padding: const EdgeInsets.all(10),
              elevation: 1,
              shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
              color: Colors.white,
              onPressed: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.white, borderRadius: borderRadius5),
                      ),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: Get.size.width / 4,
                      color: Colors.grey,
                      height: 20,
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: Get.size.width / 3,
                      color: Colors.grey,
                      height: 20,
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: Get.size.width,
                      decoration: const BoxDecoration(color: Colors.grey, borderRadius: borderRadius5),
                      height: 35,
                    ),
                  ),
                ],
              )),
        );
      });
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
