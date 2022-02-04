import 'dart:io';
import 'package:sharaf_yabi_ecommerce/controllers/AllContollerBindings.dart';
import 'package:sharaf_yabi_ecommerce/screens/UserProfil/userPackages.dart';
import 'SplashScreen.dart';
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
      fallbackLocale: Locale("tr"),
      translations: MyTranslations(),
      defaultTransition: Transition.cupertinoDialog,
      debugShowCheckedModeBanner: false,
      home: MyCustomSplashScreen(),
    );
  }
}
