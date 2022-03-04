// ignore_for_file: file_names, always_use_package_imports

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sharaf_yabi_ecommerce/components/appBar.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/screens/News_Videos/News/News.dart';

import 'Videos/VideoPlayerListView.dart';

class TabbarViewPage extends StatelessWidget {
  const TabbarViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double sizeWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backgroundColor,
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
