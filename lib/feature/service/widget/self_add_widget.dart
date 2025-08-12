import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/feature/service/widget/subscribed_provider_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_button.dart';
import '../../checkout/screen/checkout_screen.dart';
import '../../provider/bloc/provider/provider_bloc.dart';
import '../../provider/bloc/provider/provider_event.dart';
import '../../provider/bloc/provider/provider_state.dart';
import '../../provider/repository/provider_service.dart';
import '../bloc/module_service/module_service_bloc.dart';
import '../bloc/module_service/module_service_event.dart';
import '../bloc/module_service/module_service_state.dart';
import '../model/service_model.dart';
import '../repository/api_service.dart';

void showCustomBottomSheet(BuildContext context, {required String serviceId}) {
  String? selectedProviderId;
  String selectedType = "default"; // default, outService, inService

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
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

                Expanded(
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

                        MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (_) => ModuleServiceBloc(ApiService())..add(GetModuleService()),
                            ),
                            BlocProvider(
                              create: (_) => ProviderBloc(ProviderService())..add(GetProvider()),
                            ),
                          ],
                          child: BlocBuilder<ModuleServiceBloc, ModuleServiceState>(
                            builder: (context, serviceState) {
                              if (serviceState is ModuleServiceLoading) {
                                return LinearProgressIndicator(backgroundColor: CustomColor.appColor, color: CustomColor.whiteColor ,minHeight: 2.5,);
                              } else if (serviceState is ModuleServiceLoaded) {
                                final service = serviceState.serviceModel.firstWhere(
                                      (s) => s.id == serviceId,
                                  // orElse: () => ServiceModel.empty(), // Avoid crash
                                );

                                if (service.id == null || service.id!.isEmpty) {
                                  return const Center(child: Text('Service not found'));
                                }

                                return BlocBuilder<ProviderBloc, ProviderState>(
                                  builder: (context, providerState) {
                                    if (providerState is ProviderLoading) {
                                      return LinearProgressIndicator(backgroundColor: CustomColor.appColor, color: CustomColor.whiteColor ,minHeight: 2.5,);

                                    } else if (providerState is ProviderLoaded) {
                                      final verifiedProviders = providerState.providerModel
                                          .where((e) => e.kycCompleted == true)
                                          .toList();

                                      final outServiceProvider = verifiedProviders
                                          .where((p) => p.subscribedServices
                                          .any((sub) => sub.id == serviceId))
                                          .toList();

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
                                                      name: 'Fetch true',
                                                      price: service.price.toString(),
                                                      newPrice: service.discountedPrice.toString(),
                                                      discount: service.discount.toString(),
                                                      commission: service.franchiseDetails.commission.toString(),
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
                                                        backgroundImage: NetworkImage(provider.storeInfo!.logo.toString()),
                                                        name: provider.fullName,
                                                        price: service.price.toString(),
                                                        newPrice: service.discountedPrice.toString(),
                                                        discount: service.discount.toString(),
                                                        commission: service.franchiseDetails.commission.toString(),
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
                                                      return buildProviderCard(
                                                        context,
                                                        name: inService.provider?.fullName ?? '',
                                                        price: inService.providerPrice.toString(),
                                                        newPrice: inService.providerMRP.toString(),
                                                        discount: inService.providerDiscount.toString(),
                                                        commission: inService.providerCommission.toString(),
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
                                                      );
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
                                        
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen(
                                                      serviceId: serviceId,
                                                      providerId: selectedProviderId.toString(),
                                                      status: selectedType,
                                                    ))).then((value) => Navigator.pop(context),);
                                                  }
                                        
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else if (providerState is ProviderError) {
                                      return Center(child: Text(providerState.errorMessage));
                                    }
                                    return const SizedBox.shrink();
                                  },
                                );
                              } else if (serviceState is ModuleServiceError) {
                                return Center(child: Text(serviceState.errorMessage));
                              }
                              return const SizedBox.shrink();
                            },
                          ),
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
