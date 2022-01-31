// ignore_for_file: file_names, always_use_package_imports

import 'package:sharaf_yabi_ecommerce/screens/UserProfil/userPackages.dart';
import 'Auth/LoginPage.dart';

class UserProfil extends StatefulWidget {
  @override
  State<UserProfil> createState() => _UserProfilState();
}

class _UserProfilState extends State<UserProfil> {
  final storage = GetStorage();
  AuthController authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppBar(
          iconRemove: false,
          backArrow: false,
          icon: Icons.ac_unit,
          onTap: () {},
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              myText("profil"),
              buttonProfile(
                name: "orders",
                icon: IconlyLight.document,
                onTap: () {
                  Get.to(() => Orders());
                },
              ),
              const SizedBox(
                height: 10,
              ),
              myText("settings"),
              selectLang(),
              dividerr(),
              buttonProfile(
                name: "favorite",
                icon: IconlyLight.heart,
                onTap: () async {
                  Get.to(() => FavoritePage());
                },
              ),
              dividerr(),
              shareApp(),
              dividerr(),
              buttonProfile(
                name: "clearCache",
                icon: IconlyLight.delete,
                onTap: () async {
                  clearCache();
                },
              ),
              dividerr(),
              buttonProfile(
                name: "aboutUS",
                icon: IconlyLight.infoSquare,
                onTap: () {
                  Get.to(() => AboutUS());
                },
              ),
              dividerr(),
              buttonProfile(
                name: storage.read("AccessToken") != null ? "log_out" : "login",
                icon: storage.read("AccessToken") != null ? IconlyLight.logout : IconlyLight.login,
                onTap: () {
                  authController.loginInAnimation.value = false;
                  authController.signInAnimation.value = false;
                  storage.read("AccessToken") != null ? logOut() : Get.to(() => LoginPage());
                },
              ),
            ],
          ),
        ));
  }
}
