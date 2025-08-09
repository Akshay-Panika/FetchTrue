import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/provider/bloc/provider_by_id/provider_by_id_bloc.dart';
import 'package:fetchtrue/feature/provider/bloc/provider_by_id/provider_by_id_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_favorite_button.dart';
import '../bloc/provider_by_id/provider_by_id_event.dart';
import '../model/provider_model.dart';
import '../repository/provider_by_id_service.dart';
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
        title: widget.storeName ?? 'Store Name',
        showBackButton: true,
        showFavoriteIcon: true,
      ),

      body:  SafeArea(
        child: BlocProvider(
          create: (_) => ProviderByIdBloc(ProviderByIdService())..add(GetProviderByIdEvent(widget.providerId.toString())),
          child:  BlocBuilder<ProviderByIdBloc, ProviderByIdState>(
            builder: (context, state) {
              if (state is ProviderLoading) {
                return LinearProgressIndicator(backgroundColor: CustomColor.appColor, color: CustomColor.whiteColor ,minHeight: 2.5,);
              }

              else if(state is ProviderLoaded){

                final data = state.provider;

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
                            image: DecorationImage(image: NetworkImage(data.storeInfo!.cover ??''), fit: BoxFit.fill)
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
                            ProviderServicesListWidget(data: data,),

                            ProviderReviewsWidget(providerId: data.id,),

                            ProviderAboutWidget(providerId: data.id,),

                            ProviderGalleryWidget(providerId: data.id,)
                          ],
                        ),
                      ),)

                  ],
                );

              }

              else if (state is ProviderError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _profileCard({ ProviderModel? data}) {
    return CustomContainer(
     // border: true,
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
                      backgroundColor: const Color(0xFFF2F2F2),
                      backgroundImage: NetworkImage(data!.storeInfo!.logo.toString()),
                    ),
                    CustomContainer(
                        color: CustomColor.appColor,
                        margin: EdgeInsets.zero,
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                        child: Text('Open', style: textStyle12(context, color: CustomColor.whiteColor),))
                  ],
                ),
                10.width,

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(data.storeInfo!.storeName,
                        style: textStyle16(context),
                      ),
                      Text( "Module Name", style: textStyle14(context, fontWeight: FontWeight.w400)),

                      Text(
                        '⭐ ${data.averageRating} (${data.totalReviews} Review)',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
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
                          Expanded(
                            child: Text(
                              'Address: ${data.storeInfo!.address??''}',
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
            top: 0,
            right: 0,
            child: CustomFavoriteButton(),
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