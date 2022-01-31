// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCategory extends StatelessWidget {
  const ShimmerCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 15,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 120,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.25)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.withOpacity(0.3),
                highlightColor: Colors.grey.withOpacity(0.1),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: backgroundColor.withOpacity(0.4),
                  ),
                  margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                  width: 85,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey.withOpacity(0.2),
                      highlightColor: Colors.grey.withOpacity(0.1),
                      child: Container(
                        color: Colors.white,
                        margin: const EdgeInsets.only(top: 14, bottom: 10),
                        child: const Text(
                          "asdasdasddas",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: montserratSemiBold,
                          ),
                        ),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.withOpacity(0.2),
                      highlightColor: Colors.grey.withOpacity(0.1),
                      child: Container(
                        color: Colors.white,
                        child: const Text(
                          "das",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: montserratSemiBold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
