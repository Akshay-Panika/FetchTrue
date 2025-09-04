import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/shimmer_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/custom_image.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_amount_text.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_favorite_button.dart';
import '../../../../core/widgets/formate_price.dart';
import '../../../service/bloc/service/service_bloc.dart';
import '../../../service/bloc/service/service_state.dart';
import '../../../service/screen/service_details_screen.dart';

class EducationRequirementServiceWidget extends StatelessWidget {
  final String moduleId;
  const EducationRequirementServiceWidget({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
   return  BlocBuilder<ServiceBloc, ServiceState>(
     builder: (context, state) {
       if (state is ServiceLoading) {
         return _buildShimmer(dimensions);
       }

       else if(state is ServiceLoaded){

         // final services = state.services;
         final services = state.services.where((moduleService) =>
         moduleService.category.module == moduleId && moduleService.recommendedServices == true
         ).toList();


         if (services.isEmpty) {
           return SizedBox.shrink();
         }


         return  Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Padding(
               padding:  EdgeInsets.only(left: dimensions.screenHeight*0.010, top: dimensions.screenHeight*0.010),
               child: Text('Recommended Service', style: textStyle12(context),),
             ),
             SizedBox(
               height: dimensions.screenHeight*0.25,
               child: ListView(
                 scrollDirection: Axis.horizontal,
                 children: List.generate(services.length, (index) {
                   final data = services[index];

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
                     onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailsScreen(
                       serviceId: data.id,),
                     )),
                   );
                 },),
               ),
             ),
           ],
         );

       }

       else if (state is ServiceError) {
         // print('Dio Error: ${state.message}');
         return Expanded(child: Center(child: Text('No Service')));
       }
       return const SizedBox.shrink();
     },
   );
  }
}


Widget _buildShimmer(Dimensions dimensions){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding:  EdgeInsets.only(top: 10, left: 10),
        child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: ShimmerBox(height: 10, width: dimensions.screenHeight*0.1)),
      ),
      SizedBox(
        height: dimensions.screenHeight*0.25,
        child: ListView.builder(
          itemCount: 2,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
          return CustomContainer(
            margin: EdgeInsets.only(left: dimensions.screenHeight*0.010, top: dimensions.screenHeight*0.010, bottom: dimensions.screenHeight*0.010),
            width: dimensions.screenHeight*0.35,
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(height: 10, width: dimensions.screenHeight*0.15),
                        5.height,
                        ShimmerBox(height: 10, width: dimensions.screenHeight*0.1),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ShimmerBox(height: 10, width: dimensions.screenHeight*0.09),
                        5.height,
                        ShimmerBox(height: 10, width: dimensions.screenHeight*0.050),
                      ],
                    ),
                  ],
                )
                ],
              ),
            ),
          );
        },),
      ),
    ],
  );
}