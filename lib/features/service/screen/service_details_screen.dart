import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/widgets/custom_amount_text.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/core/widgets/custom_headline.dart';
import 'package:bizbooster2x/core/widgets/custom_toggle_taps.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'demo.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String image;

  ServiceDetailsScreen({super.key, required this.image});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen>
    with SingleTickerProviderStateMixin {

  final List<Tab> myServiceTabs = const [
    Tab(text: 'Overview'),
    Tab(text: 'Document'),
    Tab(text: 'How it work'),
    Tab(text: 'T&C'),
    Tab(text: 'FAQs'),
  ];
  final List<Tab> myFranchiseTabs = const [
    Tab(text: 'Overview'),
    Tab(text: 'How it work'),
    Tab(text: 'T&C'),
    Tab(text: 'FAQs'),
  ];

  int _indexTap = 0;
  int _current = 0;
  late TabController _tabController;


  final List<Map<String, String>> bannerData = [
    {'image': 'assets/image/thumbnail1.png'},
    {'image': 'assets/image/thumbnail2.png'},
  ];

  @override
  void initState() {
    super.initState();
    _updateTabController();
  }

  void _updateTabController() {
    if (mounted) {
      _tabController = TabController(
        length: _indexTap == 0 ? myServiceTabs.length : myFranchiseTabs.length,
        vsync: this,
      );
    }
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _indexTap ==0 ? myServiceTabs.length : myFranchiseTabs.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Service Details',
          showBackButton: true,
          showFavoriteIcon: true,
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [

              /// Banner
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 200,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 1,
                        autoPlayInterval: const Duration(seconds: 4),
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                      items: bannerData.map((data) {
                        return Builder(
                          builder: (BuildContext context) {
                            return CustomContainer(
                              width: double.infinity,
                              assetsImg: data['image'],
                            );
                          },
                        );
                      }).toList(),
                    ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(bannerData.length, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          height: 5,
                          width: _current == index ? 24 : 10,
                          decoration: BoxDecoration(
                            color: _current == index ? Colors.blueAccent : Colors.grey,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              /// Data
              SliverToBoxAdapter(child: _buildData()),

              SliverToBoxAdapter(child:_buildBenefits(),),
              SliverToBoxAdapter(child: SizedBox(height: 10,),),

              /// Toggle Tabs
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: CustomToggleTabs(
                    labels: ['Service details', 'Franchise details'],
                    selectedIndex: _indexTap,
                    onTap: (index) {
                      setState(() {
                        _indexTap = index;
                        // _tabController.dispose();
                        // _updateTabController();
                      });
                    },

                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 10,),),

              /// Tab Bar
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyHeaderDelegate(
                  child: Container(
                    color: Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelPadding: EdgeInsets.symmetric(horizontal: 20),
                      tabs: _indexTap == 0 ? myServiceTabs : myFranchiseTabs,
                      tabAlignment: TabAlignment.start,
                      labelStyle: TextStyle(fontSize: 12),
                      labelColor: CustomColor.appColor,
                      unselectedLabelColor: Colors.black,
                      indicatorColor: CustomColor.appColor,
                    ),
                  ),
                ),
              ),

              /// tap bar view scroll vertical
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height, // Adjust height based on content
                  child: TabBarView(
                    controller: _tabController,
                    children:
                    _indexTap == 0 ? [
                      OverviewTab(),
                      DocumentTab(),
                      HowItWorksTab(),
                      TermsTab(),
                      FaqTab(),
                    ]
                    :[
                      OverviewTab(),
                      HowItWorksTab(),
                      TermsTab(),
                      FaqTab(),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: CustomColor.appColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      print('Self Add tapped');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.person_crop_circle_badge_checkmark,
                            color: CustomColor.appColor),
                        SizedBox(width: 6),
                        Text(
                          'Self Add',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: CustomColor.appColor),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: CustomColor.appColor,
                    height: double.infinity,
                    child: InkWell(
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeDemo(),));
                        print('Shared to customer');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.share, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            'Share To Customer',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




Widget _buildBenefits(){
  List _benefits = [
    'It is a long established fact that a reader will be distraoking at its layout',
    'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout',
    'It is a long established fact that a when looking at its layout',
    'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout',
    'It is a long established fact of a page when looking at its layout',
  ];
  return CustomContainer(
    border: true,
    backgroundColor: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Text('Benefits :', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),

        ListView.builder(
          itemCount: _benefits.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Padding(
                 padding: const EdgeInsets.only(top: 5.0),
                 child: Icon(Icons.circle, color: CustomColor.iconColor.withOpacity(0.5), size: 13, ),
               ),
                SizedBox(width: 5,),
                Expanded(child: Text(_benefits[index], style: TextStyle(fontSize: 14, color: Colors.grey.shade700),)),
              ],
            ),
          );
        },),
        
        
      ],
    ),
  );
}

/// Data Section
Widget _buildData() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        Text('App Development',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),

        /// Review & Price
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomAmountText(
                amount: '150.00', fontSize: 14, fontWeight: FontWeight.w600),
            Text('⭐ 4.8 (120 Reviews)', style: TextStyle(fontSize: 14)),
          ],
        ),
       
      ],
    ),
  );
}

/// Sticky TabBar Delegate
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: Colors.grey.shade100,
        child: child);
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
// Overview Tab Widget
class OverviewTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Text(
        'all applicable rules and regulaticy, and dispute resolution. It is impor'*70,
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}

// Document Tab Widget
class DocumentTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Text(
        'all applicable rules and regulaticy, and dispute resolution. It is impor'*80,
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}

// How It Works Tab Widget
class HowItWorksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Text(
        'all applicable rules and regulaticy, and dispute resolution. It is impor'*100,
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}

// Terms & Conditions Tab Widget
class TermsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Text(
        'all applicable rules and regulaticy, and dispute resolution. It is impor'*50,
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}

// FAQs Tab Widget
class FaqTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Text(
        'all applicable rules and regulaticy, and dispute resolution. It is impor'*50,
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}
