import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/custom_image.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/core/widgets/custom_favorite_button.dart';
import 'package:bizbooster2x/core/widgets/custom_ratting_and_reviews.dart';
import 'package:bizbooster2x/core/widgets/custom_service_list.dart';
import 'package:bizbooster2x/feature/provider/model/provider_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/provider/provider_bloc.dart';
import '../bloc/provider/provider_event.dart';
import '../bloc/provider/provider_state.dart';
import '../repository/provider_service.dart';
import '../widget/provider_about_widget.dart';
import '../widget/provider_gallery_widget.dart';
import '../widget/provider_reviews_widget.dart';
import '../widget/provider_services_list_widget.dart';

class ProviderDetailsScreen extends StatefulWidget {
  final String? providerId;
  final String? storeName;
  const ProviderDetailsScreen({super.key, this.storeName, this.providerId});

  @override
  State<ProviderDetailsScreen> createState() => _ProviderDetailsScreenState();
}

class _ProviderDetailsScreenState extends State<ProviderDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> myTabs = const [
    Tab(text: 'Services'),
    Tab(text: 'Reviews'),
    Tab(text: 'About'),
    Tab(text: 'Gallery'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: CustomColor.whiteColor,
      appBar: CustomAppBar(
        title: '${widget.storeName??'Store Name'}',
        showBackButton: true,
        showFavoriteIcon: true,
      ),

      body:  SafeArea(
        child: BlocProvider(
          create: (_) => ProviderBloc(ProviderService())..add(GetProvider()),
          child:  BlocBuilder<ProviderBloc, ProviderState>(
            builder: (context, state) {
              if (state is ProviderLoading) {
                return LinearProgressIndicator(backgroundColor: CustomColor.appColor, color: CustomColor.whiteColor ,minHeight: 2.5,);
              }
        
              else if(state is ProviderLoaded){
        
                // final provider = state.providerModel;
                final provider = state.providerModel.where((providerId) =>
                providerId.id == widget.providerId
                ).toList();
        
                if (provider.isEmpty) {
                  return const Center(child: Text('No provider found.'));
                }
        
                final data = provider.first;
                ImageProvider _getProfileImage(String? logoUrl) {
                  if (logoUrl == null || logoUrl.isEmpty || logoUrl == 'null') {
                    return const NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png');
                  }
                  return NetworkImage(logoUrl);
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
                        background:Container(
                          decoration: BoxDecoration(
                              // image: DecorationImage(
                              //     image: _getProfileImage(data.storeInfo.cover)
                              //     ,fit: BoxFit.cover)
                          ),
                        ),
                      ),
                    ),
                
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _StickyHeaderDelegate(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(child: _profileCard(data:data)),
                              TabBar(
                                controller: _tabController,
                                isScrollable: true,
                                labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                                labelColor: Colors.blueAccent,
                                unselectedLabelColor: Colors.black54,
                                indicatorColor: Colors.blueAccent,
                                tabAlignment: TabAlignment.start,
                                tabs: myTabs,
                              )
                            ],
                          )),
                    ),
                
                
                    SliverToBoxAdapter(
                      child:  SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            ProviderServicesListWidget(),
                
                            ProviderReviewsWidget(),
                
                            ProviderAboutWidget(),
                
                            ProviderGalleryWidget()
                          ],
                        ),
                      ),)
                
                
                  ],
                );
        
              }
        
              else if (state is ProviderError) {
                return Center(child: Text(state.errorMessage));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _profileCard({ ProviderModel? data}) {
    ImageProvider _getProfileImage(String? logoUrl) {
      if (logoUrl == null || logoUrl.isEmpty || logoUrl == 'null') {
        return const NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png');
      }
      return NetworkImage(logoUrl);
    }
    return CustomContainer(
     // border: true,
      backgroundColor: Colors.white,
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
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey.shade200,
                  // backgroundImage: _getProfileImage(data!.storeInfo.logo),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text('${data!.fullName ??'Provider Name'}',
                        style: textStyle16(context),
                      ),
                      // Text( "Service: ${data.storeInfo.module.name ?? 'Store Name'}", style: textStyle14(context, fontWeight: FontWeight.w400)),

                      CustomRattingAndReviews(),
                      5.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                         5.width,
                          // Expanded(
                          //   child: Text(
                          //     // 'Address: ${data.storeInfo.address??''}',
                          //     // style: TextStyle(color: Colors.grey.shade700),
                          //     overflow: TextOverflow.ellipsis,
                          //     maxLines: 2,
                          //   ),
                          // ),
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
            top: 0,
            right: 0,
            child: CustomFavoriteButton(),
          ),

          /// Availability Tag Bottom Left
          Positioned(
            bottom: -2,
            left: 8,
            child: CustomContainer(
              border: true,
              borderColor: Colors.green,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.circle, size: 10, color: Colors.green),
                  SizedBox(width: 6),
                  Text(
                    'Available',
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ],
              ),
            ),
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
    return Container(
        color: Colors.white,
        child: child);
  }

  @override
  double get maxExtent => 180;

  @override
  double get minExtent => 180;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}