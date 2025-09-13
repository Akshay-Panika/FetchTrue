import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_log_emoji.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../favorite/widget/favorite_provider_button_widget.dart';
import '../bloc/provider/provider_bloc.dart';
import '../bloc/provider/provider_event.dart';
import '../bloc/provider/provider_state.dart';
import '../repository/provider_repository.dart';
import '../widget/module_name_widget.dart';

class ProviderScreen extends StatelessWidget {
  const ProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => ProviderBloc(ProviderRepository())..add(GetProviders()),
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Provider', showBackButton: true, showSearchIcon: false,),
        body: SafeArea(
          child: BlocBuilder<ProviderBloc, ProviderState>(
            builder: (context, state) {
              if (state is ProviderLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ProvidersLoaded) {
                final providers = state.providers.where((e) => e.kycCompleted == true).toList();

                return ListView.builder(
                  itemCount: providers.length,
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                  itemBuilder: (context, index) {
                    final provider = providers[index];
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
                                  Stack(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: CustomColor.greyColor.withOpacity(0.2),
                                        backgroundImage: (provider.storeInfo?.logo != null &&
                                            provider.storeInfo!.logo!.isNotEmpty &&
                                            Uri.tryParse(provider.storeInfo!.logo!)?.hasAbsolutePath == true)
                                            ? NetworkImage(provider.storeInfo!.logo!)
                                            : AssetImage(CustomImage.nullImage) as ImageProvider,
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
                                      Text(provider.storeInfo!.storeName,style: textStyle12(context),),
                                      ModuleNameWidget(moduleId: provider.storeInfo!.module.toString(),),
                                      5.height,
                                      Text(
                                        '⭐ ${provider.averageRating} (${provider.totalReviews} Review)',
                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              10.height,
                              Divider(thickness: 0.3),

                              if (provider.subscribedServices.isNotEmpty) ...[
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
              else if (state is ProviderError) {
                debugPrint("${CustomLogEmoji.error} Provider Error ${state.message}");
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}