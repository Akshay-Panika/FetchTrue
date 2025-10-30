import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/shimmer_box.dart';
import 'package:fetchtrue/feature/service/screen/service_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_network_mage.dart';
import '../../../core/widgets/formate_price.dart';
import '../../favorite/widget/favorite_service_button_widget.dart';
import '../../service/bloc/trending_franchise/franchise_bloc.dart';
import '../../service/bloc/trending_franchise/trending_franchise_event.dart';
import '../../service/bloc/trending_franchise/trending_franchise_state.dart';
import '../../service/model/trending_franchise_model.dart';
import '../../service/repository/trending_franchise_repository.dart';


class TrendingFranchiseServiceWidget extends StatelessWidget {
  const TrendingFranchiseServiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocProvider(
      create: (_) => FranchiseBloc(TrendingFranchiseRepository())..add(FetchFranchises()),
      child: BlocBuilder<FranchiseBloc, FranchiseState>(
        builder: (context, state) {

          if (state is FranchiseLoading) {
            return _buildShimmer(dimensions);
          } else if (state is FranchiseLoaded) {
            if (state.franchises.isEmpty) {
              return SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:  EdgeInsets.only(left: dimensions.screenHeight*0.010, top: dimensions.screenHeight*0.010),
                  child: Text('Trending Franchises', style: textStyle12(context),),
                ),
                SizedBox(
                  height: dimensions.screenHeight*0.25,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.franchises.length,
                    itemBuilder: (context, index) {
                      final TrendingFranchiseModel franchise = state.franchises[index];
                      final data = franchise.serviceId;

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
                              child: CustomNetworkImage(
                                imageUrl: data.thumbnailImage,
                                margin: EdgeInsets.zero,
                                borderRadius: BorderRadius.circular(10),
                                fit: BoxFit.fill,
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
                                            Padding(
                                              padding:  EdgeInsets.only(right: dimensions.screenHeight*0.02),
                                              child: Text(data.serviceName, style: textStyle12(context,),overflow: TextOverflow.ellipsis, maxLines: 1,),
                                            ),
                                            Row(
                                              children: [
                                                CustomAmountText(amount: formatPrice(data.discountedPrice!), color: CustomColor.greenColor, fontSize: 14, fontWeight: FontWeight.w500),
                                                10.width,
                                                CustomAmountText(amount: data.price.toString(), color: Colors.grey[500],isLineThrough: true,fontSize: 14, fontWeight: FontWeight.w500),
                                                10.width,
                                                Text('(${data.discount}% Off)', style: textStyle12(context, color: Colors.red.shade400),),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text('Earn up to ', style: TextStyle(fontSize: 12, color: CustomColor.blackColor, fontWeight: FontWeight.w500),),
                                          Text(formatCommission(data.franchiseDetails.commission, half: true), style: textStyle14(context, color: CustomColor.greenColor,),),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // 5.height,
                                  // if (data.keyValues.isNotEmpty)
                                  //   ...data.keyValues.map((entry) => Padding(
                                  //     padding: const EdgeInsets.only(bottom: 6.0),
                                  //     child: Row(
                                  //       mainAxisAlignment: MainAxisAlignment.start,
                                  //       crossAxisAlignment: CrossAxisAlignment.start,
                                  //       children: [
                                  //         Text('${entry.key} :', style: textStyle12(context, color: CustomColor.descriptionColor)),
                                  //         5.width,
                                  //         Expanded(
                                  //           child: Text(
                                  //             entry.value,
                                  //             style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),
                                  //             overflow: TextOverflow.ellipsis,
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailsScreen(serviceId: data.id, providerId: ''),));
                        },
                        // onTap: () => context.push('/service/${data.id}'),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is FranchiseError) {
            print(state.message);
            return SizedBox.shrink();
          }
          return const SizedBox();
        },
      ),
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