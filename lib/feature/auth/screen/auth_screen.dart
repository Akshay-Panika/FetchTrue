import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignUp = false;
  void toggleScreen(bool value) {
    setState(() {
      isSignUp = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Welcome !',
        showBackButton: true,bColor: CustomColor.canvasColor,),
      body: isSignUp
          ? SignUpScreen(onToggle: toggleScreen)
          : SignInScreen(onToggle: toggleScreen),

    );
  }
}
