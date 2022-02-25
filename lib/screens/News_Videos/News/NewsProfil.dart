// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/components/appBar.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/models/NewsModel.dart';

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
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 250, child: cachedMyImage("$serverImage/${snapshot.data?.imagePath}-big.webp")),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${snapshot.data!.title}", style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 24)),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 15),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    maxRadius: 25,
                                    minRadius: 24,
                                    backgroundImage: AssetImage(
                                      appLogo2,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Sharafyabi", maxLines: 2, style: TextStyle(color: kPrimaryColor, fontSize: 20, fontFamily: montserratMedium)),
                                    Row(
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text("${snapshot.data!.article}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: montserratRegular,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
            }
            return Center(
              child: spinKit(),
            );
          }),
    );
  }
}
