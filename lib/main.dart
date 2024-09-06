//import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lewach/firebase_options.dart';
import 'package:lewach/view/screens/auth_screen.dart';
import 'package:lewach/view/screens/dashboard_screen.dart';
import 'package:lewach/view/screens/home_screen.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    // EasyLocalization(
    // supportedLocales: const [
    //   Locale('en', 'US'),
    //   Locale('am'),
    // ],
    // path: 'assets/translations',
    // fallbackLocale: const Locale('en', 'US'),
    // child:
    const MyApp(),
    //)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveApp(
      builder: (_) => const GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lewach',
        home: AuthPage(),
      ),
    );
  }
}
