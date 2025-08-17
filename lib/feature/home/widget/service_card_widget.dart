import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_favorite_button.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../favorite/widget/favorite_service_button_widget.dart';
import '../../profile/bloc/user_bloc/user_bloc.dart';
import '../../profile/bloc/user_bloc/user_event.dart';
import '../../profile/bloc/user_bloc/user_state.dart';
import '../../service/model/service_model.dart';
import '../../service/screen/service_details_screen.dart';

class ServiceCardWidget extends StatelessWidget {
  final List<ServiceModel> services;
  const ServiceCardWidget({super.key, required this.services,});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: services.length,
        itemBuilder: (context, index) {
          final data = services[index];
          return CustomContainer(
            border: false,
            width: 300,
            color: Colors.white,
            onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => ServiceDetailsScreen(serviceId: data.id),),),
            padding: EdgeInsets.zero,
            margin: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomContainer(
                    networkImg: '${data.thumbnailImage}',
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [


                          CustomFavoriteButton(),

                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              color: CustomColor.blackColor.withOpacity(0.3),
                            ),
                            child: Text('⭐ ${data.averageRating} (${data.totalReviews} ${'Reviews'})',
                              style: TextStyle(fontSize: 12, color:CustomColor.whiteColor ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                10.height,

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${data.serviceName}', style: textStyle12(context)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CustomAmountText(
                                amount: '${data.price}',
                                color: CustomColor.descriptionColor,
                                isLineThrough: true,
                              ),
                              10.width,

                              CustomAmountText(
                                amount: '${(data.discountedPrice ?? 0).toInt()}',
                                color: CustomColor.descriptionColor,
                              ),

                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Earn up to ',
                                style: textStyle12(
                                  context,
                                  color: CustomColor.descriptionColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              CustomAmountText(
                                amount: '${data.franchiseDetails.commission}',
                                color: CustomColor.descriptionColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                      5.height,
                      if (data.keyValues.isNotEmpty)
                        ...data.keyValues.map(
                              (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${entry.key} :', style: textStyle12(context, color: CustomColor.descriptionColor)),
                                5.width,
                                Expanded(
                                  child: Text(
                                    entry.value,
                                    style: textStyle12(
                                      context,
                                      fontWeight: FontWeight.w400,
                                      color: CustomColor.descriptionColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
