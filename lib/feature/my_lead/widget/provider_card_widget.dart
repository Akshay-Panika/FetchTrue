import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_icon.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../helper/Contact_helper.dart';
import '../../provider/bloc/provider/provider_bloc.dart';
import '../../provider/bloc/provider/provider_state.dart';

class ProviderCardWidget extends StatelessWidget {
  final String? providerId;
  const ProviderCardWidget({super.key, required this.providerId});

  @override
  Widget build(BuildContext context) {
    if (providerId == null || providerId!.isEmpty) {
      return SizedBox.shrink();
    }

    return BlocBuilder<ProviderBloc, ProviderState>(
      builder: (context, state) {
        if (state is ProviderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProvidersLoaded) {
          /// ✅ Find provider safely with orElse
          final provider = state.providers.firstWhere(
                (e) => e.kycCompleted == true && e.id == providerId,
            // orElse: () => null, // null return if not found
          );

          if (provider == null) {
            return const Center(
              child: Text(
                "No Provider Available",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            );
          }

          return CustomContainer(
            border: true,
            color: CustomColor.whiteColor,
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Service Provider', style: textStyle14(context)),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                          backgroundImage: provider.storeInfo?.logo != null &&
                              provider.storeInfo!.logo!.isNotEmpty
                              ? NetworkImage(provider.storeInfo!.logo!)
                              : null,
                          child: (provider.storeInfo?.logo == null ||
                              provider.storeInfo!.logo!.isEmpty)
                              ? Text(
                            provider.storeInfo?.storeName
                                ?.substring(0, 1)
                                .toUpperCase() ??
                                "?",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          )
                              : null,
                        ),
                        10.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.storeInfo?.storeName ??
                                  'No Provider Available',
                              style: textStyle14(context),
                            ),
                            Text(
                              'No Module',
                              style: textStyle14(
                                context,
                                fontWeight: FontWeight.w400,
                                color: CustomColor.descriptionColor,
                              ),
                            ),
                            5.height,
                            if (provider.storeInfo?.storePhone != null &&
                                provider.storeInfo!.storePhone!.isNotEmpty)
                              Text(
                                'Contact: +91 ${provider.storeInfo!.storePhone}',
                                style: textStyle12(
                                  context,
                                  color: CustomColor.descriptionColor,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => ContactHelper.whatsapp(
                              provider.phoneNo ?? '',
                              'Dear Provider\n${provider.fullName ?? ''}',
                            ),
                            child: Image.asset(
                              CustomIcon.whatsappIcon,
                              height: 25,
                            ),
                          ),
                          40.width,
                          InkWell(
                            onTap: () {
                              if (provider.storeInfo?.storePhone != null &&
                                  provider.storeInfo!.storePhone!.isNotEmpty) {
                                ContactHelper.call(
                                    provider.storeInfo!.storePhone!);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                    Text('Phone number not available'),
                                  ),
                                );
                              }
                            },
                            child: Image.asset(
                              CustomIcon.phoneIcon,
                              height: 25,
                              color: CustomColor.appColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                5.height,
                Text(
                  '⭐ ${provider.totalReviews ?? 0} (${provider.totalReviews ?? 0} Reviews)',
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
          );
        } else if (state is ProviderError) {
          debugPrint(state.message);
          return const SizedBox.shrink();
        }
        return const SizedBox.shrink();
      },
    );
  }
}
