import 'package:fetchtrue/core/costants/custom_logo.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_icon.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../helper/Contact_helper.dart';
import '../../provider/bloc/provider/provider_bloc.dart';
import '../../provider/bloc/provider/provider_event.dart';
import '../../provider/bloc/provider/provider_state.dart';
import '../../provider/repository/provider_service.dart';
import '../../provider/screen/provider__details_screen.dart';
import '../model/leads_model.dart';

class ProviderCardWidget extends StatefulWidget {
  final LeadsModel lead;
  const ProviderCardWidget({super.key, required this.lead});

  @override
  State<ProviderCardWidget> createState() => _ProviderCardWidgetState();
}

class _ProviderCardWidgetState extends State<ProviderCardWidget> {


  @override
  Widget build(BuildContext context) {
    return Container();
    // return BlocProvider(
    //   create: (_) => ProviderBloc(ProviderService())..add(GetProvider()),
    //   child:  BlocBuilder<ProviderBloc, ProviderState>(
    //     builder: (context, state) {
    //       if (state is ProviderLoading) {
    //         return  SizedBox.shrink();
    //       }
    //
    //       else if(state is ProviderLoaded){
    //
    //         final providerId = widget.lead.provider;
    //         if (providerId == null) return _buildFTProviderCard();
    //         final provider = state.providerModel.where((moduleService) =>
    //         moduleService.id == providerId
    //         ).toList();
    //
    //         if (provider.isEmpty) {
    //           return  SizedBox.shrink();
    //         }
    //
    //
    //         return  CustomContainer(
    //           border: true,
    //           color: CustomColor.whiteColor,
    //           margin: EdgeInsets.zero,
    //           child: Column(
    //             children: [
    //               InkWell(
    //                 // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderDetailsScreen(),)),
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   children: [
    //                     Text('Service Provider', style: textStyle14(context),),
    //                     10.height,
    //
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Row(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             CircleAvatar(
    //                               backgroundColor: CustomColor.greyColor.withOpacity(0.2),
    //                               backgroundImage: NetworkImage(provider.first.storeInfo!.logo.toString()),
    //                             ),
    //                             10.width,
    //
    //                             Column(
    //                               crossAxisAlignment: CrossAxisAlignment.start,
    //                               children: [
    //                                 Text(provider.first.storeInfo!.storeName.toString(), style: textStyle14(context),),
    //                                 Text('Module Name', style: textStyle14(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),),
    //                                 5.height,
    //
    //                                 // Text('Contact: +91 ${provider.first.phoneNo}'),
    //                               ],
    //                             )
    //                           ],
    //                         ),
    //
    //                         Padding(
    //                           padding: const EdgeInsets.only(right: 10.0),
    //                           child: Row(
    //                             mainAxisAlignment: MainAxisAlignment.center,
    //                             crossAxisAlignment: CrossAxisAlignment.center,
    //                             children: [
    //                               InkWell(onTap: () => ContactHelper.whatsapp('${provider.first.phoneNo}', 'Dear Provider\n${provider.first.fullName}'),
    //                                   child: Image.asset(CustomIcon.whatsappIcon, height: 25,)),
    //                               40.width,
    //                               InkWell(onTap: () => ContactHelper.call(provider.first.phoneNo),
    //                                   child: Image.asset(CustomIcon.phoneIcon, height: 25, color: CustomColor.appColor,)),
    //
    //                             ],
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                     5.height,
    //                     Text(
    //                       '⭐ ${provider.first.averageRating} (${provider.first.totalReviews} Review)',
    //                       style: TextStyle(fontSize: 12, color: Colors.black),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               // Divider(),
    //               // InkWell(
    //               //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderDetailsScreen(),)),
    //               //   child: Column(
    //               //     crossAxisAlignment: CrossAxisAlignment.start,
    //               //     mainAxisAlignment: MainAxisAlignment.start,
    //               //     children: [
    //               //       Text('Service Manager', style: textStyle14(context),),
    //               //       10.height,
    //               //
    //               //       Row(
    //               //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               //         crossAxisAlignment: CrossAxisAlignment.start,
    //               //         children: [
    //               //           Row(
    //               //             crossAxisAlignment: CrossAxisAlignment.start,
    //               //             children: [
    //               //               CircleAvatar(radius: 25,
    //               //                 backgroundImage: AssetImage(CustomImage.nullImage),),
    //               //               10.width,
    //               //
    //               //               Column(
    //               //                 crossAxisAlignment: CrossAxisAlignment.start,
    //               //                 children: [
    //               //                   Text('Name: N/A', style: TextStyle(color: CustomColor.descriptionColor),),
    //               //                   Text('Contact: N/A', style: TextStyle(color: CustomColor.descriptionColor),),
    //               //                 ],
    //               //               )
    //               //             ],
    //               //           ),
    //               //
    //               //           Padding(
    //               //             padding: const EdgeInsets.only(right: 10.0),
    //               //             child: Row(
    //               //               mainAxisAlignment: MainAxisAlignment.center,
    //               //               crossAxisAlignment: CrossAxisAlignment.center,
    //               //               children: [
    //               //                 InkWell(onTap: () => ContactHelper.whatsapp('', ''),
    //               //                     child: Image.asset(CustomIcon.whatsappIcon, height: 25,)),
    //               //                 40.width,
    //               //                 InkWell(onTap: () => ContactHelper.call(''),
    //               //                     child: Image.asset(CustomIcon.phoneIcon, height: 25, color: CustomColor.appColor,)),
    //               //
    //               //               ],
    //               //             ),
    //               //           )
    //               //         ],
    //               //       ),
    //               //     ],
    //               //   ),
    //               // ),
    //             ],
    //           ),
    //         );
    //
    //       }
    //
    //       else if (state is ProviderError) {
    //         return Center(child: Text(state.errorMessage));
    //       }
    //       return const SizedBox.shrink();
    //     },
    //   ),
    // );
  }
}



Widget _buildFTProviderCard(){
  return  CustomContainer(
    border: true,
    color: CustomColor.whiteColor,
    margin: EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        10.height,

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 30,
                  child: CircleAvatar(radius: 25,
                    backgroundImage: AssetImage(CustomLogo.fetchTrueLogo),),
                ),
                10.height,
                Text('This Service Provided By Fetch True', style: TextStyle(),),

              ],
            ),

            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(onTap: () => ContactHelper.whatsapp('', 'Dear Provide}'),
                      child: Image.asset(CustomIcon.whatsappIcon, height: 25,)),
                  40.width,
                  InkWell(onTap: () => ContactHelper.call(''),
                      child: Image.asset(CustomIcon.phoneIcon, height: 25, color: CustomColor.appColor,)),

                ],
              ),
            )
          ],
        ),
      ],
    ),
  );
}