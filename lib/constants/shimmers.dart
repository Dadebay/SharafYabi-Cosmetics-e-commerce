import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

GridView shimmer(int count) {
  return GridView.builder(
      itemCount: count,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: Get.size.width <= 800 ? 2 : 4, childAspectRatio: 3 / 4.5),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.all(4),
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

Widget bannerCardShimmer() {
  return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      period: const Duration(seconds: 2),
      highlightColor: Colors.grey.withOpacity(0.1),
      child: AspectRatio(
        aspectRatio: 16 / 8,
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: borderRadius10),
        ),
      ));
}

Widget cartCardShimmer() {
  return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 150,
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: RaisedButton(
            color: Colors.white,
            padding: EdgeInsets.zero,
            disabledColor: Colors.white,
            highlightColor: backgroundColor,
            elevation: 0,
            shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
            onPressed: () {},
            child: Row(
              children: [
                Expanded(
                    child: Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.2),
                        highlightColor: Colors.grey.withOpacity(0.1),
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            borderRadius: borderRadius5,
                            color: Colors.red,
                          ),
                        ))),
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey.withOpacity(0.2),
                            highlightColor: Colors.grey.withOpacity(0.1),
                            child: Container(
                              color: Colors.white,
                              child: const Text(
                                "asdsdadsasdasda",
                                style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: montserratMedium),
                              ),
                            ),
                          ),
                          Shimmer.fromColors(
                            baseColor: Colors.grey.withOpacity(0.2),
                            highlightColor: Colors.grey.withOpacity(0.1),
                            child: Container(
                              color: Colors.white,
                              child: const Text(
                                "dqawdqwdq",
                                style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: montserratMedium),
                              ),
                            ),
                          ),
                          Shimmer.fromColors(
                            baseColor: Colors.grey.withOpacity(0.2),
                            highlightColor: Colors.grey.withOpacity(0.1),
                            child: Container(
                              color: Colors.white,
                              child: const Text(
                                "qwdwdqddwqwdqw",
                                style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: montserratMedium),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        );
      });
}

Widget shimmerBrand() {
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 3 / 3.2),
    itemBuilder: (BuildContext context, int index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.3),
        highlightColor: Colors.grey.withOpacity(0.1),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(color: Colors.black, borderRadius: borderRadius10),
        ),
      );
    },
  );
}

Widget shimmerCategory() {
  return ListView.builder(
    itemCount: 15,
    itemBuilder: (BuildContext context, int index) {
      return Container(
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.25)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.3),
              highlightColor: Colors.grey.withOpacity(0.1),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: backgroundColor.withOpacity(0.4),
                ),
                margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                width: 85,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey.withOpacity(0.2),
                    highlightColor: Colors.grey.withOpacity(0.1),
                    child: Container(
                      color: Colors.white,
                      margin: const EdgeInsets.only(top: 14, bottom: 10),
                      child: const Text(
                        "asdasdasddas",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: montserratSemiBold,
                        ),
                      ),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.withOpacity(0.2),
                    highlightColor: Colors.grey.withOpacity(0.1),
                    child: Container(
                      color: Colors.white,
                      child: const Text(
                        "das",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: montserratSemiBold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
