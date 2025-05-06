import 'package:bizbooster2x/features/more/screen/more_screen.dart';
import 'package:flutter/material.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isSignUp = false;
  bool isAuthenticated = false;

  void toggleScreen(bool value) {
    setState(() {
      isSignUp = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isAuthenticated
          ? MoreScreen() :isSignUp
          ? SignUpScreen(onToggle: toggleScreen)
          : SignInScreen(onToggle: toggleScreen),

    );
  }
}
