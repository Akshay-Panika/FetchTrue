import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/provider/screen/provider__details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../favorite/widget/favorite_provider_button_widget.dart';
import '../bloc/provider/provider_bloc.dart';
import '../bloc/provider/provider_state.dart';

class ProviderScreen extends StatelessWidget {
  const ProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const CustomAppBar(title: 'Provider', showBackButton: true, showSearchIcon: false,),
      body: SafeArea(
        child: BlocBuilder<ProviderBloc, ProviderState>(
          builder: (context, state) {
            if (state is ProviderLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProvidersLoaded) {
              final providers = state.providers.where((e) => e.kycCompleted == true).toList();

              return ListView.builder(
                itemCount: providers.length,
                padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                itemBuilder: (context, index) {
                  final provider = providers[index];
                  return CustomContainer(
                    width: double.infinity,
                    color: Colors.white,
                    margin: EdgeInsets.only(top: 10),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderDetailsScreen(providerId: provider.id, storeName: provider.storeInfo!.storeName,),)),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: CustomColor.greyColor.withOpacity(0.2),
                                      backgroundImage: (provider.storeInfo?.logo != null &&
                                          provider.storeInfo!.logo!.isNotEmpty &&
                                          Uri.tryParse(provider.storeInfo!.logo!)?.hasAbsolutePath == true)
                                          ? NetworkImage(provider.storeInfo!.logo!)
                                          : AssetImage(CustomImage.nullImage) as ImageProvider,
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
                                  final limitedServices = uniqueServices.take(7).toList();

                                  final children = limitedServices.map((service) {
                                    return Text(
                                      '[ ${service.category?.name ?? 'Unknown'} ]',
                                      style: textStyle12(
                                        context,
                                        fontWeight: FontWeight.w400,
                                        color: CustomColor.appColor,
                                      ),
                                    );
                                  }).toList();

                                  // agar 4 se jyada items hai to end me [etc] add karo
                                  if (uniqueServices.length > 7) {
                                    children.add(
                                      Text(
                                        '[etc]',
                                        style: textStyle12(
                                          context,
                                          fontWeight: FontWeight.w400,
                                          color: CustomColor.appColor,
                                        ),
                                      ),
                                    );
                                  }

                                  return Wrap(
                                    spacing: 15,
                                    runSpacing: 10,
                                    children: children,
                                  );
                                },
                              )
                            ]

                            // Divider(thickness: 0.3),
                            //
                            // if (provider.subscribedServices.isNotEmpty) ...[
                            //
                            //   Builder(
                            //     builder: (context) {
                            //       final seenCategoryIds = <String>{};
                            //       final uniqueServices = provider.subscribedServices.where((service) {
                            //         final id = service.category?.id;
                            //         if (id != null && !seenCategoryIds.contains(id)) {
                            //           seenCategoryIds.add(id);
                            //           return true;
                            //         }
                            //         return false;
                            //       }).toList();
                            //
                            //       // sirf 5 hi items show karna
                            //       final limitedServices = uniqueServices.take(4).toList();
                            //
                            //       return Wrap(
                            //         spacing: 15,
                            //         runSpacing: 10,
                            //         children: limitedServices.map((service) {
                            //           return Text('[ ${service.category?.name ?? 'Unknown'} ]',
                            //             style: textStyle12(
                            //               context,
                            //               fontWeight: FontWeight.w400,
                            //               color: CustomColor.appColor,
                            //             ),
                            //           );
                            //         }).toList(),
                            //       );
                            //     },
                            //   )
                            // ]

                          ],
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: FavoriteProviderButtonWidget(providerId: provider.id,)
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            else if (state is ProviderError) {
              print(state.message);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}