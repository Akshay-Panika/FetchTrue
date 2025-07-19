import 'package:carousel_slider/carousel_slider.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/favorite/model/favorite_provider_model.dart';
import 'package:fetchtrue/feature/favorite/repository/favorite_provider_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_headline.dart';
import '../../favorite/widget/favorite_provider_button_widget.dart';
import '../../ratting_and_reviews/ratting_and_reviews_widget.dart';
import '../bloc/provider/provider_bloc.dart';
import '../bloc/provider/provider_event.dart';
import '../bloc/provider/provider_state.dart';
import '../repository/provider_service.dart';
import '../screen/provider__details_screen.dart';

class ServiceProviderWidget extends StatefulWidget {
  const ServiceProviderWidget({super.key});

  @override
  State<ServiceProviderWidget> createState() => _ServiceProviderWidgetState();
}

class _ServiceProviderWidgetState extends State<ServiceProviderWidget> {

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
            final provider = state.providerModel;

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
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: const Color(0xFFF2F2F2),
                                        backgroundImage: NetworkImage(data.storeInfo!.logo.toString()),
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
                                          RattingAndReviewsWidget(serviceId: data.id,)
                                        ],
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: List.generate(4, (index) {
                                      return CustomContainer(
                                        margin: EdgeInsets.zero,
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                        child: Text(
                                          'type of tag',
                                          style: textStyle12(
                                            context,
                                            fontWeight: FontWeight.w400,
                                            color: CustomColor.descriptionColor,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
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
