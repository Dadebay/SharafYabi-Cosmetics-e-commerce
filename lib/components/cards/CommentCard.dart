// ignore_for_file: file_names, must_be_immutable, deprecated_member_use

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/SettingsController.dart';
import 'package:sharaf_yabi_ecommerce/dialogs/diologs.dart';
import 'package:sharaf_yabi_ecommerce/models/CommentModel.dart';
import 'package:sharaf_yabi_ecommerce/models/UserModels/AuthModel.dart';
import 'package:vibration/vibration.dart';

class CommentCard extends StatelessWidget {
  final bool addReplyButton;
  final String userName;
  final String userDescription;
  final int productID;
  final int commentID;
  TextEditingController controller = TextEditingController();
  CommentCard({Key? key, required this.addReplyButton, required this.userName, required this.userDescription, required this.productID, required this.commentID}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: addReplyButton ? const EdgeInsets.symmetric(vertical: 10) : const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(color: Colors.primaries[Random().nextInt(Colors.primaries.length)].withOpacity(0.3), shape: BoxShape.circle),
            child: Text(userName.substring(0, 1).toUpperCase(), style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 22)),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration:
                        const BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(userName, style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 18)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(userDescription, maxLines: 8, style: const TextStyle(color: Colors.black87, fontFamily: montserratRegular, fontSize: 16)),
                        )
                      ],
                    ),
                  ),
                  if (addReplyButton) replyButton() else const SizedBox.shrink()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector replyButton() {
    return GestureDetector(
      onTap: () async {
        final String? token = await Auth().getToken();
        if (token == null) {
          showSnackBar("retry", "pleaseLogin", Colors.red);
        } else {
          customDialog(
            controller: controller,
            hintText: "writeComment",
            maxLength: 70,
            maxLine: 3,
            secondTextField: false,
            title: "writeComment",
            onTap: () {
              Get.find<SettingsController>().dialogsBool.value = !Get.find<SettingsController>().dialogsBool.value;
              CommentModel().writeSubComment(id: productID, comment: controller.text, commentID: commentID).then((value) {
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
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.comment_outlined, color: Colors.black54, size: 18),
            ),
            Text("reply".tr, style: const TextStyle(color: Colors.black54, fontFamily: montserratSemiBold, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
