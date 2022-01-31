// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class FavCardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 150,
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: Colors.white,
              padding: EdgeInsets.zero,
              disabledColor: Colors.white,
              highlightColor: backgroundColor,
              elevation: 0,
              shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
              onPressed: () {},
              child: Row(
                children: [
                  Expanded(
                      child: Shimmer.fromColors(
                          baseColor: Colors.grey.withOpacity(0.2),
                          highlightColor: Colors.grey.withOpacity(0.1),
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              borderRadius: borderRadius5,
                              color: Colors.red,
                            ),
                          ))),
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey.withOpacity(0.2),
                              highlightColor: Colors.grey.withOpacity(0.1),
                              child: Container(
                                color: Colors.white,
                                child: const Text(
                                  "asdsdadsasdasda",
                                  style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: montserratMedium),
                                ),
                              ),
                            ),
                            Shimmer.fromColors(
                              baseColor: Colors.grey.withOpacity(0.2),
                              highlightColor: Colors.grey.withOpacity(0.1),
                              child: Container(
                                color: Colors.white,
                                child: const Text(
                                  "dqawdqwdq",
                                  style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: montserratMedium),
                                ),
                              ),
                            ),
                            Shimmer.fromColors(
                              baseColor: Colors.grey.withOpacity(0.2),
                              highlightColor: Colors.grey.withOpacity(0.1),
                              child: Container(
                                color: Colors.white,
                                child: const Text(
                                  "qwdwdqddwqwdqw",
                                  style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: montserratMedium),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          );
        });
  }
}
