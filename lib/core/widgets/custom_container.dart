import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? height;
  final double? width;
  final Widget? child;

  const CustomContainer({
    this.onTap,
    this.backgroundColor,
    this.height,
    this.width,
    this.child
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).hintColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: child,
      ),
    );
  }
}