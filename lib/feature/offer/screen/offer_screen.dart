import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OfferScreen extends StatelessWidget {
  const OfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(title: 'Best Offer', showNotificationIcon: true,),

      body: SafeArea(
          child: Center(
            child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
            Icon(Icons.remove_shopping_cart, size: 50, color: CustomColor.appColor,),
            20.height,
            Text("No Offer Available", style: textStyle14(context, fontWeight: FontWeight.w400,color: CustomColor.descriptionColor),)
                  ],),
          )),
    );
  }
}
