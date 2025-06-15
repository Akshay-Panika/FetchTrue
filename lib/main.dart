import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:flutter/material.dart';
import 'feature/splash_screen/screen/splash_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: CustomColor.canvasColor,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: CustomColor.iconColor),
          actionsIconTheme: IconThemeData(color: CustomColor.iconColor),
          titleTextStyle:  TextStyle(fontSize: 16, color: CustomColor.appColor, fontWeight: FontWeight.w600,),
        ),

      ),
      title: 'BizBooster2x',
      home: SplashScreen(),
    );
  }
}
