import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_container.dart';
import '../bloc/offer_bloc.dart';
import '../bloc/offer_event.dart';
import '../bloc/offer_state.dart';
import 'offers_details_screen.dart';

class OfferScreen extends StatelessWidget {
  const OfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Offers',),
      body: BlocBuilder<OfferBloc, OfferState>(
        builder: (context, state) {
          if (state is OfferLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OfferLoaded) {
            final offers = state.offers;
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final offer = offers[index];
                return CustomContainer(
                  height: 200,
                  border: true,
                  color: CustomColor.whiteColor,
                  networkImg: offer.thumbnailImage,
                  margin: EdgeInsets.only(top: 10),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OffersDetailsScreen(offersFuture: offer,),)),
                );
              },
            );
          } else if (state is OfferError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const Center(child: Text("No data"));
        },
      ),
    );
  }
}
