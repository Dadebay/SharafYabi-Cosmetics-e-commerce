// ignore_for_file: file_names

import 'package:sharaf_yabi_ecommerce/components/compackages.dart';

class AddCartButton extends StatefulWidget {
  final int? id;

  const AddCartButton({Key? key, this.id}) : super(key: key);

  @override
  State<AddCartButton> createState() => _AddCartButtonState();
}

class _AddCartButtonState extends State<AddCartButton> {
  bool addCart = false;

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
      child: Container(
          margin: const EdgeInsets.only(
            right: 5,
          ),
          child: addCart
              ? Container(padding: const EdgeInsets.all(5), decoration: const BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle), child: const Icon(Icons.done, color: Colors.white))
              : Container(
                  padding: const EdgeInsets.all(5), decoration: const BoxDecoration(color: kPrimaryColor, borderRadius: borderRadius10), child: const Icon(IconlyLight.buy, color: Colors.white))),
    );
  }
}
