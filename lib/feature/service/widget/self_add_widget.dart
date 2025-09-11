import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/custom_logo.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/formate_price.dart';
import 'package:fetchtrue/feature/service/widget/subscribed_provider_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_button.dart';
import '../../checkout/screen/checkout_screen.dart';
import '../../provider/bloc/provider/provider_bloc.dart';
import '../../provider/bloc/provider/provider_state.dart';
import '../../provider/bloc/provider_review/provider_review_bloc.dart';
import '../../provider/bloc/provider_review/provider_review_event.dart';
import '../../provider/bloc/provider_review/provider_review_state.dart';
import '../../provider/repository/provider_review_repository.dart';
import '../bloc/service/service_bloc.dart';
import '../bloc/service/service_state.dart';


void showCustomBottomSheet(BuildContext context, {required String serviceId}) {
  String? selectedProviderId;
  String selectedType = "default"; // default, outService, inService

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {

      Dimensions dimensions = Dimensions(context);

      return StatefulBuilder(
        builder: (context, setState) {
          return IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                /// Close button
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: CircleAvatar(
                      backgroundColor: CustomColor.whiteColor,
                      child: Icon(Icons.close, color: CustomColor.appColor),
                    ),
                  ),
                ),

                Flexible(
                  child: CustomContainer(
                    color: CustomColor.whiteColor,
                    width: double.infinity,
                    margin: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text('Provider available',
                            style: textStyle16(context, color: CustomColor.appColor)),
                        const SizedBox(height: 10),

                        BlocBuilder<ServiceBloc, ServiceState>(
                          builder: (context, serviceState) {
                            if (serviceState is ServiceLoading) {
                              return LinearProgressIndicator(backgroundColor: CustomColor.appColor, color: CustomColor.whiteColor ,minHeight: 2.5,);
                            } else if (serviceState is ServiceLoaded) {

                              final service = serviceState.services.firstWhere((s) => s.id == serviceId,
                                // orElse: () => ServiceModel.empty(), // Avoid crash
                              );

                              if (service.id == null || service.id!.isEmpty) {
                                return const Center(child: Text('Service not found'));
                              }

                              return BlocBuilder<ProviderBloc, ProviderState>(
                                bloc: BlocProvider.of<ProviderBloc>(context),
                                builder: (context, state) {
                                  if (state is ProviderLoading) {
                                    return LinearProgressIndicator(backgroundColor: CustomColor.appColor, color: CustomColor.whiteColor ,minHeight: 2.5,);
                                  } else if (state is ProvidersLoaded) {

                                    final verifiedProviders = state.providers.where((e) => e.kycCompleted == true).toList();
                                    final inServiceProviderIds = service.providerPrices.map((inService) => inService.provider?.id).where((id) => id != null).toSet();
                                    final outServiceProvider = verifiedProviders.where((p) => p.subscribedServices.any((sub) => sub.id == serviceId) && !inServiceProviderIds.contains(p.id)).toList();



                                    String formatCommission(dynamic rawCommission, {bool half = false}) {
                                      if (rawCommission == null) return '0';

                                      final commissionStr = rawCommission.toString();

                                      // Extract numeric value
                                      final numericStr = commissionStr.replaceAll(RegExp(r'[^0-9.]'), '');
                                      final numeric = double.tryParse(numericStr) ?? 0;

                                      // Extract symbol (₹, %, etc.)
                                      final symbol = RegExp(r'[^\d.]').firstMatch(commissionStr)?.group(0) ?? '';

                                      final value = half ? (numeric / 2).round() : numeric.round();

                                      // Format with symbol
                                      if (symbol == '%') {
                                        return '$value%';
                                      } else {
                                        return '$symbol$value';
                                      }
                                    }

                                    return Expanded(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [

                                                  /// Default Provider
                                                  buildProviderCard(
                                                    context,
                                                    backgroundImage: AssetImage(CustomLogo.fetchTrueLogo),
                                                    name: 'Fetch true',
                                                    price: service.price.toString(),
                                                    newPrice: formatPrice(service.discountedPrice!),
                                                    discount: service.discount.toString(),
                                                    commission: formatCommission(service.franchiseDetails.commission, half: true),
                                                    // commission: service.franchiseDetails.commission.toString(),
                                                    childRetting: Text('⭐ ${service.averageRating} (${service.totalReviews} Review)', style: TextStyle(fontSize: 12, color: Colors.black)),
                                                    checkBox: Checkbox(
                                                      activeColor: CustomColor.greenColor,
                                                      value: selectedType == "default",
                                                      onChanged: (_) {
                                                        setState(() {
                                                          selectedType = "default";
                                                          selectedProviderId = null;
                                                        });
                                                      },
                                                    ),
                                                  ),

                                                  /// Out Service Providers
                                                  ...outServiceProvider.map((provider) {
                                                    return buildProviderCard(
                                                      context,
                                                      backgroundImage: provider.storeInfo!.logo != null
                                                          ? NetworkImage(provider.storeInfo!.logo.toString())
                                                          : AssetImage(CustomImage.nullImage) as ImageProvider,
                                                      name: provider.storeInfo!.storeName.toString(),
                                                      price: service.price.toString(),
                                                      newPrice: formatPrice(service.discountedPrice!),
                                                      discount: service.discount.toString(),
                                                      commission: formatCommission(service.franchiseDetails.commission, half: true),
                                                      // commission: service.franchiseDetails.commission.toString(),
                                                      averageRating: provider.averageRating.toString(),
                                                      totalReviews: provider.totalReviews.toString(),
                                                      checkBox: Checkbox(
                                                        activeColor: CustomColor.greenColor,
                                                        value: selectedType == "outService" &&
                                                            selectedProviderId == provider.id,
                                                        onChanged: (_) {
                                                          setState(() {
                                                            selectedType = "outService";
                                                            selectedProviderId = provider.id;
                                                          });
                                                        },
                                                      ),
                                                    );
                                                  }).toList(),

                                                  /// In Service Providers
                                                  ...service.providerPrices.map((inService) {
                                                    return (inService.provider?.id != null) ?
                                                      buildProviderCard(
                                                      context,
                                                      backgroundImage: inService.provider?.storeInfo?.logo != null
                                                          ? NetworkImage(inService.provider!.storeInfo!.logo)
                                                          : AssetImage(CustomImage.nullImage) as ImageProvider,
                                                      name: inService.provider?.storeInfo?.storeName ?? "Unknown Provider",
                                                      price: inService.providerMRP?.toString() ?? "0",
                                                      newPrice: inService.providerPrice?.toStringAsFixed(0) ?? "-",
                                                      discount: inService.providerDiscount?.toString() ?? "0",
                                                      commission: formatCommission(
                                                        inService.providerCommission?.toString(),
                                                        half: true,
                                                      ),

                                                      childRetting: (inService.provider?.id != null)
                                                          ? BlocProvider(
                                                        create: (_) => ProviderReviewBloc(ProviderReviewRepository())
                                                          ..add(FetchProviderReviews(inService.provider!.id)),
                                                        child: BlocBuilder<ProviderReviewBloc, ProviderReviewState>(
                                                          builder: (context, state) {
                                                            if (state is ProviderReviewLoading) {
                                                              return  SizedBox(
                                                                height: 15,
                                                                width: 15,
                                                                child: Center(
                                                                  child: CircularProgressIndicator(
                                                                    color: CustomColor.appColor,
                                                                    strokeWidth: 0.5,
                                                                  ),
                                                                ),
                                                              );
                                                            } else if (state is ProviderReviewLoaded) {
                                                              final rating = state.reviews;
                                                              return Text(
                                                                '⭐ ${rating.averageRating} (${rating.totalReviews} Review)',
                                                                style: const TextStyle(fontSize: 12, color: Colors.black),
                                                              );
                                                            } else if (state is ProviderReviewError) {
                                                              debugPrint(state.message);
                                                              return SizedBox.shrink();
                                                            }
                                                            return   Text('(No reviews yet)',style: TextStyle(fontSize: 12, color: Colors.grey),);
                                                          },
                                                        ),
                                                      )
                                                          :   Text('(No reviews yet)',style: TextStyle(fontSize: 12, color: Colors.grey),),

                                                      checkBox: Checkbox(
                                                        activeColor: CustomColor.greenColor,
                                                        value: selectedType == "inService" &&
                                                            selectedProviderId == inService.provider?.id,
                                                        onChanged: (_) {
                                                          setState(() {
                                                            selectedType = "inService";
                                                            selectedProviderId = inService.provider?.id;
                                                          });
                                                        },
                                                      ),
                                                    ) : SizedBox.shrink();
                                                  }).toList(),

                                                ],
                                              ),
                                            ),
                                          ),
                                          /// Proceed Button
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                            child: CustomButton(
                                                label: 'Proceed To Checkout',
                                                onPressed: () {
                                                  if (selectedType == "default") {
                                                    print("Type: $selectedType | serviceId: $serviceId");
                                                  } else {
                                                    print("Type: $selectedType | serviceId: $serviceId | providerId: $selectedProviderId");
                                                  }

                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => CheckoutScreen(
                                                        serviceId: serviceId,
                                                        providerId: selectedProviderId ?? "",
                                                        status: selectedType,
                                                      ),
                                                    ),
                                                  );

                                                }

                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  else if (state is ProviderError) {
                                    return Center(child: Text(state.message));
                                  }
                                  return Container();
                                },
                              );

                            } else if (serviceState is ServiceError) {
                              return Center(child: Text(serviceState.message));
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
