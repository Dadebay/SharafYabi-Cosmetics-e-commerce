// ignore_for_file: deprecated_member_use, file_names, avoid_types_as_parameter_names, non_constant_identifier_names, must_be_immutable

import 'package:sharaf_yabi_ecommerce/components/ProductProfil.dart';
import 'package:sharaf_yabi_ecommerce/components/ShowAllProductsPage.dart';
import 'package:sharaf_yabi_ecommerce/controllers/BannerController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:sharaf_yabi_ecommerce/screens/HomePage/Components/packages.dart';

class Banners extends StatelessWidget {
  FilterController filterController = Get.put(FilterController());

  final Future<List<BannerModel>>? banners;

  Banners({Key? key, this.banners}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BannerModel>>(
        future: banners,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return bannerCardShimmer();
          } else if (snapshot.hasError) {
            return const SizedBox.shrink();
          } else if (snapshot.data!.isEmpty) {
            return const SizedBox.shrink();
          } else if (snapshot.hasData) {
            return snapshot.data!.isEmpty
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      CarouselSlider.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index, count) {
                          return bannerCard(snapshot, index);
                        },
                        options: CarouselOptions(
                          onPageChanged: (index, CarouselPageChangedReason) {
                            Get.find<BannerController>().bannerSelectedIndex.value = index;
                          },
                          aspectRatio: 16 / 8,
                          viewportFraction: 1.0,
                          autoPlay: true,
                          scrollPhysics: const BouncingScrollPhysics(),
                          autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                          autoPlayAnimationDuration: const Duration(milliseconds: 2000),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                          height: 7,
                          child: Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Obx(() {
                                  return AnimatedContainer(
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    width: Get.find<BannerController>().bannerSelectedIndex.value == index ? 30 : 7,
                                    decoration: BoxDecoration(color: Get.find<BannerController>().bannerSelectedIndex.value == index ? kPrimaryColor : Colors.grey[300], borderRadius: borderRadius15),
                                  );
                                });
                              },
                            ),
                          )),
                    ],
                  );
          }
          return bannerCardShimmer();
        });
  }

  Container bannerCard(AsyncSnapshot<List<BannerModel>> snapshot, int index) {
    return Container(
      width: Get.size.width,
      margin: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
      child: RaisedButton(
        onPressed: () {
          filterController.categoryID.clear();
          filterController.producersID.value = [];

          final int? id = snapshot.data![index].itemID;

          if (snapshot.data![index].pathID == 2) {
            filterController.mainCategoryID.value = id!;
            Get.to(() => const ShowAllProductsPage(
                  pageName: "SharafÝabi",
                  whichFilter: 0,
                ));
          } else if (snapshot.data![index].pathID == 3) {
            Get.to(() => ProductProfil(
                  id: id,
                  image: '',
                  productName: "",
                ));
          }
        },
        shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
        padding: EdgeInsets.zero,
        disabledColor: Colors.red,
        elevation: 1,
        disabledElevation: 1,
        color: Colors.white,
        child: ClipRRect(
          borderRadius: borderRadius10,
          child: CachedNetworkImage(
              fadeInCurve: Curves.ease,
              imageUrl: "$serverImage/${snapshot.data![index].imagePath}-big.webp",
              imageBuilder: (context, imageProvider) => Container(
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
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
        ),
      ),
    );
  }

  Widget bannerCardShimmer() {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        period: const Duration(seconds: 2),
        highlightColor: Colors.grey.withOpacity(0.1),
        child: AspectRatio(
          aspectRatio: 16 / 8,
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: borderRadius10),
          ),
        ));
  }
}
