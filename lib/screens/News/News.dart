// ignore_for_file: file_names, always_use_package_imports, avoid_dynamic_calls

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/NewsController.dart';
import 'package:sharaf_yabi_ecommerce/screens/Category/Components/ShimmerCategory.dart';
import 'package:sharaf_yabi_ecommerce/widgets/appBar.dart';

import 'NewsProfil.dart';

class News extends StatefulWidget {
  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  final RefreshController _refreshController = RefreshController();

  NewsController newsController = Get.put(NewsController());

  @override
  void initState() {
    super.initState();
    newsController.list.clear();
    newsController.fetchProducts();
  }

  void _onRefresh() {
    newsController.refreshPage();
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    newsController.addPage();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(icon: Icons.add, onTap: () {}, backArrow: false, iconRemove: false),
      body: SmartRefresher(
          enablePullUp: true,
          physics: const BouncingScrollPhysics(),
          header: const MaterialClassicHeader(
            color: kPrimaryColor,
          ),
          footer: loadMore(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: Obx(() {
            if (newsController.loading.value == 1) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: newsController.list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return newCard(index);
                  },
                ),
              );
            } else if (newsController.loading.value == 2) {
              return emptyDataLottie(imagePath: "assets/lottie/noNews.json", errorTitle: "newsEmpty", errorSubtitle: "newsEmptySubtitle");
            } else if (newsController.loading.value == 3) {
              return retryButton(() {
                newsController.fetchProducts();
              });
            } else if (newsController.loading.value == 0) {
              return const ShimmerCategory();
            }
            return const Text("Loading...", style: TextStyle(color: Colors.black, fontFamily: montserratSemiBold));
          })),
    );
  }

  ListTile newCard(int index) {
    return ListTile(
      onTap: () {
        Get.to(() => NewsProfil(
              id: newsController.list[index]["id"],
            ));
      },
      title: Row(
        children: [
          imagePart(index),
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
                    newsController.list[index]["title"],
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
                          newsController.list[index]["createdAt"],
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

  ConstrainedBox imagePart(int index) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 55,
        minHeight: 55,
        maxWidth: 95,
        maxHeight: 90,
      ),
      child: CachedNetworkImage(
        fadeInCurve: Curves.ease,
        imageUrl: "$serverImage/${newsController.list[index]["image"]}-mini.webp",
        imageBuilder: (context, imageProvider) => Container(
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: borderRadius15,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.fill,
            ),
          ),
        ),
        placeholder: (context, url) => Center(child: spinKit()),
        errorWidget: (context, url, error) => noImage(),
      ),
    );
  }
}
