// ignore_for_file: file_names, always_use_package_imports, avoid_dynamic_calls

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sharaf_yabi_ecommerce/components/compackages.dart';
import 'package:sharaf_yabi_ecommerce/controllers/NewsController.dart';
import 'package:sharaf_yabi_ecommerce/widgets/appBar.dart';

import 'NewsProfil.dart';

class News extends StatefulWidget {
  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  final RefreshController _refreshController = RefreshController();

  NewsController newsController = Get.put(NewsController());

  @override
  void initState() {
    super.initState();
    newsController.list.clear();
    newsController.fetchProducts();
  }

  void _onRefresh() {
    newsController.refreshPage();
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    newsController.addPage();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(icon: Icons.add, onTap: () {}, backArrow: false, iconRemove: false),
      body: SmartRefresher(
          enablePullUp: true,
          physics: const BouncingScrollPhysics(),
          header: const MaterialClassicHeader(
            color: kPrimaryColor,
          ),
          footer: loadMore(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: Obx(() {
            if (newsController.loading.value == 1) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: newsController.list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        Get.to(() => NewsProfil(
                              id: newsController.list[index]["id"],
                            ));
                      },
                      title: Row(
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 44,
                              minHeight: 44,
                              maxWidth: 90,
                              maxHeight: 80,
                            ),
                            child: CachedNetworkImage(
                                fadeInCurve: Curves.ease,
                                imageUrl: "$serverImage/${newsController.list[index]["image"]}-mini.webp",
                                imageBuilder: (context, imageProvider) => Container(
                                      padding: EdgeInsets.zero,
                                      decoration: BoxDecoration(
                                        borderRadius: borderRadius15,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                placeholder: (context, url) => Center(child: spinKit()),
                                errorWidget: (context, url, error) => Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: borderRadius15),
                                      child: Image.asset(
                                        "assets/appLogo/greyLogo.png",
                                        color: Colors.grey,
                                      ),
                                    )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: Get.size.width,
                                  child: Text(
                                    newsController.list[index]["title"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontFamily: montserratSemiBold,
                                    ),
                                  ),
                                ),
                                Text(
                                  newsController.list[index]["article"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontFamily: montserratRegular,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            IconlyLight.arrowRightCircle,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      minLeadingWidth: 120,
                      minVerticalPadding: 0,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                    );
                  },
                ),
              );
            } else if (newsController.loading.value == 2) {
              return emptyData(imagePath: "assets/icons/svgIcons/EmptyPageIcon.png", errorTitle: "news yok", errorSubtitle: "hic hili new yok");
            } else if (newsController.loading.value == 3) {
              return retryButton(() {
                newsController.fetchProducts();
              });
            } else if (newsController.loading.value == 0) {
              return Center(
                child: spinKit(),
              );
            }
            return const Text("Loading...", style: TextStyle(color: Colors.black, fontFamily: montserratSemiBold));
          })),
    );
  }
}
