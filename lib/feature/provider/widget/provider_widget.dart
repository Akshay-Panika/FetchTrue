import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../favorite/widget/favorite_provider_button_widget.dart';
import '../bloc/provider/provider_bloc.dart';
import '../bloc/provider/provider_state.dart';
import '../screen/provider__details_screen.dart';

class ProviderWidget extends StatelessWidget {
  final String moduleId;
  const ProviderWidget({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return  BlocBuilder<ProviderBloc, ProviderState>(
      builder: (context, state) {
        if (state is ProviderLoading) {
          return  _buildShimmer(dimensions);
        } else if (state is ProvidersLoaded) {
          final providers = state.providers.where((e) => e.kycCompleted == true && e.storeInfo!.module == moduleId).toList();

          if(providers.isEmpty){
            return SizedBox.shrink();
          }
          return SizedBox(
            height: dimensions.screenHeight*0.3,
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Container(
                      color: CustomColor.appColor.withOpacity(0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          15.height,
                          Center(child: Text('Service Provider',style: textStyle12(context),)),
                          Text('Best service provider by Fetch True,',style: TextStyle(color: Colors.grey.shade500),),
                        ],
                      ),
                    )),
                    Expanded(child: Container(

                    )),
                  ],
                ),
                SizedBox(
                  height:  dimensions.screenHeight*0.22,
                  child: ListView.builder(
                    itemCount: providers.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final provider = providers[index];
                      return Stack(
                        children: [
                          CustomContainer(
                            width: dimensions.screenHeight*0.38,
                            color: Colors.white,
                            margin: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundColor: CustomColor.greyColor.withOpacity(0.2),
                                          backgroundImage: provider.storeInfo!.logo == null ? AssetImage(CustomImage.nullImage) :NetworkImage(provider.storeInfo!.logo.toString()),
                                        ),
                                        CustomContainer(
                                            color: CustomColor.appColor,
                                            margin: EdgeInsets.zero,
                                            padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                                            child: Text('Open', style: textStyle12(context, color: CustomColor.whiteColor),))
                                      ],
                                    ),
                                    10.width,
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(provider.storeInfo!.storeName,style: textStyle14(context),),
                                        Text('Module Name', style: textStyle14(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),),
                                        5.height,
                                        Text(
                                          '⭐ ${provider.averageRating} (${provider.totalReviews} Review)',
                                          style: TextStyle(fontSize: 12, color: Colors.black),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                10.height,
                                Divider(thickness: 0.3),

                                if (provider.subscribedServices.isNotEmpty) ...[
                                  Builder(
                                    builder: (context) {
                                      final seenCategoryIds = <String>{};
                                      final uniqueServices = provider.subscribedServices.where((service) {
                                        final id = service.category?.id;
                                        if (id != null && !seenCategoryIds.contains(id)) {
                                          seenCategoryIds.add(id);
                                          return true;
                                        }
                                        return false;
                                      }).toList();

                                      // sirf 4 items show karna
                                      final limitedServices = uniqueServices.take(5).toList();

                                      final children = limitedServices.map((service) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: Colors.grey.shade500,width: 0.3),
                                          ),
                                          child: Text(
                                            '${service.category?.name ?? 'Unknown'}', style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                          ),
                                        );
                                      }).toList();

                                      // agar 4 se jyada items hai to end me [etc] add karo
                                      if (uniqueServices.length > 5) {
                                        children.add(
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(6),
                                                border: Border.all(color: Colors.grey.shade500,width: 0.3),
                                              ),
                                              child:  Text(
                                                'etc',style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                              ),
                                            ));
                                      }

                                      return Wrap(
                                        spacing: 10,
                                        runSpacing: 10,
                                        children: children,
                                      );
                                    },
                                  )
                                ]


                              ],
                            ),
                            onTap: () {
                              context.push(
                                '/provider/${provider.id}?name=${Uri.encodeComponent(provider.storeInfo!.storeName)}',
                              );
                            },
                          ),

                          Positioned(
                              top: 10,right: 10,
                              child: FavoriteProviderButtonWidget(providerId: provider.id,))
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
        else if (state is ProviderError) {
          print(state.message);
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
        height: dimensions.screenHeight*0.22,
        child: ListView.builder(
          itemCount: 2,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return CustomContainer(
              margin: EdgeInsets.only(left: dimensions.screenHeight*0.010, top: dimensions.screenHeight*0.010, bottom: dimensions.screenHeight*0.010),
              width: dimensions.screenHeight*0.38,
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    5.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(radius: 28),
                            5.height,
                            ShimmerBox(height: 15, width: 80)
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ShimmerBox(height: 10, width: dimensions.screenHeight*0.10),
                            5.height,
                            ShimmerBox(height: 10, width: dimensions.screenHeight*0.1),
                            5.height,
                            ShimmerBox(height: 10, width: dimensions.screenHeight*0.1),
                          ],
                        ),
                      ],
                    ),
                    Divider(),
                    5.height,

                    Wrap(
                       spacing: 20,
                       runSpacing: 10,
                      children: List.generate(4, (index) => ShimmerBox(height: 20, width: dimensions.screenHeight*0.09),)
                    ),
                  ],
                ),
              ),
            );
          },),
      ),
    ],
  );
}