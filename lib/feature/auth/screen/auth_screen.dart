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
      body: isSignUp
          ? SignUpScreen(onToggle: toggleScreen)
          : SignInScreen(onToggle: toggleScreen),

    );
  }
}
