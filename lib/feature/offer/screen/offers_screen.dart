import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_container.dart';
import '../bloc/offer_bloc.dart';
import '../bloc/offer_state.dart';
import 'offers_details_screen.dart';

class OfferScreen extends StatelessWidget {
  const OfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      appBar: CustomAppBar(title: 'Offers',),
      body: BlocBuilder<OfferBloc, OfferState>(
        builder: (context, state) {
          if (state is OfferLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OfferLoaded) {
            final offers = state.offers;
            return ListView.builder(
              padding:  EdgeInsets.all(dimensions.screenHeight*0.010),
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final offer = offers[index];
                return CustomContainer(
                  height: dimensions.screenHeight*0.18,
                  border: true,
                  color: CustomColor.whiteColor,
                  networkImg: offer.thumbnailImage,
                  margin: EdgeInsets.only(bottom: dimensions.screenHeight*0.010),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OffersDetailsScreen(offersFuture: offer,),)),
                );
              },
            );
          } else if (state is OfferError) {
            print('Error: ${state.message}');
            return const Center(child: Text("No data"));
          }
          return const Center(child: Text("No data"));
        },
      ),
    );
  }
}
