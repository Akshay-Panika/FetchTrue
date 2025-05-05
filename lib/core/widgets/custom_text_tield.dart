import 'package:flutter/material.dart';
import 'package:bizbooster2x/core/costants/custom_color.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;

  CustomTextField({
    required this.controller,
    required this.labelText,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon,),
        labelStyle: TextStyle(
          color: CustomColor.iconColor, // Custom color for the label
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: CustomColor.iconColor, // Custom color for the border when focused
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: CustomColor.iconColor, // Custom color for the border when focused
            width: 0.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: CustomColor.iconColor, // Custom color for the border when focused
            width: 0.5,
          ),
        )
      ),
    );
  }
}
