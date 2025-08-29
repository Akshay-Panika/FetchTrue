import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:fetchtrue/feature/service/screen/service_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../service/bloc/service/service_bloc.dart';
import '../../service/bloc/service/service_state.dart';

class FavoriteScreen extends StatelessWidget {
  final String? userId;
  const FavoriteScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
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

    return BlocBuilder<ServiceBloc, ServiceState>(
      builder: (context, state) {
        if (state is ServiceLoading) {
          return  Center(child: CircularProgressIndicator(color: CustomColor.appColor,));
        } else if (state is ServiceLoaded) {
          final services = state.services;

          if (services.isEmpty) {
            return const Center(child: Text('No Service found.'));
          }

          return ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              final data = services[index];

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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    data.serviceName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CustomAmountText(
                                        amount: '150', isLineThrough: true),
                                    const SizedBox(width: 10),
                                    CustomAmountText(
                                        amount: '150', isLineThrough: false),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text("Earn up to",
                                        style: TextStyle(fontSize: 14)),
                                    const SizedBox(width: 4),
                                    CustomAmountText(amount: '50'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailsScreen(serviceId: data.id),)),
              );
            },
          );
        } else if (state is ServiceError) {
          return Center(child: Text(state.message));
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

    // return BlocProvider(
    //   create: (_) => ProviderBloc(ProviderRepository())..add(GetProviders()),
    //   // create: (_) => ProviderBloc(ProviderService())..add(GetProvider()),
    //   child: BlocBuilder<ProviderBloc, ProviderState>(
    //     builder: (context, state) {
    //       if (state is ProviderLoading) {
    //         return  Center(child: CircularProgressIndicator(color: CustomColor.appColor,));
    //       } else if (state is ProviderLoaded) {
    //         final provider = state.providerModel
    //             .where((p) => _favoriteProviderIds.contains(p.id))
    //             .toList();
    //
    //         if (provider.isEmpty) {
    //           return const Center(child: Text('No provider found.'));
    //         }
    //
    //         return ListView.separated(
    //           itemCount: provider.length,
    //           separatorBuilder: (context, index) => const SizedBox(height: 10),
    //           itemBuilder: (context, index) {
    //             final data = provider[index];
    //             final isRemoving = _removingProviderIds.contains(data.id);
    //
    //             return CustomContainer(
    //               border: false,
    //               color: Colors.white,
    //               padding: EdgeInsets.zero,
    //               margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
    //               height: 100,
    //               child: Stack(
    //                 children: [
    //                   Row(
    //                     children: [
    //                       const SizedBox(width: 10),
    //                       Stack(
    //                         alignment: AlignmentDirectional.bottomEnd,
    //                         children: [
    //                           CircleAvatar(
    //                             radius: 40,
    //                             backgroundColor: Colors.white,
    //                             backgroundImage:
    //                             NetworkImage(data.storeInfo!.logo.toString()),
    //                           ),
    //                           CustomContainer(
    //                             color: CustomColor.appColor,
    //                             margin: EdgeInsets.zero,
    //                             padding:
    //                             const EdgeInsets.symmetric(horizontal: 25),
    //                             child: const Text(
    //                               'Open',
    //                               style: TextStyle(color: Colors.white),
    //                             ),
    //                           )
    //                         ],
    //                       ),
    //                       const SizedBox(width: 10),
    //                       Expanded(
    //                         child: Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             const SizedBox(height: 10),
    //                             Text(
    //                               data.storeInfo!.storeName,
    //                               style: const TextStyle(
    //                                 fontSize: 14,
    //                                 fontWeight: FontWeight.w500,
    //                               ),
    //                             ),
    //                             const Text("Onboarding",
    //                                 style: TextStyle(fontSize: 14)),
    //                             Text(
    //                               '${data.storeInfo!.address} ${data.storeInfo!.city} ${data.storeInfo!.state}, ${data.storeInfo!.country}',
    //                               style: const TextStyle(fontSize: 14),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                   Positioned(
    //                     top: 10,
    //                     right: 10,
    //                     child: isRemoving
    //                         ? const SizedBox(
    //                       width: 20,
    //                       height: 20,
    //                       child:
    //                       CircularProgressIndicator(strokeWidth: 3, color: Colors.red)
    //                     )
    //                         : InkWell(
    //                       onTap: () {
    //                         removeFavoriteProvider(data.id);
    //                       },
    //                       child: const Icon(Icons.favorite,
    //                           color: Colors.red),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderDetailsScreen(providerId: data.id, storeName: data.storeInfo!.storeName.toString(),),)),
    //             );
    //           },
    //         );
    //       } else if (state is ProviderError) {
    //         return Center(child: Text(state.message));
    //       }
    //
    //       return const SizedBox.shrink();
    //     },
    //   ),
    // );
    return Scaffold();
  }
}
