import 'package:flutter/cupertino.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';

class CheckoutPaymentDoneWidget extends StatelessWidget {
  final String bookingId;
  const CheckoutPaymentDoneWidget({super.key, required this.bookingId});

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

          Text('Your place the lead successfully', style: textStyle16(context, color: CustomColor.appColor),),
          Text('Lead Id : ${bookingId}', style: textStyle14(context,color: CustomColor.descriptionColor),),
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
