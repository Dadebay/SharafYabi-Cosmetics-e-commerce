// ignore_for_file: file_names, always_use_package_imports, avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sharaf_yabi_ecommerce/cards/NewsCard.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/shimmers.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/NewsController.dart';

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
    newsController.page.value = 0;
    newsController.pageNumberNews.value = 0;
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
        backgroundColor: backgroundColor.withOpacity(0.1),
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
                    physics: const BouncingScrollPhysics(),
                    itemCount: newsController.list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return NewsCard(
                        id: newsController.list[index]["id"] ?? 0,
                        createdAt: newsController.list[index]["createdAt"] ?? "0",
                        image: "$serverImage/${newsController.list[index]["image"]}-mini.webp",
                        name: newsController.list[index]["name"] ?? "Sharafyabi",
                      );
                    },
                  ),
                );
              } else if (newsController.loading.value == 2) {
                return emptyDataLottie(imagePath: noNews, errorTitle: "newsEmpty", errorSubtitle: "newsEmptySubtitle");
              } else if (newsController.loading.value == 3) {
                return retryButton(() {
                  newsController.fetchProducts();
                });
              } else if (newsController.loading.value == 0) {
                return shimmerCategory();
              }
              return const Text("Loading...", style: TextStyle(color: Colors.black, fontFamily: montserratSemiBold));
            })));
  }
}
