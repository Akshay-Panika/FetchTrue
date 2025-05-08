import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/widgets/custom_amount_text.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/core/widgets/custom_toggle_taps.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String image;

  ServiceDetailsScreen({super.key, required this.image});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen>
    with SingleTickerProviderStateMixin {

  final List<Tab> myTabs = const [
    Tab(text: 'Overview'),
    Tab(text: 'Document'),
    Tab(text: 'How it work'),
    Tab(text: 'T&C'),
    Tab(text: 'FAQs'),
  ];

  int _indexTap = 0;
  int _current = 0;
  late TabController _tabController;


  final List<Map<String, String>> bannerData = [
    {
      'image' : 'assets/image/thumbnail1.png'
    },
    {
      'image' : 'assets/image/thumbnail2.png'
    },
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
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
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
              SliverToBoxAdapter(child: SizedBox(height: 10,),),

              SliverToBoxAdapter(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: CustomToggleTabs(labels: ['Service details', 'Franchise details'], selectedIndex: _indexTap, onTap: (index) {
                 setState(() {
                   _indexTap = index;
                 });
                },),
              ),),

              /// Tab Bar
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyHeaderDelegate(
                  child: Container(
                    color: Colors.transparent,
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelPadding: EdgeInsets.symmetric(horizontal: 20),
                      tabs: myTabs,
                      tabAlignment: TabAlignment.start,
                      labelStyle: TextStyle(fontSize: 12),
                      labelColor: CustomColor.appColor,
                      unselectedLabelColor: Colors.black,
                      indicatorColor: CustomColor.appColor,
                    ),
                  ),
                ),
              ),

              /// tap bar view
              SliverList(
                  delegate: SliverChildListDelegate(
                      [
                Text('''
                       
                            Why do we use it?
                            It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).
                            
                            
                            Where does it come from?
                            Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.
                            
                            The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.
                                                        
                             ''',key: Key('Overview')),
                Text('''
                       
                            Why do we use it?
                            It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).
                            
                            
                            Where does it come from?
                            Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.
                            
                            The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.
                                                        
                             ''',key: Key('Document'),),
                Text('''
                       
                            Why do we use it?
                            It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).
                            
                            
                            Where does it come from?
                            Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.
                            
                            The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.
                                                        
                             ''',key:Key('How it work'),),
                Text('''
                            What is Lorem Ipsum?
                            Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
                            
                            Why do we use it?
                            It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).
                            
                            
                            Where does it come from?
                            Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.
                            
                            The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.
                                                        
                             ''', key: Key('T&C')),
                Text('''
                            What is Lorem Ipsum?
                            Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
                            
                            Why do we use it?
                            It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).
                            
                            
                            Where does it come from?
                            Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.
                            
                            The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.
                                                        
                             ''', key: Key('FAQs'),)
              ]))


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

/// Data Section
Widget _buildData() {
  return Padding(
    padding: const EdgeInsets.all(15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('App Development',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),

        /// Review & Price
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('⭐ 4.8 (120 Reviews)', style: TextStyle(fontSize: 14)),
            CustomAmountText(
                amount: '150.00', fontSize: 16, fontWeight: FontWeight.w600),
          ],
        ),
        SizedBox(height: 16),

        /// Description
        Text('Description',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        Text(
          'This is a sample service description. It explains the benefits and features of the service in detail.',
          style: TextStyle(fontSize: 14),
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
