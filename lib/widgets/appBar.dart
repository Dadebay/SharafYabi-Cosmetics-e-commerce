// ignore_for_file: prefer_const_constructors, file_names, use_key_in_widget_constructors, avoid_implementing_value_types

import 'package:sharaf_yabi_ecommerce/components/compackages.dart';

class MyAppBar extends StatelessWidget implements PreferredSize {
  final IconData icon;
  final Function() onTap;
  final bool backArrow;
  final bool iconRemove;
  final String? name;
  final bool? addName;
  const MyAppBar({
    Key? key,
    required this.icon,
    required this.onTap,
    required this.backArrow,
    required this.iconRemove,
    this.name,
    this.addName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: ClipRRect(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
        child: AppBar(
          elevation: 0.0,
          centerTitle: true,
          leading: backArrow
              ? IconButton(
                  icon: Icon(
                    IconlyLight.arrowLeft2,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                )
              : SizedBox.shrink(),
          actions: [
            if (iconRemove == false)
              SizedBox.shrink()
            else
              GestureDetector(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Icon(icon, color: Colors.grey[200], size: 26),
                ),
              )
          ],
          automaticallyImplyLeading: false,
          backgroundColor: kPrimaryColor,
          title: addName ?? false
              ? Text(
                  name!.tr,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontFamily: montserratSemiBold, fontSize: 18),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/appLogo/greyLogo.png", height: 45, width: 45, color: Colors.white),
                    Text(
                      "SHARAFÝABI",
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, letterSpacing: 2.0, fontFamily: montserratBold, fontSize: 18),
                    ),
                    SizedBox(
                      width: iconRemove == false ? 70 : 35,
                    )
                  ],
                ),
        ),
      ),
    );
  }

  @override
  Widget get child => Text("ad");

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
