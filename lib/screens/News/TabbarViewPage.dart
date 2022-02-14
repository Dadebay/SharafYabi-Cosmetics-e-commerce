// ignore_for_file: file_names, always_use_package_imports

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/widgets/appBar.dart';

import 'News.dart';
import 'VideoPlayer/VideoPlayerListView.dart';

class TabbarViewPage extends StatelessWidget {
  const TabbarViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backgroundColor.withOpacity(0.1),
        appBar: MyAppBar(icon: Icons.add, onTap: () {}, backArrow: false, iconRemove: false),
        body: Column(
          children: [
            Container(
              color: kPrimaryColor,
              child: TabBar(
                  labelStyle: const TextStyle(fontFamily: montserratSemiBold, fontSize: 18),
                  unselectedLabelStyle: const TextStyle(fontFamily: montserratMedium, fontSize: 18),
                  labelColor: kPrimaryColor,
                  unselectedLabelColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Colors.white,
                  indicator: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                      )),
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
              child: TabBarView(
                children: [
                  News(),
                  VideoPlayerListView(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
