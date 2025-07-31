import 'package:carousel_slider/carousel_slider.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_headline.dart';
import '../../favorite/widget/favorite_provider_button_widget.dart';
import '../bloc/provider/provider_bloc.dart';
import '../bloc/provider/provider_event.dart';
import '../bloc/provider/provider_state.dart';
import '../repository/provider_by_id_service.dart';
import '../repository/provider_service.dart';
import '../screen/provider__details_screen.dart';

class ServiceProviderWidget extends StatefulWidget {
  const ServiceProviderWidget({super.key});

  @override
  State<ServiceProviderWidget> createState() => _ServiceProviderWidgetState();
}

class _ServiceProviderWidgetState extends State<ServiceProviderWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => ProviderBloc(ProviderService())..add(GetProvider()),
      child: BlocBuilder<ProviderBloc, ProviderState>(
        builder: (context, state) {
          if (state is ProviderLoading) {
            return LinearProgressIndicator(
              backgroundColor: CustomColor.appColor,
              color: CustomColor.whiteColor,
              minHeight: 2.5,
            );
          } else if (state is ProviderLoaded) {
            // final provider = state.providerModel;
            final provider = state.providerModel.where((e) => e.kycCompleted == true).toList();


            if (provider.isEmpty) {
              return const Center(child: Text('No provider found.'));
            }

            return Container(
              color: CustomColor.appColor.withOpacity(0.08),
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomHeadline(headline: 'Service Provider'),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 20),
                    child: CarouselSlider.builder(
                      itemCount: provider.length,
                      itemBuilder: (context, index, realIndex) {
                        final data = provider[index];

                        return CustomContainer(
                          width: double.infinity,
                          backgroundColor: Colors.white,
                          margin: EdgeInsets.zero,
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProviderDetailsScreen(
                                providerId: data.id,
                                storeName: data.storeInfo!.storeName,
                              ),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  15.height,
                                  Row(
                                    children: [
                                      Stack(
                                        alignment: AlignmentDirectional.bottomEnd,
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundColor: const Color(0xFFF2F2F2),
                                            backgroundImage: NetworkImage(data.storeInfo!.logo.toString()),
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
                                          Text(
                                            data.storeInfo!.storeName,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            'Module Name',
                                            style: textStyle14(
                                              context,
                                              fontWeight: FontWeight.w400,
                                              color: CustomColor.descriptionColor,
                                            ),
                                          ),
                                          5.height,
                                          Text(
                                            '⭐ ${data.averageRating} (${data.totalReviews} Review)',
                                            style: TextStyle(fontSize: 12, color: Colors.black),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),


                                  Divider(thickness: 0.3,),
                                  // if (_currentIndex == index)
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: List.generate(data.subscribedServices.length, (index) {
                                      final service = data.subscribedServices[index];
                                      return CustomContainer(
                                        border: true,
                                        backgroundColor: CustomColor.whiteColor,
                                        margin: EdgeInsets.zero,
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
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
                              Positioned(
                                top: 0,
                                right: 0,
                                child: FavoriteProviderButtonWidget(
                                  userId: '',
                                  providerId: data.id,
                                  isInitiallyFavorite: true,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 180,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.80,
                        padEnds: true,
                        autoPlayInterval: const Duration(seconds: 5),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ProviderError) {
            return Center(child: Text(state.errorMessage));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
