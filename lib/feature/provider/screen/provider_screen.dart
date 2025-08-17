import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/provider/screen/provider__details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../bloc/provider/provider_bloc.dart';
import '../bloc/provider/provider_state.dart';

class ProviderScreen extends StatefulWidget {
  const ProviderScreen({super.key});

  @override
  State<ProviderScreen> createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const CustomAppBar(title: 'Provider', showBackButton: true, showSearchIcon: false,),
      body: BlocBuilder<ProviderBloc, ProviderState>(
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
                                    backgroundImage: NetworkImage(provider.storeInfo!.logo.toString()),
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

                          if (provider.subscribedServices.isNotEmpty) ...[
                            Divider(thickness: 0.3),

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

                                return Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: uniqueServices.map((service) {
                                    return CustomContainer(
                                      margin: EdgeInsets.zero,
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                      child: Text(
                                        service.category?.name ?? 'Unknown',
                                        style: textStyle12(
                                          context,
                                          fontWeight: FontWeight.w400,
                                          color: CustomColor.descriptionColor,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            )
                          ],


                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Icon(Icons.favorite_border, color: Colors.grey),
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
    );
  }
}