import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return  Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                40.height,
                CustomContainer(
                  width: double.infinity,
                   backgroundColor: CustomColor.whiteColor,
                   margin: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      50.height,
                      Text('Your place the lead successfully', style: textStyle18(context, color: CustomColor.appColor),),
                      Text('Thank you for your order with us', style: textStyle14(context, color: CustomColor.descriptionColor),),

                      10.height,
                      Divider(),
                      10.height,

                      Center(child: Text('Total Payment'),),
                      10.height,

                      Center(child: Text('₹ 00.00', style: textStyle22(context),),),
                      50.height,

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Lead Id', style: textStyle14(context,color: CustomColor.descriptionColor),),
                          Text('${bookingId}', style: textStyle14(context,color: CustomColor.descriptionColor),),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Date & Time', style: textStyle14(context,color: CustomColor.descriptionColor),),
                          Text('________', style: textStyle14(context,color: CustomColor.descriptionColor),),
                        ],
                      ),
                      SizedBox(height: dimensions.screenHeight*0.05,),
                    ],
                  ),
                ),
              ],
            ),

            Positioned(top: 30, child: Icon(Icons.verified, size: 60, color: Colors.green,)),
          ],
        ),
        100.height,
        CustomContainer(
            width: 200,
            backgroundColor: CustomColor.appColor,
            child: Center(child: Text("Back", style: textStyle16(context, color: CustomColor.whiteColor),)),
            onTap: () => Navigator.pop(context)
        )
      ],
    );
  }
}
