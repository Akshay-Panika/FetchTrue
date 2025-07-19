import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';

class NearByProviderWidget extends StatelessWidget {
  const NearByProviderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  CustomContainer(
      height: 200,
      borderRadius: false,
      margin: EdgeInsets.zero,
      backgroundColor: Colors.teal.shade50,
      child: Container(
        color: Colors.black.withOpacity(0.1),
        child: Center(
          child: Text('Explore Near By provider',
            style: textStyle22(context, color: CustomColor.appColor, fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}
