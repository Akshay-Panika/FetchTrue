import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: textStyle12(context, color: CustomColor.appColor),),
      elevation: 0.0,
      backgroundColor: CustomColor.whiteColor,
      duration: Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(20),
    ),
  );
}