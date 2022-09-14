import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'screen_folder/pdf_screen.dart';
import 'file_constant/enum.dart';
import 'screen_folder/detail_screen.dart';
import 'screen_folder/splash_screen.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screen_folder/report_screen.dart';
import '../file_folder/my_note.dart';
import 'screen_folder/home_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
      initialRoute: '/first',
      getPages: [
        GetPage(
          name: '/first',
          page: () => ScreenSplash(),
        ),
        GetPage(
          name: '/home',
          page: () =>HomeScreen(),
        ),
        GetPage(name: '/second', page: () => PdfScreen(), transition: Transition.fadeIn, children: [
          GetPage(name: '/third', page: () => DetailScreen(), transition: Transition.circularReveal),
        ]),
        GetPage(name: '/fourth', page: () => ReportScreen(), transition: Transition.fadeIn),
        GetPage(name: '/fifth', page: () => MyNotesScreen(), transition: Transition.fadeIn),
      ],
    );
  }
}
