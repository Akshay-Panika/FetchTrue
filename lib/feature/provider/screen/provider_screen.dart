import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/provider/screen/provider__details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_favorite_button.dart';
import '../../favorite/widget/favorite_provider_button_widget.dart';
import '../../profile/bloc/user_bloc/user_bloc.dart';
import '../../profile/bloc/user_bloc/user_event.dart';
import '../../profile/bloc/user_bloc/user_state.dart';
import '../bloc/provider/provider_bloc.dart';
import '../bloc/provider/provider_event.dart';
import '../bloc/provider/provider_state.dart';
import '../repository/provider_service.dart';

class ProviderScreen extends StatefulWidget {
  const ProviderScreen({super.key});

  @override
  State<ProviderScreen> createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Provider', showBackButton: true, showSearchIcon: true,),

      body:  BlocProvider(
        create: (_) => ProviderBloc(ProviderService())..add(GetProvider()),
        child:  BlocBuilder<ProviderBloc, ProviderState>(
          builder: (context, state) {
            if (state is ProviderLoading) {
              return LinearProgressIndicator(backgroundColor: CustomColor.appColor, color: CustomColor.whiteColor ,minHeight: 2.5,);
            }

            else if(state is ProviderLoaded){

              // final provider = state.providerModel;
              final provider = state.providerModel.where((e) => e.kycCompleted == true).toList();


              if (provider.isEmpty) {
                return const Center(child: Text('No provider found.'));
              }


              return  ListView.builder(
                  itemCount: provider.length,
                  padding: EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    final data = provider[index];


                    return CustomContainer(
                      width: double.infinity,
                      color: Colors.white,
                      margin: EdgeInsets.only(top: 10),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderDetailsScreen(providerId: data.id, storeName: data.storeInfo!.storeName,),)),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: CustomColor.greyColor.withOpacity(0.2),
                                        backgroundImage: NetworkImage(data.storeInfo!.logo.toString()),
                                      ),
                                      CustomContainer(
                                          color: CustomColor.appColor,
                                          margin: EdgeInsets.zero,
                                          padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                                          child: Text('Open', style: textStyle12(context, color: CustomColor.whiteColor),))
                                    ],
                                  ),
                                  10.width,

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(data.storeInfo!.storeName,style: textStyle14(context),),
                                      Text('Module Name', style: textStyle14(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),),
                                      5.height,
                                      Text(
                                        '⭐ ${data.averageRating} (${data.totalReviews} Review)',
                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              10.height,

                              // 👇 Replace your existing Wrap widget with this updated code
                              if (data.subscribedServices.isNotEmpty) ...[
                                Divider(thickness: 0.3),

                                // ✅ Unique Category ID Filter Logic
                                Builder(
                                  builder: (context) {
                                    final seenCategoryIds = <String>{};
                                    final uniqueServices = data.subscribedServices.where((service) {
                                      final id = service.category?.id;
                                      if (id != null && !seenCategoryIds.contains(id)) {
                                        seenCategoryIds.add(id);
                                        return true;
                                      }
                                      return false;
                                    }).toList();

                                    return Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: uniqueServices.map((service) {
                                        return CustomContainer(
                                          margin: EdgeInsets.zero,
                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                          child: Text(
                                            service.category?.name ?? 'Unknown',
                                            style: textStyle12(
                                              context,
                                              fontWeight: FontWeight.w400,
                                              color: CustomColor.descriptionColor,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                )
                              ],


                            ],
                          ),
                           Positioned(
                            top: 0,
                            right: 0,
                            child: BlocBuilder<UserBloc, UserState>(
                              builder: (context, state) {
                                if (state is UserLoading) {
                                  return const Center(child: CircularProgressIndicator());
                                }

                                if (state is UserLoaded) {
                                  final favorites = state.user.favoriteProviders ?? [];
                                  final isFavorite = favorites.contains(data.id); // data.id is providerId
                                  final userId = state.user.id;

                                  return FavoriteProviderButtonWidget(
                                    userId: userId,
                                    providerId: data.id,
                                    isInitiallyFavorite: isFavorite,
                                    onChanged: (newFavoriteStatus) {
                                      context.read<UserBloc>().add(
                                        UserFavoriteProviderChangedEvent(
                                          providerId: data.id,
                                          isFavorite: newFavoriteStatus,
                                        ),
                                      );
                                    },
                                  );
                                }

                                if (state is UserError) {
                                  return const Icon(Icons.favorite_border, color: Colors.grey);
                                }

                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  });

            }

            else if (state is ProviderError) {
              return Center(child: Text(state.errorMessage));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}