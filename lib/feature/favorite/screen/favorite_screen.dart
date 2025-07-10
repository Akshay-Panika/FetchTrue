import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_ratting_and_reviews.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_favorite_button.dart';
import '../../more/repository/user_service.dart';
import '../../provider/bloc/provider/provider_bloc.dart';
import '../../provider/bloc/provider/provider_event.dart';
import '../../provider/bloc/provider/provider_state.dart';
import '../../provider/repository/provider_service.dart';
import '../../service/bloc/module_service/module_service_bloc.dart';
import '../../service/bloc/module_service/module_service_event.dart';
import '../../service/bloc/module_service/module_service_state.dart';
import '../../service/repository/api_service.dart';

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


/// Favorite screen
class FavoriteServiceWidget extends StatefulWidget {
  final String? userId;
  const FavoriteServiceWidget({super.key, this.userId});

  @override
  State<FavoriteServiceWidget> createState() => _FavoriteServiceWidgetState();
}

class _FavoriteServiceWidgetState extends State<FavoriteServiceWidget> {

  List<String> _favoriteServiceIds = [];
  bool _isUserLoaded = false;
  final userService = UserService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (widget.userId != null) {
      final user = await userService.fetchUserById(widget.userId!);
      if (user != null) {
        _favoriteServiceIds = user.favoriteServices;
      }
    }
    setState(() => _isUserLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isUserLoaded) return const Center(child: CircularProgressIndicator());

    return BlocProvider(
      create: (_) => ModuleServiceBloc(ApiService())..add(GetModuleService()),
      child: BlocBuilder<ModuleServiceBloc, ModuleServiceState>(
        builder: (context, state) {
          if (state is ModuleServiceLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ModuleServiceLoaded) {
            // final services = state.serviceModel;
            final services = state.serviceModel
                .where((s) => _favoriteServiceIds.contains(s.id))
                .toList();

            if (services.isEmpty) {
              return const Center(child: Text('No Service found.'));
            }

            return ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final data = services[index];
                return CustomContainer(
                  border: false,
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  height: 100,
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CustomContainer(
                            networkImg: data.thumbnailImage,
                            margin: EdgeInsets.zero,
                            width: 180,
                          ),

                          Positioned(
                              top: -10,right: -10,
                              child: CustomFavoriteButton())
                        ],
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  data.serviceName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                              CustomRattingAndReviews(),
                              5.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CustomAmountText(
                                          amount: '150', isLineThrough: true),
                                      10.width,
                                      CustomAmountText(
                                          amount: '150', isLineThrough: false),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Earn up to",
                                          style: TextStyle(fontSize: 14)),
                                      SizedBox(width: 4),
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
                );
              },
            );
          } else if (state is ModuleServiceError) {
            return Center(child: Text(state.errorMessage));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class FavoriteProviderWidget extends StatefulWidget {
  final String? userId;
  const FavoriteProviderWidget({super.key, this.userId});

  @override
  State<FavoriteProviderWidget> createState() => _FavoriteProviderWidgetState();
}

class _FavoriteProviderWidgetState extends State<FavoriteProviderWidget> {
  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => ProviderBloc(ProviderService())..add(GetProvider()),
      child: BlocBuilder<ProviderBloc, ProviderState>(
        builder: (context, state) {
          if (state is ProviderLoading) {
            return  Center(child: CircularProgressIndicator(),);
          } else if (state is ProviderLoaded) {
            final provider = state.providerModel;

            if (provider.isEmpty) {
              return const Center(child: Text('No provider found.'));
            }

            return ListView.separated(
              itemCount: provider.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {

                final data = provider[index];

                return CustomContainer(
                  border: false,
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
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
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(data.storeInfo!.logo),
                                ),
                               
                               CustomContainer(
                                 backgroundColor: CustomColor.appColor,margin: EdgeInsets.zero,padding: EdgeInsets.symmetric(horizontal: 25),
                                 child: Text('Open', style: TextStyle(color: CustomColor.whiteColor),),)
                             ],
                           ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                SizedBox(height: 10),
                                Text(data.storeInfo!.storeName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text("Onboarding", style: TextStyle(fontSize: 14)),
                                Text('${data.storeInfo!.address} ${data.storeInfo!.city} ${data.storeInfo!.state}, ${data.storeInfo!.country}', style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Positioned(
                        top: 0,
                        right: 0,
                        child: CustomFavoriteButton(),
                      ),
                    ],
                  ),
                );
              },
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
