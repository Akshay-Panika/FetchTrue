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

void showCustomBottomSheet(BuildContext context) {
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
                              return CustomContainer(
                                margin: EdgeInsets.only(bottom: 10),
                                child:   ListTile(
                                  minLeadingWidth: 0,
                                  contentPadding: EdgeInsets.all(0),
                                  leading: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        CustomImage.nullImage),
                                  ),
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        index == 0
                                            ? 'Let Bizbooster choose for you'
                                            : 'Provider Name',
                                        style: textStyle14(context,
                                            color: CustomColor.appColor),
                                      ),
                                      index == 0 ? SizedBox.shrink():
                                      CustomAmountText(amount: '00.00', fontSize: 14),
                                    ],
                                  ),
                                  trailing:  Checkbox(
                                    activeColor: CustomColor.greenColor,
                                    value: selectedProviderIndex == index,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        selectedProviderIndex = index;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomButton(
                              text: 'Proceed To Checkout',
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutScreen(),
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
