import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomHeadline extends StatelessWidget {
  final String? headline;
  final VoidCallback? onTap;
  const CustomHeadline({super.key, this.headline, this.onTap});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(headline??'Headline', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
          InkWell(
              onTap: onTap,
              child: Text('See All', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),)),
        ],
      ),
    );
  }
}
