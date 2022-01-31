// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCategoryPart2 extends StatelessWidget {
  const ShimmerCategoryPart2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 3 / 3.2),
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(0.3),
          highlightColor: Colors.grey.withOpacity(0.1),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Colors.black, borderRadius: borderRadius10),
          ),
        );
      },
    );
  }
}
