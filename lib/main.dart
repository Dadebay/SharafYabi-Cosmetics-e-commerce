// ignore_for_file: always_declare_return_types, type_annotate_public_apis

import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:new_version/new_version.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/controllers/AllContollerBindings.dart';
import 'package:sharaf_yabi_ecommerce/screens/Others/ProductProfilPage/ProductProfil.dart';
import 'package:sharaf_yabi_ecommerce/screens/Others/SpashScreen/SplashScreen.dart';
import 'package:sharaf_yabi_ecommerce/screens/UserProfil/UserProfilPage.dart';
import 'package:sharaf_yabi_ecommerce/utils/translations.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("assssssssssssssss");
  flutterLocalNotificationsPlugin.show(
    message.data.hashCode,
    message.data['body'],
    message.data['title'],
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        color: Colors.white,
        styleInformation: const BigTextStyleInformation(''),
        icon: '@mipmap/ic_launcher',
      ),
    ),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await GetStorage.init();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: null,
    macOS: null,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? a) {
    print(a);
  });

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

Future selectNotification(String? payload) async {
  debugPrint('notification payload: $payload');

  if (payload != null) {
    debugPrint('notification payload: $payload');
  }
  print(payload);
}

class MyAppRun extends StatefulWidget {
  @override
  State<MyAppRun> createState() => _MyAppRunState();
}

class _MyAppRunState extends State<MyAppRun> {
  final storage = GetStorage();
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  _checkVersionUpdate() async {
    final newVersion = NewVersion(
      iOSId: 'com.bilermennesil.sharafyabi',
      androidId: 'com.bilermennesil.sharafyabi',
    );

    final status = await newVersion.getVersionStatus();
    print(status!.localVersion);
    print(status.storeVersion);
    newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dismissButtonText: "no".tr,
        dialogTitle: "newVersion".tr,
        dialogText: "newVersionTitle".tr,
        dismissAction: () {
          Navigator.pop(context);
        },
        updateButtonText: "yes".tr);
  }

  firebaseMessagingPart() {
    FirebaseMessaging.instance.subscribeToTopic('Events');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.data);
      print(message.data['item_id']);
      print(message.data['path_id']);
      flutterLocalNotificationsPlugin.show(
        message.data.hashCode,
        message.data['body'],
        message.data['title'],
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            styleInformation: const BigTextStyleInformation(''),
            color: Colors.white,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['path_id'] == 3) {
        pushNewScreen(
          context,
          screen: ProductProfil(
            id: message.data['item_id'],
            image: "$serverImage/${message.data['destination']}-big.webp",
          ),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.fade,
        );
      } else if (message.data['path_id'] == 2) {
        pushNewScreen(
          context,
          screen: UserProfil(),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.fade,
        );
      } else {
        pushNewScreen(
          context,
          screen: MyCustomSplashScreen(),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.fade,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _checkVersionUpdate();
    firebaseMessagingPart();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AllControllerBindings(),
      locale: storage.read('langCode') != null
          ? Locale(storage.read('langCode'))
          : const Locale(
              'tr',
            ),
      theme: ThemeData(primaryColor: Colors.green.shade700, fontFamily: montserratRegular),
      fallbackLocale: const Locale("tr"),
      navigatorObservers: <NavigatorObserver>[observer],
      translations: MyTranslations(),
      defaultTransition: Transition.cupertinoDialog,
      debugShowCheckedModeBanner: false,
      home: MyCustomSplashScreen(),
    );
  }
}
