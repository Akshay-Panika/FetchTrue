import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget CustomAmountText({String? amount, Color? color, double? fontSize}){
  return Row(
    children: [
       Icon(Icons.currency_rupee, size: fontSize?? 12, color: color?? Colors.black),
      Text(amount!,style: TextStyle(fontSize: fontSize?? 12,color: color?? Colors.black),),
    ],
  );
}