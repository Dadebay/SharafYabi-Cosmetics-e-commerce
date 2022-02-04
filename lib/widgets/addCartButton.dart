// ignore_for_file: file_names

import 'package:lottie/lottie.dart';
import 'package:sharaf_yabi_ecommerce/components/compackages.dart';

class AddCartButton extends StatefulWidget {
  const AddCartButton({Key? key, this.id}) : super(key: key);

  final int? id;

  @override
  State<AddCartButton> createState() => _AddCartButtonState();
}

class _AddCartButtonState extends State<AddCartButton> with TickerProviderStateMixin {
  bool addCart = false;
  bool changeLottie = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          addCart = !addCart;
          if (addCart == true) {
            Get.find<Fav_Cart_Controller>().addCart(widget.id!);
          } else {
            Get.find<Fav_Cart_Controller>().removeCart(
              widget.id!,
            );
          }
        });
      },
      child: addCart
          ? Container(
              margin: const EdgeInsets.only(right: 5),
              width: 35,
              height: 35,
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
              decoration: const BoxDecoration(color: kPrimaryColor, borderRadius: borderRadius10),
              child: Lottie.asset(
                "assets/lottie/cartwhite.json",
                width: 28,
                animate: true,
                repeat: false,
              ))
          : Container(
              margin: const EdgeInsets.only(right: 5),
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(color: kPrimaryColor, borderRadius: borderRadius10),
              child: const Icon(IconlyLight.buy, color: Colors.white)),
    );
  }
}
