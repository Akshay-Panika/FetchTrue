import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/formate_price.dart';
import '../../favorite/widget/favorite_service_button_widget.dart';
import '../model/service_model.dart';
import '../screen/service_details_screen.dart';

class ServiceCardWidget extends StatelessWidget {
  final ServiceModel data;
  const ServiceCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    String formatCommission(dynamic rawCommission, {bool half = false}) {
      if (rawCommission == null) return '0';

      final commissionStr = rawCommission.toString();

      // Extract numeric value
      final numericStr = commissionStr.replaceAll(RegExp(r'[^0-9.]'), '');
      final numeric = double.tryParse(numericStr) ?? 0;

      // Extract symbol (₹, %, etc.)
      final symbol = RegExp(r'[^\d.]').firstMatch(commissionStr)?.group(0) ?? '';

      final value = half ? (numeric / 2).round() : numeric.round();

      // Format with symbol
      if (symbol == '%') {
        return '$value%';
      } else {
        return '$symbol$value';
      }
    }

    return CustomContainer(
      border: false,
      color: Colors.white,
      padding: EdgeInsets.zero,
      width: dimensions.screenHeight*0.35,
      margin: EdgeInsets.only(left: dimensions.screenHeight*0.010, top: dimensions.screenHeight*0.010, bottom: dimensions.screenHeight*0.010),
      child: Column(
        children: [
          Expanded(
            child: CustomContainer(
              networkImg: data.thumbnailImage,
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FavoriteServiceButtonWidget(serviceId: data.id,),
                    ),

                    Container(
                      padding:  EdgeInsets.symmetric(vertical: 5, horizontal: dimensions.screenHeight*0.01),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: CustomColor.blackColor.withOpacity(0.3),
                      ),
                      child: Text('⭐ ${data.averageRating} (${data.totalReviews} ${'Reviews'})',
                        style: TextStyle(fontSize: 12, color:CustomColor.whiteColor ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding:  EdgeInsets.all(dimensions.screenHeight*0.010),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.serviceName, style: textStyle12(context),),
                          Row(
                            children: [
                              CustomAmountText(amount: data.price.toString(), color: CustomColor.descriptionColor,isLineThrough: true,fontSize: 14),
                              10.width,
                              CustomAmountText(amount: formatPrice(data.discountedPrice!), color: CustomColor.descriptionColor, fontSize: 14),
                              10.width,
                              Text('${data.discount} % Off', style: textStyle14(context, color: CustomColor.greenColor, fontWeight: FontWeight.w400),),

                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Earn up to ', style: textStyle14(context, color: CustomColor.appColor, fontWeight: FontWeight.w400),),
                        Text(formatCommission(data.franchiseDetails.commission, half: true), style: textStyle14(context, color: CustomColor.greenColor,),),
                        // Text('${data.franchiseDetails.commission}', style: textStyle14(context, color: CustomColor.greenColor,),),
                      ],
                    ),
                  ],
                ),
                5.height,
                if (data.keyValues.isNotEmpty)
                  ...data.keyValues.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${entry.key} :', style: textStyle12(context, color: CustomColor.descriptionColor)),
                        5.width,
                        Expanded(
                          child: Text(
                            entry.value,
                            style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )),
              ],
            ),
          ),
        ],
      ),
      onTap: () => context.push('/service/${data.id}'),
    );
  }
}
