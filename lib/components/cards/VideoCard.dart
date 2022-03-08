// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/screens/News_Videos/VideoPlayerProfile.dart';

class VideoCard extends StatelessWidget {
  final String name;
  final String videoPath;
  final String image;

  const VideoCard({Key? key, required this.name, required this.videoPath, required this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context,
          screen: VideoPLayerMine(
            videoURL: videoPath,
          ),
          withNavBar: true, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              SizedBox(height: 200, width: Get.size.width, child: cachedMyImage(image)),
              Positioned.fill(
                  child: Container(
                decoration: const BoxDecoration(color: Colors.black54, borderRadius: borderRadius15),
              )),
              Center(
                child: Lottie.asset(
                  videoPlayButton,
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
              name,
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
  }
}
