import 'package:flutter/material.dart';
import 'package:bizbooster2x/core/costants/custom_color.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final IconData? icon;
  final bool obscureText;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.icon,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
        // filled: true,
        // fillColor: Colors.white, // subtle background
        labelText: labelText,
        hintText: hintText ?? 'Enter $labelText',
        hintStyle: TextStyle(fontSize: 14),
        labelStyle: TextStyle(fontSize: 14),
        prefixIcon: icon != null ? Icon(icon, color: CustomColor.appColor) : null,
        // contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: CustomColor.appColor,
            width: 0.5,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: CustomColor.appColor,
            width: 0.5,
          ),
        ),
        border: UnderlineInputBorder(
        ),
      ),
    );
  }
}
