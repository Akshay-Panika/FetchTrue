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
import '../../address/address_notifier.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../module/bloc/module_bloc.dart';
import '../../module/bloc/module_event.dart';
import '../../module/bloc/module_state.dart';
import '../../module/model/module_model.dart';
import '../../module/repository/module_repository.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_state.dart';
import '../../profile/model/user_model.dart';
import '../../provider/bloc/provider/provider_bloc.dart';
import '../../provider/bloc/provider/provider_event.dart';
import '../../provider/bloc/provider/provider_state.dart';
import '../../provider/repository/provider_repository.dart';
import '../../provider/screen/provider__details_screen.dart';
import '../../service/bloc/service/service_bloc.dart';
import '../../service/bloc/service/service_event.dart';
import '../../service/bloc/service/service_state.dart';
import '../../service/repository/service_repository.dart';
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
    return BlocBuilder<UserBloc, UserState>(
      buildWhen: (previous, current) {
        return !(previous is UserLoaded && current is UserLoading);
      },
      builder: (context, userState) {
        if (userState is UserLoaded) {
          final user = userState.user;

          return DefaultTabController(
            length: 2, // 2 Tabs
            child: Scaffold(
              appBar: const CustomAppBar(
                title: 'Favorite',
                showBackButton: true,
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
                          FavoriteServiceWidget(user: user,),
                          FavoriteProviderWidget( user: user,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );

        }
        else if (userState is UserError) {
          debugPrint("Error: ${userState.massage}");
        }
        return const SizedBox.shrink();
      },
    );

  }
}


/// Favorite service
class FavoriteServiceWidget extends StatefulWidget {
  final UserModel user;
  const FavoriteServiceWidget({super.key, required this.user,});

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

    return BlocProvider(
      create: (_) => ServiceBloc(ServiceRepository())..add(GetServices()),
      child: BlocBuilder<ServiceBloc, ServiceState>(
        builder: (context, serviceState) {
          if (serviceState is ServiceLoading) {
            return  Center(child: CircularProgressIndicator(color: CustomColor.appColor));
          } else if (serviceState is ServiceLoaded) {
            final allServices = serviceState.services;
            final favoriteServiceIds = widget.user.favoriteServices;
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
                  child: Stack(
                    children: [
                      Row(
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
                                              ],
                                            ),
                                            Text('(${data.discount}% Off)', style: TextStyle(fontSize: 12, color: Colors.red.shade400),),
                      
                                          ],
                                        ),
                                      ),
                      
                                    ],
                                  ),
                      
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('Earn up to ', style: textStyle12(context, color: CustomColor.blackColor, fontWeight: FontWeight.w500),),
                                      Text(formatCommission(data.franchiseDetails.commission, half: true), style: textStyle12(context, color: CustomColor.greenColor,),),
                                    ],
                                  ),
                      
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      Positioned(
                          right: 5,top: 5,
                          child: FavoriteServiceButtonWidget(serviceId: data.id))
                    ],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceDetailsScreen(serviceId: data.id, providerId: '', isStore: false,),
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
      ),
    );  }
}


/// Favorite provider
class FavoriteProviderWidget extends StatefulWidget {
  final UserModel user;
  const FavoriteProviderWidget({super.key, required this.user,});

  @override
  State<FavoriteProviderWidget> createState() => _FavoriteProviderWidgetState();
}

class _FavoriteProviderWidgetState extends State<FavoriteProviderWidget> {


  @override
  Widget build(BuildContext context) {
    final addressNotifier = Provider.of<AddressNotifier>(context, listen: false);
    final lat = addressNotifier.latitude;
    final lng = addressNotifier.longitude;
    if (lat == null || lng == null) {
      return  Center(child: CircularProgressIndicator());
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProviderBloc(ProviderRepository())..add(GetProviders(lat, lng))),
        BlocProvider(create: (_) => ModuleBloc(ModuleRepository())..add(GetModules())),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProviderBloc, ProviderState>(listener: (context, state) {
            if (state is ProviderError) debugPrint('Provider Error: ${state.message}');
          },),

          BlocListener<ModuleBloc, ModuleState>(listener: (context, state) {
            if (state is ModuleError) debugPrint('Module Error: ${state.message}');
          },),

        ],
        child: Builder(
          builder: (context) {
            final providerState = context.watch<ProviderBloc>().state;
            final moduleState = context.watch<ModuleBloc>().state;

            if(providerState is ProviderLoading || moduleState is ModuleLoading){
              return  Center(child: CircularProgressIndicator(color: CustomColor.appColor,));
            }

            if(providerState is ProvidersLoaded && moduleState is ModuleLoaded){
              final modules = moduleState.modules;
             final favoriteProviderIds  = widget.user.favoriteProviders;
              final providers = providerState.providers.where((provider) => favoriteProviderIds.contains(provider.id)).toList();

              if (providers.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(CustomImage.emptyCart, height: 80),
                    const Text('No Provider')
                  ],
                );
              }

              return ListView.separated(
                itemCount: providers.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final provider = providers[index];
                   final providerModuleId = provider.storeInfo?.module;
                  final module = modules.firstWhere(
                        (m) => m.id == providerModuleId,
                    orElse: () => ModuleModel(id: '', name: 'Unknown Module'),
                  );
                  return CustomContainer(
                    border: false,
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    height: 120,
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                    radius: 30.5,
                                    backgroundColor: CustomColor.appColor,
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: (provider.storeInfo?.logo != null &&
                                          provider.storeInfo!.logo!.isNotEmpty &&
                                          Uri.tryParse(provider.storeInfo!.logo!)?.hasAbsolutePath == true)
                                          ? NetworkImage(provider.storeInfo!.logo!)
                                          : AssetImage(CustomImage.nullImage) as ImageProvider,
                                    )),
                                5.height,
                                Container(
                                    padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: CustomColor.greenColor,
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Text('Open', style: TextStyle(fontSize: 12, color: CustomColor.whiteColor),))
                              ],
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    provider.storeInfo!.storeName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  2.height,
                                  Text(
                                    '⭐ ${provider.averageRating} (${provider.totalReviews} Review)',
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                  ),
                                   Text(module.name.toString(),style: textStyle12(context,fontWeight: FontWeight.w400)),
                                  Expanded(
                                    child: Text(
                                      '${provider.storeInfo!.address} ${provider.storeInfo!.city} ${provider.storeInfo!.state}, ${provider.storeInfo!.country}',
                                      style: textStyle12(context, fontWeight: FontWeight.w400, color: Colors.grey.shade600),overflow: TextOverflow.ellipsis, maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Positioned(
                            top: 10,
                            right: 10,
                            child: FavoriteProviderButtonWidget(providerId: provider.id)
                        ),
                      ],
                    ),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderDetailsScreen(providerId: provider.id, storeName: provider.storeInfo!.storeName.toString(),),)),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );

  }
}
