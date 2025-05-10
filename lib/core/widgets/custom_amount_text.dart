import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget CustomAmountText({String? amount, Color? color, double? fontSize, FontWeight? fontWeight, bool decoration = true}){
  return Row(
    children: [
       Icon(Icons.currency_rupee, size: fontSize?? 12, color: color?? Colors.black),
      Text(amount!,style: TextStyle(fontSize: fontSize?? 12,color: color?? Colors.black, fontWeight: fontWeight ?? null, decoration: decoration == true? TextDecoration.lineThrough :null),),
    ],
  );
}