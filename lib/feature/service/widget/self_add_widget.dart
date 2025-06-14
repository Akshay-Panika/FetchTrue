import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/widgets/custom_amount_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_container.dart';
import '../../checkout/screen/checkout_screen.dart';
import '../model/service_model.dart';

void showCustomBottomSheet(BuildContext context,{required List<ServiceModel> services}) {
  int selectedProviderIndex = 0;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            height: 600,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: CircleAvatar(
                      backgroundColor: CustomColor.whiteColor,
                      child: Icon(Icons.close, color: CustomColor.appColor),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: CustomColor.whiteColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                AssetImage(CustomImage.nullImage),
                              ),
                              10.height,
                              Text('Available Providers',
                                  style: textStyle14(context)),
                              Text('2 Provider available',
                                  style: textStyle12(
                                    context,
                                    fontWeight: FontWeight.w400,
                                    color: CustomColor.appColor,
                                  )),
                            ],
                          ),
                          10.height,
                          ListView.builder(
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
                                                  Text(
                                                    index == 0
                                                        ? 'Fetch True Choose For You'
                                                        : 'Provider Name',
                                                    style: textStyle14(context,
                                                        color: CustomColor.appColor),
                                                  ),
                                                  10.height,
                                              
                                                  index == 0 ?
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                              
                                                      CustomAmountText(
                                                          amount: services.first.price.toString(),
                                                          fontSize: 14,
                                                          color: Colors.grey,
                                                          isLineThrough: true
                                                      ),
                                              
                                              
                                                      CustomAmountText(
                                                        amount: services.first.discountedPrice.toString(),
                                                        fontSize: 14,
                                                      ),
                                              
                                              
                                                      if(services.first.discount != null)
                                                        Text('${services.first.discount} %', style: textStyle14(context, color: CustomColor.greenColor),),
                                              
                                              
                                                      if(services.first.discount != null)
                                                        Text('Commission: ${services.first.franchiseDetails.commission}', style: textStyle14(context, color: CustomColor.greenColor),),

                                                      10.width,
                                                    ],
                                                  ):
                                                  CustomAmountText(amount: '00', fontSize: 14),
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
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomButton(
                              label: 'Proceed To Checkout',
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutScreen(services: services,),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
