import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';
import '../../provider/bloc/provider/provider_bloc.dart';
import '../../provider/bloc/provider/provider_event.dart';
import '../../provider/bloc/provider/provider_state.dart';
import '../../provider/repository/provider_service.dart';

class SubscribedProviderWidget extends StatefulWidget {
  final String serviceId;
  final String serviceName;
  final String price;
  final String discountedPrice;
  final String commission;
  final Function(String providerName)? onProviderSelected;

  const SubscribedProviderWidget({
    super.key,
    required this.serviceId,
    required this.serviceName,
    required this.price,
    required this.discountedPrice,
    required this.commission,
    this.onProviderSelected,
  });

  @override
  State<SubscribedProviderWidget> createState() => _SubscribedProviderWidgetState();
}

class _SubscribedProviderWidgetState extends State<SubscribedProviderWidget> {
  int selectedProviderIndex = -1; // -1 for "Fetch Ture"
  List providerList = [];

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


            providerList = state.providerModel.where((moduleService) =>
                moduleService.subscribedServices.any(
                (service) => service.id == widget.serviceId,
              ),
            ).toList();

            return Expanded(
              child: ListView(
                children: [
                  /// Default: Fetch Ture
                  Center(
                    child: _buildProviderCard(
                      context,
                      name: 'Fetch Ture',
                      price: widget.price,
                      newPrice: widget.discountedPrice,
                      discount: '00',
                      commission: widget.commission,
                      checkBox: Checkbox(
                        activeColor: CustomColor.greenColor,
                        value: selectedProviderIndex == -1,
                        onChanged: (value) {
                          if (value == true) {
                            setState(() => selectedProviderIndex = -1);
                            widget.onProviderSelected?.call("fetchTure");
                          }
                        },
                      ),
                    ),
                  ),

                  /// Provider List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: providerList.length,
                    itemBuilder: (context, index) {
                      final data = providerList[index];
                      final isSelected = selectedProviderIndex == index;

                      return _buildProviderCard(
                        context,
                        name: data.fullName,
                        price: data.subscribedServices.first.price.toString(),
                        newPrice: data.subscribedServices.first.discountedPrice.toString(),
                        discount: '00',
                        commission: '00',
                        checkBox: Checkbox(
                          activeColor: CustomColor.greenColor,
                          value: isSelected,
                          onChanged: (value) {
                            if (value == true) {
                              setState(() => selectedProviderIndex = index);
                              widget.onProviderSelected?.call(data.id);
                            }
                          },
                        ),
                      );
                    },
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

Widget _buildProviderCard(
    BuildContext context, {
      String? name,
      String? price,
      String? newPrice,
      String? discount,
      String? commission,
      Widget? checkBox,
    }) {
  return Stack(
    children: [
      CustomContainer(
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(backgroundImage: AssetImage(CustomImage.nullImage)),
            10.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name ?? '', style: textStyle14(context, color: CustomColor.appColor)),
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
          ],
        ),
      ),
      Align(
        alignment: Alignment.topRight,
        child: checkBox ?? const SizedBox.shrink(),
      ),
    ],
  );
}
