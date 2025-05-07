import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final String? assetsImg;
  final String? networkImg;
  final Gradient? gradient;
  final bool border;
  final Color? borderColor;
  final Widget? child;

  const CustomContainer({
    this.onTap,
    this.backgroundColor,
    this.height,
    this.width,
    this.margin,
    this.padding,
    this.assetsImg,
    this.networkImg,
    this.gradient,
    this.border = false,
    this.child, this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        margin: margin ?? EdgeInsets.all(10),
        padding: padding ?? EdgeInsets.all(10),
        decoration: BoxDecoration(
         color:  (gradient == null)  ? backgroundColor ?? Theme.of(context).shadowColor.withOpacity(0.05):null,
          borderRadius: BorderRadius.circular(8.0),

          border: border ? Border.all(color: borderColor ?? Colors.grey,width: 0.02):null,
          gradient: gradient,
          image: (networkImg != null)
              ? DecorationImage(image: NetworkImage(networkImg!), fit: BoxFit.cover)
              : (assetsImg != null)
              ? DecorationImage(image: AssetImage(assetsImg!), fit: BoxFit.cover)
              : null,
        ),
        child: child,
      ),
    );
  }
}