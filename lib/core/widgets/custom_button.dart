import 'package:flutter/material.dart';

import '../costants/custom_color.dart';


class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? buttonColor;
  final Color? textColor;
  final bool isLoading;
  final double height;
  final double width;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.buttonColor,
    this.textColor,
    this.isLoading = false,
    this.height = 40,
    this.width = double.infinity,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: buttonColor ?? CustomColor.appColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: padding,
        child: isLoading
            ? SizedBox(
          height: 25,
          width: 25,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.3),
        )
            : Text(label, style:  TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: textColor?? CustomColor.whiteColor),),
      ),
    );
  }
}
