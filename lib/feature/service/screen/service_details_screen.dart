import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/custom_image.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_amount_text.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_button.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
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

  final List<String> serviceTabs =  [
    'Benefits','Overview','Highlight', 'Document','Why Choose BizBooster','How it work','T&C','FAQs',];

  final  List<String>  franchiseTabs =  [
    'Overview','How it work','T&C',];

  int _indexTap = 0;
  int _current = 0;
  late TabController _tabController;

  final List<Map<String, String>> bannerData = [
    {'image': 'assets/image/thumbnail1.png'},
    {'image': 'assets/image/thumbnail2.png'},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Service Details',
        showBackButton: true,
        showFavoriteIcon: true,
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
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
                              borderRadius: false,
                              margin: EdgeInsets.zero,
                            );
                          },
                        );
                      }).toList(),
                    ),


                    10.height,
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
              SliverToBoxAdapter(child: SizedBox(height: 10,),),

              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: _StickyHeaderDelegate(
                    child: SizedBox(height: 50,
                      child: TabBar(
                          tabs: [
                        Tab(text: 'Service Details',),
                        Tab(text: 'Franchise Details',),
                      ],
                        labelStyle: textStyle14(context, color: CustomColor.appColor),
                         indicatorColor: CustomColor.appColor,
                        unselectedLabelColor: CustomColor.descriptionColor,
                        onTap: (value) {
                          setState(() {
                            _indexTap = value;
                          });
                        },
                      ),
                    ),),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 10,),),

              SliverToBoxAdapter(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _indexTap == 0
                      ? _buildServiceSection(serviceTabs: serviceTabs)
                      : _buildFranchiseSection(serviceTabs: franchiseTabs),
                ),
              ),

            ],
          ),
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
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      // ),
                      builder: (context) {
                        return SizedBox(
                          height: 500,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: CustomColor.whiteColor,
                                    child: Icon(Icons.close),),
                                ),
                              ),
                             
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                    ),
                                    color: CustomColor.whiteColor
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Row(
                                          children: [
                                            CustomContainer(
                                              height: 45,width: 45,
                                              assetsImg: CustomImage.nullImage,),
                                            20.width,
                                            Expanded(child: CustomButton(text: 'Process To',))
                                          ],
                                        ),
                                      ),
                                                        
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
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
    );
  }
}

Widget _buildServiceSection({required List<String> serviceTabs}) {
  return Column(
    children: [
      CustomContainer(
        border: true,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        backgroundColor: Colors.white,
        // backgroundColor: CustomColor.appColor.withOpacity(0.09),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('App Development', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            5.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomAmountText(
                      amount: '350.00',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                      isLineThrough: true
                    ),
                    SizedBox(width: 10),
                    CustomAmountText(
                      amount: '250.00',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                Text('⭐ 4.8 (120 Reviews)', style: TextStyle(fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
      _buildCard(serviceTabs: serviceTabs),
    ],
  );
}

Widget _buildFranchiseSection({required List<String> serviceTabs}) {
  return Column(
    children: [
      CustomContainer(
        border: true,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        backgroundColor: CustomColor.whiteColor,
        // backgroundColor: CustomColor.appColor.withOpacity(0.09),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You will earn commission',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: CustomColor.appColor,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Up To',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CustomAmountText(
                        amount: '00.00',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.wallet, size: 50, color: Colors.blue),
          ],
        ),
      ),
      _buildCard(serviceTabs: serviceTabs),
    ],
  );
}





Widget _buildCard({required List<String> serviceTabs}){
  return  ListView.builder(
    itemCount: serviceTabs.length,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemBuilder: (context, index) {
      return
        CustomContainer(
        border: true,
        backgroundColor: Colors.white,
        child:
        index == 4 ?  _buildWCB(context):
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            0.height,
            Text(serviceTabs[index],style: textStyle14(context),),

           Text(
              'This is HTML Paragraph',
              style: TextStyle(fontSize: 14,color: CustomColor.descriptionColor),
            ),

          ],
        ),
      );
    },
  );
}

Widget _buildWCB(BuildContext context){
  return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
    children: [
        Text('Why Choose BizBooster', style: textStyle14(context),),

        ListView.builder(
          itemCount: 3,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
             return CustomContainer(
               border: true,
               height: 100,
               margin: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         Text('Headline', style: textStyle14(context),),
                         Text('Declaimer', style: textStyle12(context, color: CustomColor.descriptionColor),),
                       ],
                     ),
                   ),

                   Expanded(
                     child: CustomContainer(
                       margin: EdgeInsets.zero,
                       assetsImg: CustomImage.thumbnailImage,
                     ),
                   )
                 ],
               ),
             );
        },)
    ],
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
        color: Colors.white,
        child: child);
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

