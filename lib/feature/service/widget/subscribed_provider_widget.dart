import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';
import '../bloc/service/service_bloc.dart';
import '../bloc/service/service_state.dart';
import '../repository/service_repository.dart';

class SubscribedProviderWidget extends StatefulWidget {
  final String serviceId;
  final Function(String providerId)? onProviderSelected;

  const SubscribedProviderWidget({
    super.key,
    required this.serviceId,
    this.onProviderSelected,
  });

  @override
  State<SubscribedProviderWidget> createState() => _SubscribedProviderWidgetState();
}

class _SubscribedProviderWidgetState extends State<SubscribedProviderWidget> {
  String? selectedProviderId;
  bool fetchTrueSelected = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceBloc, ServiceState>(
      builder: (context, state) {
        if (state is ServiceLoading) {
          return Column(
            children: [
              SizedBox(height: 150),
              Center(child: CircularProgressIndicator()),
            ],
          );
        } else if (state is ServiceLoaded) {
          final services = state.services;
          final matchedServices = services.where((data) => data.id == widget.serviceId).toList();

          if (matchedServices.isEmpty) {
            return const Center(child: Text('No Service found.'));
          }

          final data = matchedServices.first;
          final approvedProviders = data.providerPrices;
          // final approvedProviders = data.providerPrices.where((p) => p.status == "approved").toList();

          // Initial state fix on data load
          if (selectedProviderId == null && !fetchTrueSelected) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                fetchTrueSelected = true;
                selectedProviderId = null;
                if (widget.onProviderSelected != null) {
                  widget.onProviderSelected!('fetch_true');
                }
              });
            });
          }

          return Column(
            children: [
              Center(
                child: buildProviderCard(
                  context,
                  name: 'Fetch True',
                  price: data.price.toString(),
                  newPrice: data.discountedPrice.toString(),
                  discount: data.discount.toString(),
                  commission: data.franchiseDetails.commission.toString(),
                  checkBox: Checkbox(
                    activeColor: CustomColor.greenColor,
                    value: fetchTrueSelected,
                    onChanged: (value) {
                      if (value == true) {
                        setState(() {
                          fetchTrueSelected = true;
                          selectedProviderId = null;
                        });
                        if (widget.onProviderSelected != null) {
                          widget.onProviderSelected!('fetch_true');
                        }
                      }
                    },
                  ),
                ),
              ),

              ListView.builder(
                shrinkWrap: true,
                itemCount: approvedProviders.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final provider = approvedProviders[index];
                  final isSelected = (selectedProviderId != null && provider.id != null && selectedProviderId == provider.id);

                  return Center(
                    child: buildProviderCard(
                      context,
                      name: provider.provider?.fullName ?? '',
                      price: provider.providerPrice?.toString() ?? '',
                      newPrice: provider.providerMRP ?? '',
                      discount: provider.providerDiscount ?? '',
                      commission: provider.providerCommission ?? '',
                      checkBox: Checkbox(
                        activeColor: CustomColor.greenColor,
                        value: isSelected,
                        onChanged: (value) {
                          if (value == true) {
                            setState(() {
                              selectedProviderId = provider.id;
                              fetchTrueSelected = false;
                            });
                            if (widget.onProviderSelected != null) {
                              widget.onProviderSelected!(provider.provider!.id ?? '');
                            }
                          } else {
                            setState(() {
                              selectedProviderId = null;
                              fetchTrueSelected = true;
                            });
                            if (widget.onProviderSelected != null) {
                              widget.onProviderSelected!('fetch_true');
                            }
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        } else if (state is ServiceError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }
}

/// Card
Widget buildProviderCard(
    BuildContext context, {
      String? name,
      ImageProvider<Object>? backgroundImage,
      String? price,
      String? newPrice,
      String? discount,
      String? commission,
      Widget? checkBox,
      String? averageRating,
      String? totalReviews,
      Widget? childRetting,
    }) {
  return Stack(
    children: [
      CustomContainer(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    CircleAvatar(radius: 25,
                      backgroundColor: CustomColor.greyColor.withOpacity(0.2),
                      backgroundImage: backgroundImage ?? AssetImage(CustomImage.nullImage)),
                  ],
                ),
                10.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name ?? '', style: textStyle14(context,)),
                    10.height,
                    Row(
                      children: [
                        CustomContainer(
                            color: CustomColor.appColor.withOpacity(0.5),
                            margin: EdgeInsets.zero,padding: EdgeInsetsGeometry.symmetric(horizontal: 10),child: Text('Open',style: textStyle12(context, color: CustomColor.whiteColor),)),
                        10.width,
                        childRetting ?? Text(
                          '⭐ ${averageRating} (${totalReviews} Review)',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            10.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomAmountText(
                  amount: price ?? '',
                  fontSize: 14,
                  color: Colors.grey,
                  isLineThrough: true,
                ),
                CustomAmountText(
                  amount: newPrice ?? '',
                  fontSize: 14,
                ),
                Text('$discount %', style: textStyle14(context, color: CustomColor.greenColor)),
                Text('Commission $commission', style: textStyle14(context, color: CustomColor.greenColor)),
                10.width,
              ],
            ),
          ],
        ),
      ),
      Positioned(
        top: 10,right: 10,
        child: checkBox ?? const SizedBox.shrink(),
      ),
    ],
  );
}
