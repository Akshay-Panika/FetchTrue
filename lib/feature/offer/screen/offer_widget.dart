import 'package:fetchtrue/core/costants/custom_log_emoji.dart';
import 'package:fetchtrue/feature/offer/repository/offer_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/widgets/custom_network_mage.dart';
import '../bloc/offer_bloc.dart';
import '../bloc/offer_event.dart';
import '../bloc/offer_state.dart';
import 'offers_details_screen.dart';

class OfferWidget extends StatelessWidget {
  const OfferWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocProvider(
      create: (_) => OfferBloc(OfferRepository())..add(FetchOffersEvent()),
      child: BlocBuilder<OfferBloc, OfferState>(
        builder: (context, state) {
          if (state is OfferLoading) {
            return _buildShimmer(dimensions);
          } else if (state is OfferLoaded) {
            final offers = state.offers;

            if(offers.isEmpty){
              return SizedBox.shrink();
            }

            return SizedBox(
              height: dimensions.screenHeight*0.26,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    children: [
                      Expanded(child: Container(
                        width: double.infinity,
                        color: CustomColor.appColor.withOpacity(0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text('Best Offer For You', style: TextStyle(fontSize: 14, color: CustomColor.blackColor, fontWeight: FontWeight.w500),),
                          ),
                        ],
                      ),)),
                      Expanded(child: Container(color: Colors.transparent,)),
                    ],
                  ),

                  SizedBox(
                    height: dimensions.screenHeight * 0.22,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.all(dimensions.screenHeight * 0.010),
                      itemCount: offers.length,
                      itemBuilder: (context, index) {
                        final offer = offers[index];
                        return CustomNetworkImage(
                          width: dimensions.screenWidth*0.9,
                          imageUrl: offer.thumbnailImage,
                          fit: BoxFit.fill,
                          borderRadius: BorderRadius.circular(10),
                          margin: EdgeInsets.only(
                            bottom: dimensions.screenHeight * 0.010,
                            right: dimensions.screenWidth * 0.02, // spacing between items
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OffersDetailsScreen(
                                offersFuture: offer,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          } else if (state is OfferError) {
            print('${CustomLogEmoji.error} Offer Error: ${state.message}');
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}


Widget _buildShimmer(Dimensions dimensions) {
  return SizedBox(
    height: dimensions.screenHeight * 0.26,
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.green.shade50,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 20,
                    width: dimensions.screenWidth * 0.5,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(child: Container(color: Colors.transparent)),
          ],
        ),
        SizedBox(
          height: dimensions.screenHeight * 0.22,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(dimensions.screenHeight * 0.010),
            itemCount: 2, // number of shimmer items
            itemBuilder: (context, index) {
              return Container(
                width: dimensions.screenWidth * 0.9,
                margin: EdgeInsets.only(
                  bottom: dimensions.screenHeight * 0.010,
                  right: dimensions.screenWidth * 0.02,
                ),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    ),
  );
}
