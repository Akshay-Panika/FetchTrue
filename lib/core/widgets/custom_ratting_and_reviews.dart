
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRattingAndReviews extends StatelessWidget {
  final Color? color;
  const CustomRattingAndReviews({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Text('⭐ 4.8 (120 Reviews)', style: TextStyle(fontSize: 12, color: color ?? Colors.black));
  }
}
