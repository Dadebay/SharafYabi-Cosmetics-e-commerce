import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';

class FavButton extends StatefulWidget {
  final int id;
  const FavButton({Key? key, required this.id}) : super(key: key);

  @override
  State<FavButton> createState() => _FavButtonState();
}

class _FavButtonState extends State<FavButton> {
  bool favBool = false;
  @override
  void initState() {
    super.initState();
    whenPageLoad();
  }

  whenPageLoad() {
    bool value = false;
    for (final element in Get.find<Fav_Cart_Controller>().favList) {
      if (element["id"] == widget.id) {
        favBool = true;
        value = true;
      }
    }
    if (value == false) favBool = false;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Get.find<Fav_Cart_Controller>().toggleFav(widget.id);
        favBool = !favBool;
        if (favBool == true)
          showCustomToast(context, "addedfavorite");
        else
          showCustomToast(context, "removedfavorite");
        setState(() {});
      },
      icon: Icon(favBool == true ? IconlyBold.heart : IconlyLight.heart, color: favBool == true ? Colors.red : Colors.grey, size: 28),
    );
  }
}
