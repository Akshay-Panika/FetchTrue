import 'dart:async';
import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/feature/dashboard/screen/dashboard_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/dimension.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Icon(Icons.flutter_dash, size: dimensions.screenHeight*0.08, color: CustomColor.appColor),
            10.height,
            SizedBox(
                width: 100,
                child: LinearProgressIndicator(
                  minHeight: 3,
                  color: CustomColor.appColor,)),
          ],
        ),
      ),
    );
  }
}