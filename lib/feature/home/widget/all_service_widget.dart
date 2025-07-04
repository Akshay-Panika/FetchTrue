import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_favorite_button.dart';
import '../../../core/widgets/custom_headline.dart';
import '../../../core/widgets/custom_ratting_and_reviews.dart';
import '../../service/bloc/module_service/module_service_bloc.dart';
import '../../service/bloc/module_service/module_service_event.dart';
import '../../service/bloc/module_service/module_service_state.dart';
import '../../service/repository/api_service.dart';
import '../../service/screen/service_details_screen.dart';

class AllServiceWidget extends StatelessWidget {
  final String headline;
  const AllServiceWidget({super.key, required this.headline});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ModuleServiceBloc(ApiService())..add(GetModuleService()),
      child:  BlocBuilder<ModuleServiceBloc, ModuleServiceState>(
        builder: (context, state) {
          if (state is ModuleServiceLoading) {
            return Center(child: LinearProgressIndicator(backgroundColor: CustomColor.appColor, color: CustomColor.whiteColor ,minHeight: 2.5,),);
          }

          else if(state is ModuleServiceLoaded){

            final services = state.serviceModel;
            // final services = state.serviceModel.where((moduleService) =>
            // moduleService.id == data.subscribedServices.first.id
            // ).toList();

            if (services.isEmpty) {
              return const Center(child: Text('No Service found.'));
            }

            return  Container(
                // color: CustomColor.greenColor.withOpacity(0.1),
                child: Column(
                  children: [
                    CustomHeadline(headline: headline,),
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        itemCount: services.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final data = services[index];
                          return CustomContainer(
                            border: false,
                            width: 300,
                            backgroundColor: Colors.white,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailsScreen(serviceId: data.id,),)),
                            padding: EdgeInsets.all(0),
                            margin: EdgeInsets.only(right: 0, left: 10,bottom: 10,top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                /// Caver img
                                Expanded(
                                  child: CustomContainer(
                                    margin: EdgeInsets.all(0),
                                    padding: EdgeInsets.all(0),
                                    networkImg: '${data.thumbnailImage}',
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomFavoriteButton(),
                                          Container(
                                            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                              ),
                                              color: CustomColor.blackColor.withOpacity(0.3),
                                            ),
                                            child: CustomRattingAndReviews(color: CustomColor.whiteColor,),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                10.height,
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${data.serviceName}', style: textStyle12(context),),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CustomAmountText(amount: '${data.price}', color: CustomColor.descriptionColor, isLineThrough: true),
                                              10.width,
                                              CustomAmountText(amount: '${data.discountedPrice}', color: CustomColor.descriptionColor,),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text('Earn up to ', style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                                              CustomAmountText(amount: '${data.franchiseDetails.commission}', color: CustomColor.descriptionColor),
                                            ],
                                          ),
                                        ],
                                      ),
                                      5.height,

                                      if (data.keyValues.isNotEmpty)
                                        ...data.keyValues.map((entry) => Padding(
                                          padding: const EdgeInsets.only(bottom: 6.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('${entry.key} :', style: textStyle12(context, color: CustomColor.descriptionColor)),
                                              5.width,
                                              Expanded(
                                                child: Text(
                                                  entry.value,
                                                  style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),

                                      5.height,
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ));

          }

          else if (state is ModuleServiceError) {
            return Center(child: Text(state.errorMessage));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
