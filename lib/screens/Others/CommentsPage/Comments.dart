// ignore_for_file: file_names, must_be_immutable, avoid_positional_boolean_parameters, always_use_package_imports, deprecated_member_use, duplicate_ignore

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/components/appBar.dart';
import 'package:sharaf_yabi_ecommerce/components/cards/CommentCard.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/components/dialogs/diologs.dart';
import 'package:sharaf_yabi_ecommerce/controllers/SettingsController.dart';
import 'package:sharaf_yabi_ecommerce/models/CommentModel.dart';
import 'package:sharaf_yabi_ecommerce/models/UserModels/AuthModel.dart';
import 'package:vibration/vibration.dart';

class CommentsPage extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  final int productID;

  CommentsPage({Key? key, required this.productID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        icon: Icons.comment_outlined,
        onTap: () async {},
        backArrow: true,
        iconRemove: false,
        name: "comments",
        addName: true,
      ),
      body: Container(
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: FutureBuilder<CommentModel>(
              future: CommentModel().getComment(id: productID),
              builder: (context, snapshot) {
                if (snapshot.hasData == true) {
                  return snapshot.data!.count == 0
                      ? Stack(
                          children: [noCommentwidget(), addCommentButton()],
                        )
                      : Stack(
                          children: [
                            ListView.builder(
                              itemCount: snapshot.data!.comments!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    CommentCard(
                                        addReplyButton: true,
                                        userName: "${snapshot.data!.comments![index].fullName}",
                                        userDescription: "${snapshot.data!.comments![index].commentMine}",
                                        productID: productID,
                                        commentID: snapshot.data!.comments![index].id!),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 25),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: List.generate(snapshot.data!.comments![index].subComment!.length, (indexx) {
                                          return CommentCard(
                                              addReplyButton: false,
                                              userName: "${snapshot.data!.comments![index].subComment![indexx].fullName}",
                                              userDescription: "${snapshot.data!.comments![index].subComment![indexx].commentMine}",
                                              productID: productID,
                                              commentID: snapshot.data!.comments![index].id!);
                                        }),
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                            addCommentButton(),
                          ],
                        );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: spinKit(),
                  );
                }
                return noCommentwidget();
              })),
    );
  }

  Widget addCommentButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        onTap: () async {
          final String? token = await Auth().getToken();
          if (token == null) {
            showSnackBar("retry", "pleaseLogin", Colors.red);
          } else {
            customDialog(
              controller: controller,
              secondTextFieldController: controller,
              hintText: "writeComment",
              maxLength: 70,
              maxLine: 3,
              secondTextField: false,
              title: "writeComment",
              onTap: () {
                Get.find<SettingsController>().dialogsBool.value = !Get.find<SettingsController>().dialogsBool.value;
                CommentModel().writeComment(id: productID, comment: controller.text).then((value) {
                  if (value == true) {
                    Get.back();
                    showSnackBar("commentAdded", "commentAddedSubtitle", kPrimaryColor);
                    controller.clear();
                  } else {
                    Vibration.vibrate();
                    showSnackBar("retry", "error404", kPrimaryColor);
                    controller.clear();
                  }
                  Get.find<SettingsController>().dialogsBool.value = !Get.find<SettingsController>().dialogsBool.value;
                });
              },
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle),
          padding: EdgeInsets.all(10),
          child: Icon(
            CupertinoIcons.chat_bubble_text,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}
