// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/screens/News_Videos/NewsProfil.dart';

class NewsCard extends StatelessWidget {
  final int id;
  final String image;
  final String name;
  final String createdAt;

  const NewsCard({Key? key, required this.id, required this.image, required this.name, required this.createdAt}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        pushNewScreen(
          context,
          screen: NewsProfil(
            id: id,
          ),
          withNavBar: true, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      title: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 55,
              minHeight: 55,
              maxWidth: 90,
              maxHeight: 80,
            ),
            child: cachedMyImage(image),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: Get.size.width,
                  child: Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontFamily: montserratSemiBold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      const Icon(IconlyLight.calendar, size: 18, color: Colors.black38),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          createdAt,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black38,
                            fontSize: 14,
                            fontFamily: montserratRegular,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const Icon(
            IconlyLight.arrowRightCircle,
            color: Colors.black,
          ),
        ],
      ),
      minLeadingWidth: 120,
      minVerticalPadding: 8,
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
    );
  }
}
