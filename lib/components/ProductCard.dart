// ignore_for_file: deprecated_member_use, file_names, avoid_dynamic_calls

import 'package:sharaf_yabi_ecommerce/components/compackages.dart';
import 'package:sharaf_yabi_ecommerce/widgets/addCartButton.dart';

class ProductCard extends StatefulWidget {
  final ProductsModel? product;
  const ProductCard({
    this.product,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool addCart = false;
  bool favButton = false;

  @override
  void initState() {
    super.initState();
    Get.find<Fav_Cart_Controller>().cartList.forEach((element) {
      if (element["id"] == widget.product?.id) {
        addCart = true;
      }
    });
    Get.find<Fav_Cart_Controller>().favList.forEach((element) {
      if (element["id"] == widget.product?.id) {
        favButton = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        final int? a = widget.product!.id;
        Get.to(() => ProductProfil(
              id: a,
              productName: widget.product?.productName,
              image: "$serverImage/${widget.product?.imagePath}-mini.webp",
            ));
      },
      shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
      color: Colors.white,
      disabledColor: Colors.white,
      padding: EdgeInsets.zero,
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          imageExpanded(),
          namePartMine(),
        ],
      ),
    );
  }

  Expanded namePartMine() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${widget.product?.productName}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(fontFamily: montserratMedium, fontSize: 16),
                  ),
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(text: "${widget.product?.price}", style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 18, color: kPrimaryColor)),
                      const TextSpan(text: " TMT", style: TextStyle(fontFamily: montserratMedium, fontSize: 14, color: kPrimaryColor))
                    ]),
                  ),
                ],
              ),
            ),
          ),
          AddCartButton(
            id: widget.product!.id,
          )
        ],
      ),
    );
  }

  Expanded imageExpanded() {
    return Expanded(
      flex: 3,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CachedNetworkImage(
                fadeInCurve: Curves.ease,
                imageUrl: "$serverImage/${widget.product?.imagePath}-mini.webp",
                imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                placeholder: (context, url) => Center(child: spinKit()),
                errorWidget: (context, url, error) => Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        "assets/appLogo/greyLogo.png",
                        color: Colors.grey,
                      ),
                    )),
          ),
          if (widget.product!.discountValue != 0 && widget.product!.discountValue != null)
            Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  decoration: const BoxDecoration(color: Colors.red, borderRadius: borderRadius5),
                  child: Text("- ${widget.product!.discountValue} %", style: const TextStyle(color: Colors.white, fontFamily: montserratRegular, fontSize: 12)),
                ))
          else
            const SizedBox.shrink()
        ],
      ),
    );
  }
}
