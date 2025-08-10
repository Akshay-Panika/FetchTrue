import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/service/widget/subscribed_provider_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_button.dart';
import '../../checkout/screen/checkout_screen.dart';
import '../model/service_model.dart';

void showCustomBottomSheet(BuildContext context,{required List<ServiceModel> services}) {
  String provider = '';

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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                20.height,
                                Text('Provider available', style: textStyle16(context, color: CustomColor.appColor,)),
                                10.height,
                            
                                /// Provider
                                SubscribedProviderWidget(
                                  serviceId: services.first.id,
                                  serviceName: services.first.serviceName,
                                  price: services.first.price.toString(),
                                  discountedPrice: services.first.discountedPrice.toString(),
                                  commission: services.first.franchiseDetails.commission,
                                  onProviderSelected: (id) {
                                    setState(() {
                                      provider = id;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),


                          /// Proceed To Check Out
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0,right: 10, bottom: 30),
                            child: Column(
                              children: [
                                CustomButton(
                                  label: 'Proceed To Checkout',
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CheckoutScreen(
                                          services: services,
                                          providerId: provider,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
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
