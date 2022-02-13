// ignore_for_file: always_declare_return_types, type_annotate_public_apis

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sharaf_yabi_ecommerce/SplashScreen.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/controllers/AllContollerBindings.dart';
import 'package:sharaf_yabi_ecommerce/screens/BottomNavBar.dart';
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
  importance: Importance.high,
);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  await Firebase.initializeApp(
      // options: const FirebaseOptions(
      //   apiKey: 'AIzaSyAGOPaUjBwRsNQbCMndUaqJNC6RHXBQstQ',
      //   appId: '1:1069011072291:android:6e2314726c7a71c94f8896',
      //   messagingSenderId: '1069011072291',
      //   projectId: 'sharafyabi-4293c',
      // ),
      );
      await FirebaseMessaging.instance.requestPermission();

  flutterLocalNotificationsPlugin.show(
    message.data.hashCode,
    message.data['title'],
    message.data['body'],
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        color: Colors.white,
        icon: '@mipmap/ic_launcher',
      ),
    ),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await GetStorage.init();

  await Firebase.initializeApp(
      // options: const FirebaseOptions(
      //   apiKey: 'AIzaSyAGOPaUjBwRsNQbCMndUaqJNC6RHXBQstQ',
      //   appId: '1:1069011072291:android:6e2314726c7a71c94f8896',
      //   messagingSenderId: '1069011072291',
      //   projectId: 'sharafyabi-4293c',
      // ),
      );
      await FirebaseMessaging.instance.requestPermission();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

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
  void initState() {
    super.initState();
    FirebaseMessaging.instance.subscribeToTopic('Events');
    FirebaseMessaging.instance.getToken().then((value){
      print("token");
      print(value);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      flutterLocalNotificationsPlugin.show(
        message.data.hashCode,
        message.data['title'],
        message.data['body'],
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            color: Colors.white,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      Get.to(() => MyCustomSplashScreen());
    });
   
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
      theme: ThemeData(
        primaryColor: Colors.green.shade700,
      ),
      fallbackLocale: const Locale("tr"),
      translations: MyTranslations(),
      defaultTransition: Transition.cupertinoDialog,
      debugShowCheckedModeBanner: false,
      home: MyCustomSplashScreen(),
    );
  }
}
