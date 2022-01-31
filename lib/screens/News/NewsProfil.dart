// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/models/NewsModel.dart';
import 'package:sharaf_yabi_ecommerce/widgets/appBar.dart';

class NewsProfil extends StatelessWidget {
  final int? id;

  const NewsProfil({Key? key, this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(icon: Icons.add, onTap: () {}, backArrow: true, iconRemove: false, addName: true, name: "news"),
      body: FutureBuilder<NewsModel?>(
          future: NewsModel().getNewsProfil(id: id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                      fadeInCurve: Curves.ease,
                      imageUrl: "$serverImage/${snapshot.data?.imagePath}-big.webp",
                      imageBuilder: (context, imageProvider) => Container(
                            padding: EdgeInsets.zero,
                            height: 300,
                            width: Get.size.width,
                            decoration: BoxDecoration(
                              borderRadius: borderRadius10,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${snapshot.data!.title}", style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 24)),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Text("createdAt".tr,
                                  style: const TextStyle(
                                    color: Colors.black45,
                                    fontFamily: montserratRegular,
                                  )),
                              Text(" : ${snapshot.data!.createdAt}",
                                  style: const TextStyle(
                                    color: Colors.black45,
                                    fontFamily: montserratRegular,
                                  )),
                            ],
                          ),
                        ),
                        const Text(
                            // "${snapshot.data!.article}",
                            "askjdboauiOASDHBBFJBARGIJAGJKRGKJARNPKJAGBNPRJGABNPIORJOPGAIJRBGOPABOPRGBAOPRJIHBjdboauiOASDHBBFJBARGIJAGJKRGKJARNPKJAGBNPRJGABNPIORJOPGAIJRBGOPABOPRGBAOPRJIHBGjdboauiOASDHBBFJBARGIJAGJKRGKJARNPKJAGBNPRJGABNPIORJOPGAIJRBGOPABOPRGBAOPRJIHBGjdboauiOASDHBBFJBARGIJAGJKRGKJARNPKJAGBNPRJGABNPIORJOPGAIJRBGOPABOPRGBAOPRJIHBGjdboauiOASDHBBFJBARGIJAGJKRGKJARNPKJAGBNPRJGABNPIORJOPGAIJRBGOPABOPRGBAOPRJIHBGjdboauiOASDHBBFJBARGIJAGJKRGKJARNPKJAGBNPRJGABNPIORJOPGAIJRBGOPABOPRGBAOPRJIHBGjdboauiOASDHBBFJBARGIJAGJKRGKJARNPKJAGBNPRJGABNPIORJOPGAIJRBGOPABOPRGBAOPRJIHBGjdboauiOASDHBBFJBARGIJAGJKRGKJARNPKJAGBNPRJGABNPIORJOPGAIJRBGOPABOPRGBAOPRJIHBGjdboauiOASDHBBFJBARGIJAGJKRGKJARNPKJAGBNPRJGABNPIORJOPGAIJRBGOPABOPRGBAOPRJIHBGG",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: montserratRegular,
                            )),
                      ],
                    ),
                  ),
                ],
              ));
            }
            return Center(
              child: spinKit(),
            );
          }),
    );
  }
}
