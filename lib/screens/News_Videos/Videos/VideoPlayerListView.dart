// ignore_for_file: file_names, unnecessary_null_checks

import 'package:flutter/material.dart';
import 'package:sharaf_yabi_ecommerce/cards/VideoCard.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/models/getVideosModel.dart';

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
                  return VideoCard(
                    image: "$serverImage/${snapshot.data![index].imagePath}-big.webp",
                    name: "${snapshot.data![index].title}",
                    videoPath: "$serverImage/${snapshot.data![index].videoPath}",
                  );
                },
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: spinKit(),
            );
          }
          return emptyDataLottie(imagePath: noNews, errorTitle: "noVideoTitle", errorSubtitle: "noVideoSubtitle");
        },
      ),
    );
  }
}
