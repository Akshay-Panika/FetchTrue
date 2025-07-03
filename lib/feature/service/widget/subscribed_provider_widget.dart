import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';

class SubscribedProviderWidget extends StatefulWidget {
  const SubscribedProviderWidget({super.key});

  @override
  State<SubscribedProviderWidget> createState() => _SubscribedProviderWidgetState();
}

class _SubscribedProviderWidgetState extends State<SubscribedProviderWidget> {

  int selectedProviderIndex = 0;

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      itemCount: 3,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Stack(
          children: [
            CustomContainer(
              margin: EdgeInsets.only(bottom: 10),
              child:   Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(
                            CustomImage.nullImage),
                      ),
                      10.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Provider Name',
                              style: textStyle14(context,
                                  color: CustomColor.appColor),
                            ),
                            10.height,

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                CustomAmountText(
                                    amount: '00',
                                    fontSize: 14,
                                    color: Colors.grey,
                                    isLineThrough: true
                                ),


                                CustomAmountText(
                                  amount: '00',
                                  fontSize: 14,
                                ),

                                  Text('00 %', style: textStyle14(context, color: CustomColor.greenColor),),

                                 Text('Commission: ', style: textStyle14(context, color: CustomColor.greenColor),),

                                10.width,
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),

            Align(
              alignment: Alignment.topRight,
              child: Checkbox(
                activeColor: CustomColor.greenColor,
                value: selectedProviderIndex == index,
                onChanged: (bool? value) {
                  setState(() {
                    selectedProviderIndex = index;
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
