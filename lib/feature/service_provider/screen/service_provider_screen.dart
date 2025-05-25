import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/custom_image.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/core/widgets/custom_favorite_button.dart';
import 'package:bizbooster2x/core/widgets/custom_ratting_and_reviews.dart';
import 'package:bizbooster2x/core/widgets/custom_service_list.dart';
import 'package:flutter/material.dart';

import '../widget/provider_about_widget.dart';
import '../widget/provider_gallery_widget.dart';
import '../widget/provider_reviews_widget.dart';
import '../widget/provider_services_list_widget.dart';

class ServiceProviderScreen extends StatefulWidget {
  const ServiceProviderScreen({super.key});

  @override
  State<ServiceProviderScreen> createState() => _ServiceProviderScreenState();
}

class _ServiceProviderScreenState extends State<ServiceProviderScreen>
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
        title: 'Provider',
        showBackButton: true,
        showFavoriteIcon: true,
      ),
      body: SafeArea(
        child:  CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: 200,
              pinned: false,
              floating: false,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background:Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(CustomImage.thumbnailImage),fit: BoxFit.cover)
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
                      Center(child: _profileCard()),
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
        ),
      ),
    );
  }

  Widget _profileCard() {
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
                  backgroundImage: AssetImage(CustomImage.nullImage),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        'Akshay Panika',
                        style: textStyle14(context),
                      ),

                      CustomRattingAndReviews(),
                      5.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Address: Waidhan Singrauli, Madhya Pradesh, Pin - 488686',
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