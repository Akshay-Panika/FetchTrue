import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/provider/screen/provider__details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_favorite_button.dart';
import '../../ratting_and_reviews/ratting_and_reviews_widget.dart';
import '../bloc/provider/provider_bloc.dart';
import '../bloc/provider/provider_event.dart';
import '../bloc/provider/provider_state.dart';
import '../repository/provider_service.dart';

class ProviderScreen extends StatefulWidget {
  const ProviderScreen({super.key});

  @override
  State<ProviderScreen> createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Provider', showBackButton: true, showSearchIcon: true,),

      body:  BlocProvider(
        create: (_) => ProviderBloc(ProviderService())..add(GetProvider()),
        child:  BlocBuilder<ProviderBloc, ProviderState>(
          builder: (context, state) {
            if (state is ProviderLoading) {
              return LinearProgressIndicator(backgroundColor: CustomColor.appColor, color: CustomColor.whiteColor ,minHeight: 2.5,);
            }

            else if(state is ProviderLoaded){

              final provider = state.providerModel;
              // final provider = state.providerModel.where((moduleService) =>
              // moduleService.id == widget.
              // ).toList();

              if (provider.isEmpty) {
                return const Center(child: Text('No provider found.'));
              }


              return  ListView.builder(
                  itemCount: provider.length,
                  padding: EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                final data = provider[index];


                return CustomContainer(
                  width: double.infinity,
                  backgroundColor: Colors.white,
                  margin: EdgeInsets.only(top: 10),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderDetailsScreen(providerId: data.id, storeName: data.storeInfo!.storeName,),)),
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
                                    backgroundImage: AssetImage(CustomImage.nullImage),
                                  ),
                                  CustomContainer(
                                      backgroundColor: CustomColor.appColor,
                                      margin: EdgeInsets.zero,
                                      padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                                      child: Text('Open', style: textStyle12(context, color: CustomColor.whiteColor),))
                                ],
                              ),
                              10.width,

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data.storeInfo!.storeName,style: textStyle14(context),),
                                  Text('Module Name', style: textStyle14(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),),
                                  5.height,
                                  Text(
                                    '⭐ ${data.averageRating} (${data.totalReviews} Review)',
                                    style: TextStyle(fontSize: 12, color: Colors.black),
                                  )
                                ],
                              )
                            ],
                          ),
                          10.height,

                          if(data.subscribedServices.isNotEmpty)
                          Divider(thickness: 0.3,),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: List.generate(data.subscribedServices.length, (index) {
                              final service = data.subscribedServices[index];
                              return CustomContainer(
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                child: Text(
                                  service.category!.name ?? 'Unknown', // <-- यहाँ actual tag value दिखेगी
                                  style: textStyle12(
                                    context,
                                    fontWeight: FontWeight.w400,
                                    color: CustomColor.descriptionColor,
                                  ),
                                ),
                              );
                            }),
                          )

                        ],
                      ),
                      const Positioned(
                        top: 0,
                        right: 0,
                        child: CustomFavoriteButton(),
                      ),
                    ],
                  ),
                );
              });

            }

            else if (state is ProviderError) {
              return Center(child: Text(state.errorMessage));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
