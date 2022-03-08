// ignore_for_file: file_names, always_use_package_imports

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sharaf_yabi_ecommerce/components/appBar.dart';
import 'package:sharaf_yabi_ecommerce/components/cards/NewsCard.dart';
import 'package:sharaf_yabi_ecommerce/components/cards/VideoCard.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/models/NewsModel.dart';

class TabbarViewPage extends StatelessWidget {
  const TabbarViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double sizeWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppBar(icon: Icons.add, onTap: () {}, backArrow: false, iconRemove: false),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                  labelPadding: sizeWidth > 800 ? const EdgeInsets.symmetric(vertical: 8) : EdgeInsets.zero,
                  labelStyle: TextStyle(fontFamily: montserratMedium, fontSize: sizeWidth > 800 ? 24 : 17),
                  unselectedLabelStyle: TextStyle(fontFamily: montserratRegular, fontSize: sizeWidth > 800 ? 24 : 17),
                  labelColor: kPrimaryColor,
                  unselectedLabelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: kPrimaryColor,
                  tabs: [
                    Tab(
                      text: "news".tr,
                    ),
                    Tab(
                      text: "video".tr,
                    ),
                  ]),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: TabBarView(
                  children: [
                    FutureBuilder<List<NewsModel>>(
                      future: NewsModel().getNews(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.separated(
                            separatorBuilder: (BuildContext context, int index) => const Divider(),
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return NewsCard(
                                id: snapshot.data![index].id!,
                                createdAt: snapshot.data![index].createdAt!,
                                image: "$serverImage/${snapshot.data![index].imagePath!}-mini.webp",
                                name: snapshot.data![index].title!,
                              );
                            },
                          );
                        } else if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: spinKit(),
                          );
                        }
                        return emptyDataLottie(imagePath: noNews, errorTitle: "newsEmpty", errorSubtitle: "newsEmptySubtitle");
                      },
                    ),
                    FutureBuilder<List<VideoModel>>(
                      future: VideoModel().getVideos(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return VideoCard(
                                image: "$serverImage/${snapshot.data![index].imagePath}-big.webp",
                                name: "${snapshot.data![index].title}",
                                videoPath: "$serverImage/${snapshot.data![index].videoPath}",
                              );
                            },
                          );
                        } else if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: spinKit(),
                          );
                        }
                        return emptyDataLottie(imagePath: noNews, errorTitle: "noVideoTitle", errorSubtitle: "noVideoSubtitle");
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
