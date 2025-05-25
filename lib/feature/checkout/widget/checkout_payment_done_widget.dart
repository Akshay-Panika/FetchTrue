import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';

class CheckoutPaymentDoneWidget extends StatelessWidget {
  const CheckoutPaymentDoneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return  CustomContainer(
      width: double.infinity,
      height: dimensions.screenHeight*0.7,
       backgroundColor: CustomColor.whiteColor,
       child: Icon(CupertinoIcons.checkmark_seal_fill, size: dimensions.screenHeight*0.06,color: CustomColor.appColor,),
    );
  }
}
