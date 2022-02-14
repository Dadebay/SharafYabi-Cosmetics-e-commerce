// ignore_for_file: file_names, unnecessary_null_checks

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/models/getVideosModel.dart';
import 'package:sharaf_yabi_ecommerce/screens/Category/Components/ShimmerCategory.dart';
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
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) => const Divider(),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return videoCard(
                    title: snapshot.data![index].title!,
                    createdAt: "03-03-2022",
                    imageURL: "$serverImage/${snapshot.data![index].imagePath}-big.webp",
                    videoPath: "$serverImage/${snapshot.data![index].videoPath}",
                  );
                },
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const ShimmerCategory();
          }
          return emptyDataLottie(imagePath: "assets/lottie/noNews.json", errorTitle: "noVideoTitle", errorSubtitle: "noVideoSubtitle");
        },
      ),
    );
  }

  ListTile videoCard({required String title, required String createdAt, String? imageURL, String? videoPath}) {
    return ListTile(
      onTap: () {
        Get.to(() => VideoPLayerMine(
              videoURL: videoPath,
            ));
      },
      title: Row(
        children: [
          imagePart(imageURL!),
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
                    title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontFamily: montserratSemiBold,
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 8),
                //   child: Icon(IconlyLight.calendar, size: 18, color: Colors.black38),

                //   //  Row(
                //   //   children: [
                //   //     const Icon(IconlyLight.calendar, size: 18, color: Colors.black38),
                //   //     Padding(
                //   //       padding: const EdgeInsets.symmetric(horizontal: 10),
                //   //       child: Text(
                //   //         createdAt,
                //   //         maxLines: 1,
                //   //         overflow: TextOverflow.ellipsis,
                //   //         style: const TextStyle(
                //   //           color: Colors.black38,
                //   //           fontSize: 14,
                //   //           fontFamily: montserratRegular,
                //   //         ),
                //   //       ),
                //   //     ),
                //   //   ],
                //   // ),
                // )
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

  ConstrainedBox imagePart(String? image) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 55,
        minHeight: 55,
        maxWidth: 90,
        maxHeight: 80,
      ),
      child: CachedNetworkImage(
        fadeInCurve: Curves.ease,
        imageUrl: image!,
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
