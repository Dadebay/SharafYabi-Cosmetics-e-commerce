// ignore_for_file: file_names

import 'package:comment_tree/comment_tree.dart';
import 'package:flutter/material.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/widgets/appBar.dart';

class CommentsPage extends StatelessWidget {
  const CommentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        icon: Icons.add,
        onTap: () {},
        backArrow: false,
        iconRemove: true,
        name: "Comments",
        addName: true,
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(color: backgroundColor, borderRadius: borderRadius10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("UserName", style: TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 18)),
                    Text("Comment Desxription in here user writed data", style: TextStyle(color: Colors.black87, fontFamily: montserratRegular, fontSize: 16))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 15),
                child: Text("Reply", style: TextStyle(color: Colors.black87, fontFamily: montserratSemiBold, fontSize: 16)),
              )
            ],
          )),
    );
  }
}
