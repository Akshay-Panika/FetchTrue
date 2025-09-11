import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/feature/favorite/widget/favorite_service_button_widget.dart';
import 'package:fetchtrue/feature/service/screen/service_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/formate_price.dart';
import '../../../core/widgets/no_user_sign_widget.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_state.dart';
import '../../provider/bloc/provider/provider_bloc.dart';
import '../../provider/bloc/provider/provider_state.dart';
import '../../provider/screen/provider__details_screen.dart';
import '../../service/bloc/service/service_bloc.dart';
import '../../service/bloc/service/service_state.dart';
import '../widget/favorite_provider_button_widget.dart';

class FavoriteScreen extends StatelessWidget {
  final String? userId;
  final String status;
  const FavoriteScreen({super.key, this.userId, required this.status});

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);

    if (!userSession.isLoggedIn) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Favorite', showBackButton: true,),
        body: const Center(child: NoUserSignWidget()),
      );
    }
    return DefaultTabController(
      length: 2, // 2 Tabs
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Favorite',
          showBackButton: true,
          showSearchIcon: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorColor: CustomColor.appColor,
                  labelColor: Colors.black,
                  tabs: [
                    Tab(text: "Services"),
                    Tab(text: "Providers"),
                  ],
                ),
              ),
              10.height,
               Expanded(
                child: TabBarView(
                  children: [
                    FavoriteServiceWidget(userId: userId,),
                    FavoriteProviderWidget( userId: userId,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/// Favorite service
class FavoriteServiceWidget extends StatefulWidget {
  final String? userId;
  const FavoriteServiceWidget({super.key, this.userId});

  @override
  State<FavoriteServiceWidget> createState() => _FavoriteServiceWidgetState();
}

class _FavoriteServiceWidgetState extends State<FavoriteServiceWidget> {
  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);

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

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        if (userState is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (userState is UserLoaded) {
          final favoriteServiceIds = userState.user.favoriteServices;

          return BlocBuilder<ServiceBloc, ServiceState>(
            builder: (context, serviceState) {
              if (serviceState is ServiceLoading) {
                return  Center(child: CircularProgressIndicator(color: CustomColor.appColor));
              } else if (serviceState is ServiceLoaded) {
                final allServices = serviceState.services;

                /// Filter only favorite services
                final favoriteServices = allServices.where((service) => favoriteServiceIds.contains(service.id)).toList();

                if (favoriteServices.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(CustomImage.emptyCart, height: 80),
                      const Text('No Service')
                    ],
                  );
                }

                return ListView.builder(
                  itemCount: favoriteServices.length,
                  itemBuilder: (context, index) {
                    final data = favoriteServices[index];

                    return CustomContainer(
                      border: false,
                      color: Colors.white,
                      padding: EdgeInsets.zero,
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      height: 100,
                      child: Row(
                        children: [
                          CustomContainer(
                            networkImg: data.thumbnailImage,
                            margin: EdgeInsets.zero,
                            width: 180,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:  Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:  EdgeInsets.only(right: dimensions.screenHeight*0.02),
                                              child: Text(data.serviceName, style: textStyle12(context,),overflow: TextOverflow.ellipsis, maxLines: 1,),
                                            ),
                                            Row(
                                              children: [
                                                CustomAmountText(amount: formatPrice(data.discountedPrice!), color: CustomColor.greenColor, fontSize: 14, fontWeight: FontWeight.w500),
                                                10.width,
                                                CustomAmountText(amount: data.price.toString(), color: Colors.grey[500],isLineThrough: true,fontSize: 14, fontWeight: FontWeight.w500),
                                                10.width,
                                                Text('(${data.discount}% Off)', style: textStyle12(context, color: Colors.red.shade400),),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(formatCommission(data.franchiseDetails.commission, half: true), style: textStyle14(context, color: CustomColor.greenColor,),),
                                          Text('Earn up to ', style: TextStyle(fontSize: 12, color: CustomColor.blackColor, fontWeight: FontWeight.w500),),
                                        ],
                                      ),

                                      FavoriteServiceButtonWidget(serviceId: data.id),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ServiceDetailsScreen(serviceId: data.id),
                        ),
                      ),
                    );
                  },
                );
              } else if (serviceState is ServiceError) {
                return Center(child: Text(serviceState.message));
              }
              return const SizedBox.shrink();
            },
          );
        } else if (userState is UserError) {
          debugPrint("Error: ${userState.massage}");
        }
        return const SizedBox.shrink();
      },
    );
  }
}


/// Favorite provider
class FavoriteProviderWidget extends StatefulWidget {
  final String? userId;
  const FavoriteProviderWidget({super.key, this.userId});

  @override
  State<FavoriteProviderWidget> createState() => _FavoriteProviderWidgetState();
}

class _FavoriteProviderWidgetState extends State<FavoriteProviderWidget> {


  @override
  Widget build(BuildContext context) {

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        if (userState is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (userState is UserLoaded) {
          final favoriteProviderIds = userState.user.favoriteProviders;

          return BlocBuilder<ProviderBloc, ProviderState>(
            builder: (context, state) {
              if (state is ProviderLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ProvidersLoaded) {
                // final allProviders = state.providers.where((e) => e.kycCompleted == true).toList();

                final providers = state.providers.where((provider) => favoriteProviderIds.contains(provider.id)).toList();

                return ListView.separated(
                  itemCount: providers.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final data = providers[index];

                    return CustomContainer(
                      border: false,
                      color: Colors.white,
                      padding: EdgeInsets.zero,
                      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      height: 100,
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 10),
                              Stack(
                                alignment: AlignmentDirectional.bottomEnd,
                                children: [

                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: CustomColor.greyColor.withOpacity(0.2),
                                    backgroundImage: (data.storeInfo!.logo != null && data.storeInfo!.logo!.isNotEmpty && Uri.tryParse(data.storeInfo!.logo!)?.hasAbsolutePath == true)
                                        ? NetworkImage(data.storeInfo!.logo!)
                                        : AssetImage(CustomImage.nullImage) as ImageProvider,
                                  ),
                                  CustomContainer(
                                    color: CustomColor.appColor,
                                    margin: EdgeInsets.zero,
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                    child: const Text(
                                      'Open',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    Text(
                                      data.storeInfo!.storeName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Text("Onboarding",
                                        style: TextStyle(fontSize: 14)),
                                    Text(
                                      '${data.storeInfo!.address} ${data.storeInfo!.city} ${data.storeInfo!.state}, ${data.storeInfo!.country}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Positioned(
                              top: 10,
                              right: 10,
                              child: FavoriteProviderButtonWidget(providerId: data.id)
                          ),
                        ],
                      ),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderDetailsScreen(providerId: data.id, storeName: data.storeInfo!.storeName.toString(),),)),
                    );
                  },
                );
              }
              else if (state is ProviderError) {
                print(state.message);
              }
              return const SizedBox.shrink();
            },
          );


        } else if (userState is UserError) {
          debugPrint("Error: ${userState.massage}");
        }
        return const SizedBox.shrink();
      },
    );

  }
}
