import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_favorite_button.dart';
import '../../favorite/widget/favorite_provider_button_widget.dart';
import '../bloc/provider/provider_bloc.dart';
import '../bloc/provider/provider_event.dart';
import '../bloc/provider/provider_state.dart';
import '../model/provider_model.dart';
import '../repository/provider_repository.dart';
import '../widget/gallery_widget.dart';
import '../widget/provider_all_service_widget.dart';
import '../widget/provider_requirement_service_widget.dart';
import '../widget/provider_review_widget.dart';

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
    return Scaffold(

      appBar: CustomAppBar(
        title: widget.storeName ?? 'Store Name',
        showBackButton: true,
        showFavoriteIcon: false,
      ),
      body: DefaultTabController(
        length: myTabs.length,
        child: BlocProvider(
          create: (_) => ProviderBloc(ProviderRepository())
            ..add(GetProviderById(widget.providerId!)),
          child: BlocBuilder<ProviderBloc, ProviderState>(
            builder: (context, state) {
              if (state is ProviderLoading) {
                return  Center(child: CircularProgressIndicator( color: CustomColor.appColor,));
              } else if (state is ProviderLoaded) {
                final provider = state.provider;

                return CustomScrollView(
                  slivers: [
                    /// Cover Image
                    if(provider.storeInfo!.cover != null)
                    SliverAppBar(
                      toolbarHeight: 200,
                      pinned: false,
                      floating: false,
                      automaticallyImplyLeading: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: provider.storeInfo!.cover == null ? AssetImage(CustomImage.nullBackImage):
                              NetworkImage(provider.storeInfo!.cover ?? ''), fit: BoxFit.fill,),
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
                            Center(child: _profileCard(data: provider)),
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
                              ProviderRequirementServiceWidget(moduleId: provider.storeInfo!.module.toString(),),
                              ProviderAllServiceWidget(moduleId: provider.storeInfo!.module.toString(),),
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
                                  "Disclaimer: The information provided about this provider, "
                                      "including services, pricing, reviews, and gallery, is sourced "
                                      "from the provider or public data. While we strive to ensure "
                                      "accuracy, FetchTrue does not guarantee completeness, reliability, "
                                      "or availability of this information. Please verify details directly "
                                      "with the provider before making any decisions.",
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
              } else if (state is ProviderError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _profileCard({ProviderModel? data}) {
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
                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: CustomColor.greyColor.withOpacity(0.2),
                      backgroundImage: (data!.storeInfo!.logo != null &&
                          data!.storeInfo!.logo!.isNotEmpty &&
                          Uri.tryParse(data!.storeInfo!.logo!)?.hasAbsolutePath == true)
                          ? NetworkImage(data!.storeInfo!.logo!)
                          : AssetImage(CustomImage.nullImage) as ImageProvider,
                    ),
                    CustomContainer(
                      color: CustomColor.appColor,
                      margin: EdgeInsets.zero,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'Open',
                        style: textStyle12(context,
                            color: CustomColor.whiteColor),
                      ),
                    ),
                  ],
                ),
                10.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.storeInfo!.storeName,
                        style: textStyle16(context),
                      ),
                      Text("Module Name",
                          style: textStyle14(context,
                              fontWeight: FontWeight.w400)),
                      Text(
                        '⭐ ${data.averageRating} (${data.totalReviews} Review)',
                        style:
                        const TextStyle(fontSize: 12, color: Colors.black),
                      ),
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
