import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:flutter/material.dart';


TextStyle textStyle12(BuildContext context,{Color? color, FontWeight? fontWeight}){
  Dimensions demands = Dimensions(context);
  return TextStyle( color: color ?? Colors.black, fontSize: 12*demands.textScaleFactor, fontWeight: fontWeight ?? FontWeight.w500);
}
TextStyle textStyle14(BuildContext context,{Color? color, FontWeight? fontWeight}){
  Dimensions demands = Dimensions(context);
  return TextStyle( color: color ?? Colors.black, fontSize: 14*demands.textScaleFactor, fontWeight: fontWeight ?? FontWeight.w500);
}
TextStyle textStyle16(BuildContext context,{Color? color, FontWeight? fontWeight}){
  Dimensions demands = Dimensions(context);
  return TextStyle( color: color ?? Colors.black, fontSize: 16*demands.textScaleFactor, fontWeight: fontWeight ?? FontWeight.w500);
}
TextStyle textStyle18(BuildContext context,{Color? color, FontWeight? fontWeight}){
  Dimensions demands = Dimensions(context);
  return TextStyle( color: color ?? Colors.black, fontSize: 18*demands.textScaleFactor, fontWeight: fontWeight ?? FontWeight.w500);
}
TextStyle textStyle20(BuildContext context,{Color? color, FontWeight? fontWeight}){
  Dimensions demands = Dimensions(context);
  return TextStyle( color: color ?? Colors.black, fontSize: 20*demands.textScaleFactor, fontWeight: fontWeight ?? FontWeight.w500);
}
TextStyle textStyle22(BuildContext context,{Color? color, FontWeight? fontWeight}){
  Dimensions demands = Dimensions(context);
  return TextStyle( color: color ?? Colors.black, fontSize: 22*demands.textScaleFactor, fontWeight: fontWeight ?? FontWeight.w500);
}

