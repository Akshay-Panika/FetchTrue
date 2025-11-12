import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/module/model/module_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../address/address_notifier.dart';
import '../../favorite/widget/favorite_provider_button_widget.dart';
import '../../module/bloc/module_bloc.dart';
import '../../module/bloc/module_event.dart';
import '../../module/bloc/module_state.dart';
import '../../module/repository/module_repository.dart';
import '../bloc/provider/provider_bloc.dart';
import '../bloc/provider/provider_event.dart';
import '../bloc/provider/provider_state.dart';
import '../repository/provider_repository.dart';

class ProviderScreen extends StatelessWidget {
  const ProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addressNotifier = Provider.of<AddressNotifier>(context, listen: false);
    final lat = addressNotifier.latitude;
    final lng = addressNotifier.longitude;

    if (lat == null || lng == null) {
      return const Scaffold(
        appBar: const CustomAppBar(title: 'Provider', showBackButton: true, showSearchIcon: false,),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProviderBloc(ProviderRepository())..add(GetProviders(lat, lng))),
        BlocProvider(create: (_) => ModuleBloc(ModuleRepository())..add(GetModules())),
      ],
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Provider', showBackButton: true, showSearchIcon: false,),

        body: SafeArea(
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
                  final providers = providerState.providers.where((e) => e.kycCompleted == true && e.subscribedServices.isNotEmpty).toList();
                  final modules = moduleState.modules;

                  if(providers.isEmpty){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person, size: 50,color: Colors.grey.shade600,),
                        Center(child: Text('No Provider')),
                      ],
                    );
                  }

                  return ListView.builder(
                    itemCount: providers.length,
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                    itemBuilder: (context, index) {
                      final provider = providers[index];
                      ModuleModel? module;
                      try {
                        module = modules.firstWhere((m) => m.id == provider.storeInfo?.module);
                      } catch (e) {
                        module = null;
                      }

                      return CustomContainer(
                        width: double.infinity,
                        color: Colors.white,
                        margin: EdgeInsets.only(top: 10),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          ),
                                        ),
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
                                    10.width,

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(provider.storeInfo!.storeName,style: textStyle14(context),),
                                        Text(
                                          '⭐ ${provider.averageRating} (${provider.totalReviews} Review)',
                                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                        ),
                                        Text(module?.name ?? 'Unknown', style: textStyle12(context,fontWeight: FontWeight.w400)),

                                      ],
                                    )
                                  ],
                                ),

                                if (provider.subscribedServices.isNotEmpty) ...[
                                  10.height,
                                  Builder(
                                    builder: (context) {
                                      final seenCategoryIds = <String>{};
                                      final uniqueServices = provider.subscribedServices.where((service) {
                                        final id = service.category?.id;
                                        if (id != null && !seenCategoryIds.contains(id)) {
                                          seenCategoryIds.add(id);
                                          return true;
                                        }
                                        return false;
                                      }).toList();

                                      // sirf 4 items show karna
                                      final limitedServices = uniqueServices.take(5).toList();

                                      final children = limitedServices.map((service) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: Colors.grey.shade500,width: 0.3),
                                          ),
                                          child: Text(
                                            '${service.category?.name ?? 'Unknown'}', style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                          ),
                                        );
                                      }).toList();

                                      // agar 4 se jyada items hai to end me [etc] add karo
                                      if (uniqueServices.length > 5) {
                                        children.add(
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(6),
                                                border: Border.all(color: Colors.grey.shade500,width: 0.3),
                                              ),
                                              child:  Text(
                                                'etc',style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                              ),
                                            ));
                                      }

                                      return Wrap(
                                        spacing: 10,
                                        runSpacing: 10,
                                        children: children,
                                      );
                                    },
                                  )
                                ]

                              ],
                            ),
                            Positioned(
                                top: 0,
                                right: 0,
                                child: FavoriteProviderButtonWidget(providerId: provider.id,)
                            ),
                          ],
                        ),
                        onTap: () {
                          context.push(
                            '/provider/${provider.id}?name=${Uri.encodeComponent(provider.storeInfo!.storeName)}',
                          );
                        },
                      );
                    },
                  );
                }

                return const SizedBox.shrink();}
            ),
          ),
        ),
      ),
    );
  }
}