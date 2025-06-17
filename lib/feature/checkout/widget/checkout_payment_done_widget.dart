import 'package:flutter/cupertino.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';

class CheckoutPaymentDoneWidget extends StatelessWidget {
  const CheckoutPaymentDoneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return  CustomContainer(
      width: double.infinity,
      height: dimensions.screenHeight*0.7,
       backgroundColor: CustomColor.whiteColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.checkmark_seal_fill, color: CustomColor.greenColor, size: 100,),
          SizedBox(height: dimensions.screenHeight*0.05,),

          Text('Your place the booking successfully', style: textStyle16(context, color: CustomColor.appColor),),
          Text('Booking Id, FTFL01', style: textStyle14(context),),
          SizedBox(height: dimensions.screenHeight*0.05,),

          CustomContainer(
            width: 200,
            backgroundColor: CustomColor.appColor,
            child: Center(child: Text("Back", style: textStyle16(context, color: CustomColor.whiteColor),)),
              onTap: () => Navigator.pop(context)
          )
        ],
      ),
    );
  }
}
