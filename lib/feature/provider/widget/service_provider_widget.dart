import 'package:carousel_slider/carousel_slider.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/provider/screen/provider_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_headline.dart';
import '../../favorite/widget/favorite_provider_button_widget.dart';
import '../../favorite/widget/favorite_service_button_widget.dart';
import '../../profile/bloc/user_bloc/user_bloc.dart';
import '../../profile/bloc/user_bloc/user_event.dart';
import '../../profile/bloc/user_bloc/user_state.dart';
import '../bloc/provider/provider_bloc.dart';
import '../bloc/provider/provider_event.dart';
import '../bloc/provider/provider_state.dart';
import '../repository/provider_by_id_service.dart';
import '../repository/provider_repository.dart';
import '../repository/provider_service.dart';
import '../screen/provider__details_screen.dart';

class ServiceProviderWidget extends StatefulWidget {
  const ServiceProviderWidget({super.key});

  @override
  State<ServiceProviderWidget> createState() => _ServiceProviderWidgetState();
}

class _ServiceProviderWidgetState extends State<ServiceProviderWidget> {

  @override
  Widget build(BuildContext context) {

    // return BlocProvider(
    //   create: (_) => ProviderBloc(ProviderRepository())..add(GetProviders()),
    //   child: BlocBuilder<ProviderBloc, ProviderState>(
    //     builder: (context, state) {
    //       if (state is ProviderLoading) {
    //         return LinearProgressIndicator(
    //           backgroundColor: CustomColor.appColor,
    //           color: CustomColor.whiteColor,
    //           minHeight: 2.5,
    //         );
    //       } else if (state is ProviderLoaded) {
    //         final provider = state;
    //         // final provider = state.providerModel.where((e) => e.kycCompleted == true).toList();
    //
    //         if (provider.isEmpty) {
    //           return const Center(child: Text('No provider found.'));
    //         }
    //
    //         return Container(
    //           color: CustomColor.appColor.withOpacity(0.08),
    //           padding: const EdgeInsets.only(top: 10),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               CustomHeadline(headline: 'Service Provider', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderScreen(),)),),
    //               10.height,
    //
    //               CarouselSlider.builder(
    //                 itemCount: provider.length,
    //                 itemBuilder: (context, index, realIndex) {
    //                   final data = provider[index];
    //                   return CustomContainer(
    //                     width: double.infinity,
    //                     color: Colors.white,
    //                     margin: EdgeInsetsGeometry.symmetric(horizontal: 10),
    //                     onTap: () => Navigator.push(
    //                       context,
    //                       MaterialPageRoute(
    //                         builder: (context) => ProviderDetailsScreen(
    //                           providerId: data.id,
    //                           storeName: data.storeInfo!.storeName,
    //                         ),
    //                       ),
    //                     ),
    //                     child: Stack(
    //                       children: [
    //                         Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           mainAxisAlignment: MainAxisAlignment.start,
    //                           children: [
    //                             15.height,
    //                             Row(
    //                               children: [
    //                                 Stack(
    //                                   alignment: AlignmentDirectional.bottomEnd,
    //                                   children: [
    //                                     CircleAvatar(
    //                                       radius: 30,
    //                                       backgroundColor: const Color(0xFFF2F2F2),
    //                                       backgroundImage: NetworkImage(data.storeInfo!.logo.toString()),
    //                                     ),
    //                                     CustomContainer(
    //                                       color: CustomColor.appColor,
    //                                         margin: EdgeInsets.zero,
    //                                         padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
    //                                         child: Text('Open', style: textStyle12(context, color: CustomColor.whiteColor),))
    //                                   ],
    //                                 ),
    //                                 10.width,
    //                                 Column(
    //                                   crossAxisAlignment: CrossAxisAlignment.start,
    //                                   children: [
    //                                     Text(
    //                                       data.storeInfo!.storeName,
    //                                       overflow: TextOverflow.ellipsis,
    //                                       maxLines: 1,
    //                                       style: const TextStyle(
    //                                         color: Colors.black,
    //                                         fontSize: 14,
    //                                         fontWeight: FontWeight.w500,
    //                                       ),
    //                                     ),
    //                                     Text(
    //                                       'Module Name',
    //                                       style: textStyle14(
    //                                         context,
    //                                         fontWeight: FontWeight.w400,
    //                                         color: CustomColor.descriptionColor,
    //                                       ),
    //                                     ),
    //                                     5.height,
    //                                     Text(
    //                                       '⭐ ${data.averageRating} (${data.totalReviews} Review)',
    //                                       style: TextStyle(fontSize: 12, color: Colors.black),
    //                                     )
    //                                   ],
    //                                 ),
    //                               ],
    //                             ),
    //                             Divider(thickness: 0.3),
    //
    //
    //                             // 👇 Replace your existing Wrap widget with this updated code
    //                             if (data.subscribedServices.isNotEmpty) ...[
    //                               Builder(
    //                                 builder: (context) {
    //                                   final seenCategoryIds = <String>{};
    //                                   final uniqueServices = data.subscribedServices.where((service) {
    //                                     final id = service.category?.id;
    //                                     if (id != null && !seenCategoryIds.contains(id)) {
    //                                       seenCategoryIds.add(id);
    //                                       return true;
    //                                     }
    //                                     return false;
    //                                   }).toList();
    //
    //                                   return Wrap(
    //                                     spacing: 10,
    //                                     runSpacing: 10,
    //                                     children: [
    //                                       for (int i = 0; i < uniqueServices.length; i++)
    //                                         if (i < 6)
    //                                           CustomContainer(
    //                                             margin: EdgeInsets.zero,
    //                                             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    //                                             child: Text(
    //                                               uniqueServices[i].category?.name ?? 'Unknown',
    //                                               style: textStyle12(
    //                                                 context,
    //                                                 fontWeight: FontWeight.w400,
    //                                                 color: CustomColor.descriptionColor,
    //                                               ),
    //                                             ),
    //                                           )
    //                                         else if (i == 6)
    //                                           CustomContainer(
    //                                             margin: EdgeInsets.zero,
    //                                             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    //                                             child:  Text("Other...",    style: textStyle12(
    //                                               context,
    //                                               fontWeight: FontWeight.w400,
    //                                               color: CustomColor.descriptionColor,),
    //                                           ),)
    //                                     ],
    //                                   );
    //                                 },
    //                               )
    //                             ],
    //
    //                           ],
    //                         ),
    //                         Positioned(
    //                           top: 0,
    //                           right: 0,
    //                           child: BlocBuilder<UsersBloc, UserState>(
    //                             builder: (context, state) {
    //                               if (state is UserLoading) {
    //                                 return const Center(child: CircularProgressIndicator());
    //                               }
    //
    //                               if (state is UserLoaded) {
    //                                 final favorites = state.user.favoriteProviders ?? [];
    //                                 final isFavorite = favorites.contains(data.id); // data.id is providerId
    //                                 final userId = state.user.id;
    //
    //                                 return FavoriteProviderButtonWidget(
    //                                   userId: userId,
    //                                   providerId: data.id,
    //                                   isInitiallyFavorite: isFavorite,
    //                                   onChanged: (newFavoriteStatus) {
    //                                     context.read<UsersBloc>().add(
    //                                       UserFavoriteProviderChangedEvent(
    //                                         providerId: data.id,
    //                                         isFavorite: newFavoriteStatus,
    //                                       ),
    //                                     );
    //                                   },
    //                                 );
    //                               }
    //
    //                               if (state is UserError) {
    //                                 return const Icon(Icons.favorite_border, color: Colors.grey);
    //                               }
    //
    //                               return const SizedBox.shrink();
    //                             },
    //                           ),
    //
    //                         ),
    //                       ],
    //                     ),
    //                   );
    //                 },
    //                 options: CarouselOptions(
    //                   height: 220,
    //                   enlargeCenterPage: false,
    //                   viewportFraction: 1,
    //                   autoPlayInterval: const Duration(seconds: 4),
    //                   autoPlayCurve: Curves.easeOut,
    //                   autoPlay: true,
    //                   padEnds: true,
    //                 ),
    //               ),
    //               10.height,
    //             ],
    //           ),
    //         );
    //       } else if (state is ProviderError) {
    //         print('Provide rerror : ${state.errorMessage}');
    //         return SizedBox.shrink();
    //         // return Center(child: Text(state.errorMessage));
    //       }
    //
    //       return const SizedBox.shrink();
    //     },
    //   ),
    // );

    return Container();
  }
}
