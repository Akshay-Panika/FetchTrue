import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:fetchtrue/feature/provider/screen/provider__details_screen.dart';
import 'package:fetchtrue/feature/service/screen/service_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_favorite_button.dart';
import '../../auth/repository/user_service.dart';
import '../../provider/bloc/provider/provider_bloc.dart';
import '../../provider/bloc/provider/provider_event.dart';
import '../../provider/bloc/provider/provider_state.dart';
import '../../provider/repository/provider_service.dart';
import '../../ratting_and_reviews/ratting_and_reviews_widget.dart';
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


/// Favorite service
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
  final Set<String> _removingServiceIds = {}; // loader handling set

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

  Future<void> removeFavoriteService(String serviceId) async {
    setState(() {
      _removingServiceIds.add(serviceId);
    });

    final url = Uri.parse(
        'https://biz-booster.vercel.app/api/users/favourite-services/${widget.userId}/$serviceId');

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      setState(() {
        _favoriteServiceIds.remove(serviceId);
        _removingServiceIds.remove(serviceId);
      });
      showCustomSnackBar(context, 'Removed from favorites');
    } else {
      setState(() {
        _removingServiceIds.remove(serviceId);
      });
      showCustomSnackBar(context, 'Failed to remove favorite');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isUserLoaded) return  Center(child: CircularProgressIndicator( color: CustomColor.appColor,));

    return BlocProvider(
      create: (_) => ModuleServiceBloc(ApiService())..add(GetModuleService()),
      child: BlocBuilder<ModuleServiceBloc, ModuleServiceState>(
        builder: (context, state) {
          if (state is ModuleServiceLoading) {
            return  Center(child: CircularProgressIndicator(color: CustomColor.appColor,));
          } else if (state is ModuleServiceLoaded) {
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
                final isRemoving = _removingServiceIds.contains(data.id);

                return CustomContainer(
                  border: false,
                  backgroundColor: Colors.white,
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
                                  isRemoving
                                      ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 3, color: Colors.red)
                                  )
                                      : InkWell(
                                    onTap: () {
                                      removeFavoriteService(data.id);
                                    },
                                    child: const Icon(Icons.favorite,
                                        color: Colors.red),
                                  )
                                ],
                              ),
                              RattingAndReviewsWidget(serviceId: data.id,),
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
          } else if (state is ModuleServiceError) {
            return Center(child: Text(state.errorMessage));
          }

          return const SizedBox.shrink();
        },
      ),
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
  List<String> _favoriteProviderIds = [];
  bool _isUserLoaded = false;
  final userService = UserService();
  final Set<String> _removingProviderIds = {}; // loader map

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (widget.userId != null) {
      final user = await userService.fetchUserById(widget.userId!);
      if (user != null) {
        _favoriteProviderIds = user.favoriteProviders;
      }
    }
    setState(() => _isUserLoaded = true);
  }

  Future<void> removeFavoriteProvider(String providerId) async {
    setState(() {
      _removingProviderIds.add(providerId);
    });

    final url = Uri.parse(
        'https://biz-booster.vercel.app/api/users/favourite-providers/${widget.userId}/$providerId');

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      setState(() {
        _favoriteProviderIds.remove(providerId);
        _removingProviderIds.remove(providerId);
      });
      showCustomSnackBar(context, 'Removed from favorites');
    } else {
      setState(() {
        _removingProviderIds.remove(providerId);
      });
      showCustomSnackBar(context, 'Failed to remove favorite');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isUserLoaded) return  Center(child: CircularProgressIndicator(color: CustomColor.appColor,));

    return BlocProvider(
      create: (_) => ProviderBloc(ProviderService())..add(GetProvider()),
      child: BlocBuilder<ProviderBloc, ProviderState>(
        builder: (context, state) {
          if (state is ProviderLoading) {
            return  Center(child: CircularProgressIndicator(color: CustomColor.appColor,));
          } else if (state is ProviderLoaded) {
            final provider = state.providerModel
                .where((p) => _favoriteProviderIds.contains(p.id))
                .toList();

            if (provider.isEmpty) {
              return const Center(child: Text('No provider found.'));
            }

            return ListView.separated(
              itemCount: provider.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final data = provider[index];
                final isRemoving = _removingProviderIds.contains(data.id);

                return CustomContainer(
                  border: false,
                  backgroundColor: Colors.white,
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
                                backgroundColor: Colors.white,
                                backgroundImage:
                                NetworkImage(data.storeInfo!.logo),
                              ),
                              CustomContainer(
                                backgroundColor: CustomColor.appColor,
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
                        child: isRemoving
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                          CircularProgressIndicator(strokeWidth: 3, color: Colors.red)
                        )
                            : InkWell(
                          onTap: () {
                            removeFavoriteProvider(data.id);
                          },
                          child: const Icon(Icons.favorite,
                              color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderDetailsScreen(providerId: data.id, storeName: data.storeInfo!.storeName.toString(),),)),
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
