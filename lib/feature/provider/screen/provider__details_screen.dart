import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../favorite/widget/favorite_provider_button_widget.dart';
import '../../module/bloc/module_bloc.dart';
import '../../module/bloc/module_event.dart';
import '../../module/bloc/module_state.dart';
import '../../module/repository/module_repository.dart';
import '../bloc/provider/provider_bloc.dart';
import '../bloc/provider/provider_event.dart';
import '../bloc/provider/provider_state.dart';
import '../model/provider_model.dart';
import '../repository/provider_repository.dart';
import '../widget/gallery_widget.dart';
import '../widget/provider_all_service_widget.dart';
import '../widget/provider_requirement_service_widget.dart';
import '../widget/provider_review_widget.dart';
import 'package:fetchtrue/feature/module/model/module_model.dart';


class ProviderDetailsScreen extends StatefulWidget {
  final String? providerId;
  final String? storeName;
  const ProviderDetailsScreen({super.key, this.storeName, this.providerId});

  @override
  State<ProviderDetailsScreen> createState() => _ProviderDetailsScreenState();
}

class _ProviderDetailsScreenState extends State<ProviderDetailsScreen> {
  final List<Tab> myTabs = const [
    Tab(text: 'Services'),
    Tab(text: 'Reviews'),
    Tab(text: 'About'),
    Tab(text: 'Gallery'),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProviderBloc(ProviderRepository())..add(GetProviderById(widget.providerId!))),
        BlocProvider(create: (_) => ModuleBloc(ModuleRepository())..add(GetModules())),

      ],
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.storeName ?? 'Store Name',
          showBackButton: true,
          showFavoriteIcon: false,
        ),

        body: DefaultTabController(
          length: myTabs.length,
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

                if (providerState is ProviderLoaded && moduleState is ModuleLoaded) {
                  final provider = providerState.provider;
                  final modules = moduleState.modules;

                  // module safe fetch
                  final selectedModule = modules.firstWhere(
                        (m) => m.id == provider?.storeInfo?.module,
                    orElse: () => ModuleModel(id: '', name: 'Unknown'),
                  );

                  // provider safe fetch
                  final selectedProvider = (provider != null && provider.kycCompleted == true)
                      ? provider
                      : null;

                  if (selectedProvider == null) {
                    return const Center(child: Text("Provider not available"));
                  }


                  return CustomScrollView(
                     slivers: [
                       /// Cover Image
                       SliverAppBar(
                         toolbarHeight: 200,
                         pinned: false,
                         floating: false,
                         automaticallyImplyLeading: false,
                         flexibleSpace: FlexibleSpaceBar(
                           background: Container(
                             decoration: BoxDecoration(
                               image: DecorationImage(
                                 image: _getImageProvider(provider.storeInfo?.cover),
                                 fit: BoxFit.cover,
                               ),
                             ),
                           ),
                         ),
                       ),

                       /// Sticky Header with Profile + TabBar
                       SliverPersistentHeader(
                         pinned: true,
                         delegate: _StickyHeaderDelegate(
                           child: Column(
                             children: [
                               Center(child: _profileCard(data: provider, moduleName: selectedModule?.name)),
                               TabBar(
                                 isScrollable: true,
                                 labelPadding:
                                 const EdgeInsets.symmetric(horizontal: 16),
                                 labelColor: Colors.blueAccent,
                                 unselectedLabelColor: Colors.black54,
                                 indicatorColor: Colors.blueAccent,
                                 tabAlignment: TabAlignment.start,
                                 tabs: myTabs,
                               ),
                             ],
                           ),
                         ),
                       ),

                       /// TabBarView content
                       SliverFillRemaining(
                         child: TabBarView(
                           children: [
                             /// Services
                             ListView(
                               physics: NeverScrollableScrollPhysics(),
                               children: [
                                 ProviderRequirementServiceWidget(provider: provider,),
                                 ProviderAllServiceWidget(provider: provider,),
                               ],
                             ),

                             /// Reviews
                             ProviderReviewScreen(providerId: provider.id),

                             /// About
                             Padding(
                               padding: const EdgeInsets.all(10),
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 children: [

                                   // Text('ID: ${provider}', style: textStyle14(context), textAlign: TextAlign.center,),
                                   Text('Name: ${provider.fullName}', style: textStyle14(context, fontWeight: FontWeight.w400)),
                                   Text('Email: ${provider.storeInfo!.storeEmail}', style: textStyle14(context, fontWeight: FontWeight.w400)),
                                   Text('Phone: ${provider.storeInfo!.storePhone}', style: textStyle14(context, fontWeight: FontWeight.w400)),
                                   Text('Address: ${provider.storeInfo!.address}', style: textStyle14(context, fontWeight: FontWeight.w400)),

                                   Divider(),

                                   Text(
                                     "Disclaimer: ${provider.storeInfo?.aboutUs?.isEmpty ?? true ? 'N/A' : provider.storeInfo!.aboutUs}",
                                     style: TextStyle(
                                       fontSize: 14,
                                       color: Colors.grey.shade600,
                                       height: 2,
                                     ),
                                     textAlign: TextAlign.justify,
                                   )
                                 ],
                               ),
                             ),

                             /// Gallery
                             GalleryWidget(providerId: provider.id,)
                           ],
                         ),
                       ),
                     ],
                   );
                 }
                 return SizedBox.shrink();
              }
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileCard({ProviderModel? data, String? moduleName}) {
    return CustomContainer(
      color: Colors.white,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                    radius: 30.5,
                      backgroundColor: CustomColor.appColor,
                      child: CircleAvatar(
                        radius: 30,
                      backgroundImage: (data!.storeInfo!.logo != null &&
                          data!.storeInfo!.logo!.isNotEmpty &&
                          Uri.tryParse(data!.storeInfo!.logo!)?.hasAbsolutePath == true)
                          ? NetworkImage(data!.storeInfo!.logo!)
                          : AssetImage(CustomImage.nullImage) as ImageProvider,
                    ),),
                    5.height,
                    Container(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color:data.isStoreOpen== true? CustomColor.greenColor:Colors.grey.shade500,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Text(data.isStoreOpen== true ?'Open':"Close", style: TextStyle(fontSize: 12, color: CustomColor.whiteColor),))
                  ],
                ),
                10.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.storeInfo!.storeName,style: textStyle12(context),),
                      2.height,
                      Text(
                        '⭐ ${data.averageRating} (${data.totalReviews} Review)',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                      Text(moduleName ?? 'Unknown', style: textStyle12(context,fontWeight: FontWeight.w400)),


                      5.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 2.0),
                            child: Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ),
                          5.width,
                          Expanded(
                            child: Text(
                              'Address: ${data.storeInfo!.address ?? ''}',
                              style: TextStyle(color: Colors.grey.shade700),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// Favorite Button Top Right
          Positioned(
              top: 10,
              right: 10,
              child: FavoriteProviderButtonWidget(providerId: data.id,)
          ),
        ],
      ),
    );
  }
}

/// Sticky TabBar Delegate
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: child);
  }

  @override
  double get maxExtent => 180;

  @override
  double get minExtent => 180;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

ImageProvider _getImageProvider(String? url) {
  if (url != null && url.isNotEmpty) {
    final uri = Uri.tryParse(url);
    if (uri != null && (uri.hasScheme && (uri.isScheme("http") || uri.isScheme("https")))) {
      return NetworkImage(url);
    }
  }
  return AssetImage(CustomImage.nullBackImage);
}