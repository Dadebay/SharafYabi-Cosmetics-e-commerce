// ignore_for_file: always_use_package_imports

import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sharaf_yabi_ecommerce/controllers/AllContollerBindings.dart';
import 'package:sharaf_yabi_ecommerce/screens/BottomNavBar.dart';

import 'constants/constants.dart';
import 'utils/translations.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await GetStorage.init();

  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.black,
    statusBarColor: kPrimaryColor,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyAppRun());
}

class MyAppRun extends StatefulWidget {
  @override
  State<MyAppRun> createState() => _MyAppRunState();
}

class _MyAppRunState extends State<MyAppRun> {
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AllControllerBindings(),
      locale: storage.read('langCode') != null
          ? Locale(storage.read('langCode'))
          : const Locale(
              'tr',
            ),
      theme: ThemeData(
        primaryColor: Colors.green.shade700,
      ),
      fallbackLocale: const Locale("tr"),
      translations: MyTranslations(),
      defaultTransition: Transition.cupertinoDialog,
      debugShowCheckedModeBanner: false,
      home: BottomNavBar(),
    );
  }
}
