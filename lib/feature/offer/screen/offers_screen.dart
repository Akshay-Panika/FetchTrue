import 'package:flutter/material.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';

import '../model/offer_model.dart';
import '../repository/offer_service.dart';
import 'offers_details_screen.dart';


class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  late Future<List<OfferModel>> _offersFuture;

  @override
  void initState() {
    super.initState();
    _offersFuture = OfferService.fetchOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: CustomAppBar(title: 'Best Offers'),
      body: FutureBuilder<List<OfferModel>>(
        future: _offersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return  Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.remove_shopping_cart,  size: 50,color: CustomColor.iconColor,),
                Text('No offers available.'),
              ],
            ));
          }

          final offers = snapshot.data!;
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
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OffersDetailsScreen(offersFuture: offer,),)),
              );
            },
          );
        },
      ),
    );
  }
}
