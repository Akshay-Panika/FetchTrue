import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';

class PaymentDoneScreen extends StatelessWidget {
  const PaymentDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return  CustomContainer(
      height: dimensions.screenHeight*0.7,
       backgroundColor: CustomColor.whiteColor,
      child: Center(child: Text('Payment Done !', style: textStyle22(context, color: CustomColor.appColor),)),);
  }
}
