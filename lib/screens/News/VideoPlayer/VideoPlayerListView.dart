// ignore_for_file: file_names, unnecessary_null_checks

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/models/getVideosModel.dart';
import 'package:sharaf_yabi_ecommerce/screens/News/VideoPlayer/VideoPlayerProfile.dart';

class VideoPlayerListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor.withOpacity(0.1),
      body: FutureBuilder<List<VideoModel>>(
        future: VideoModel().getVideos(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => VideoPLayerMine(
                            videoURL: "$serverImage/${snapshot.data![index].videoPath}",
                          ));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            CachedNetworkImage(
                              fadeInCurve: Curves.ease,
                              imageUrl: "$serverImage/${snapshot.data![index].imagePath}-big.webp",
                              imageBuilder: (context, imageProvider) => Container(
                                padding: EdgeInsets.zero,
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: borderRadius30,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Center(child: spinKit()),
                              errorWidget: (context, url, error) => noImage(),
                            ),
                            Positioned.fill(
                                child: Container(
                              decoration: const BoxDecoration(color: Colors.black54, borderRadius: borderRadius30),
                            )),
                            Center(
                              child: Lottie.asset(
                                "assets/lottie/lf30_editor_5zxz64e7.json",
                                repeat: true,
                                animate: true,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14, bottom: 20),
                          child: Text(
                            "${snapshot.data![index].title}",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: montserratMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: spinKit(),
            );
          }
          return emptyDataLottie(imagePath: "assets/lottie/noNews.json", errorTitle: "noVideoTitle", errorSubtitle: "noVideoSubtitle");
        },
      ),
    );
  }
}
