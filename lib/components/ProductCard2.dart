// ignore_for_file: deprecated_member_use, file_names

import 'package:sharaf_yabi_ecommerce/components/compackages.dart';
import 'package:sharaf_yabi_ecommerce/widgets/addCartButton2.dart';

class ProductCard2 extends StatefulWidget {
  final int id;
  final String name;
  final String image;
  final String price;
  final int discountValue;
  final int quantity;

  const ProductCard2({
    Key? key,
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.discountValue,
    required this.quantity,
  }) : super(key: key);
  @override
  _ProductCard2State createState() => _ProductCard2State();
}

class _ProductCard2State extends State<ProductCard2> {
  bool favButton = false;
  bool addCart = false;
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        Get.to(() => ProductProfil(
              id: widget.id,
              productName: widget.name,
              image: "$serverImage/${widget.image}-mini.webp",
            ));
      },
      shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
      color: Colors.white,
      disabledColor: Colors.white,
      padding: EdgeInsets.zero,
      elevation: 1,
      highlightColor: backgroundColor.withOpacity(0.2),
      highlightElevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          imageExpanded(),
          Padding(
            padding: const EdgeInsets.only(left: 7, right: 7, bottom: 3, top: 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontFamily: montserratMedium, fontSize: 16),
                ),
                Text(
                  widget.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontFamily: montserratMedium, fontSize: 14, color: Colors.grey[400]),
                ),
                RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(text: widget.price, style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 20, color: kPrimaryColor)),
                    const TextSpan(text: " TMT", style: TextStyle(fontFamily: montserratMedium, fontSize: 16, color: kPrimaryColor))
                  ]),
                ),
                AddCartButton2(
                  id: widget.id,
                  quantity: widget.quantity,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded imageExpanded() {
    return Expanded(
      flex: 2,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
              fadeInCurve: Curves.ease,
              imageUrl: "$serverImage/${widget.image}-mini.webp",
              imageBuilder: (context, imageProvider) => Container(
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(5), topLeft: Radius.circular(5)),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
              placeholder: (context, url) => Center(child: spinKit()),
              errorWidget: (context, url, error) => Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Image.asset(
                      "assets/appLogo/greyLogo.png",
                      color: Colors.grey,
                    ),
                  )),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  favButton = !favButton;
                  Get.find<Fav_Cart_Controller>().toggleFav(widget.id);
                });
              },
              child: PhysicalModel(
                elevation: 2,
                color: Colors.transparent,
                shape: BoxShape.circle,
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: Icon(favButton ? IconlyBold.heart : IconlyLight.heart, color: Colors.red)),
              ),
            ),
          ),
          if (widget.discountValue > 0)
            Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  decoration: const BoxDecoration(color: Colors.red, borderRadius: borderRadius5),
                  child: Text("${widget.discountValue} %", style: const TextStyle(color: Colors.white, fontFamily: montserratRegular, fontSize: 14)),
                ))
          else
            const SizedBox.shrink()
        ],
      ),
    );
  }
}
