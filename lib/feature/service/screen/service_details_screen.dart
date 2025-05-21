import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/custom_image.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_amount_text.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_button.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/core/widgets/custom_favorite_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../service_provider/screen/service_provider_screen.dart';
import '../widget/self_add_widget.dart';
import '../widget/service_review_widget.dart';


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
      // backgroundColor: Colors.white,
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
                child: Container(
                  color: CustomColor.whiteColor,
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
                      10.height,
                    ],
                  ),
                ),
              ),


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
                        dividerColor: CustomColor.greyColor,
                        dividerHeight: 0.2,
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
                      ? _buildServiceSection(context,serviceTabs: serviceTabs)
                      : _buildFranchiseSection(serviceTabs: franchiseTabs),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 50,),)

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
                    showCustomBottomSheet(context,Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(radius: 40,
                                backgroundImage: AssetImage(CustomImage.nullImage),),
                              10.height,
                              Text('Available Providers', style: textStyle14(context),),
                              Text('0 Provider available ', style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),),
                            ],
                          ),
                          10.height,

                          CustomContainer(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(backgroundImage: AssetImage(CustomImage.nullImage),),
                                    20.width,
                                    Text('Let Bizbooster choose for you', style: textStyle14(context, color: CustomColor.appColor),),
                                  ],
                                ),

                                Icon(CupertinoIcons.check_mark_circled, color: CustomColor.greenColor,)
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomButton(text: 'Conform',
                            onTap: () {
                              Navigator.pop(context);
                            },),
                          ),

                        ],
                      ),
                    ));
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

Widget _buildServiceSection(BuildContext context,{required List<String> serviceTabs}) {
  return Column(
    children: [
      Stack(
        children: [
          CustomContainer(
            border: true,
            borderColor: CustomColor.greyColor,
            backgroundColor: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('App Development', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),

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
                    InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceReviewWidget(),));
                        },
                        child: Text('⭐ 4.8 (120 Reviews)', style: TextStyle(fontSize: 14))),
                  ],
                ),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('Keys :', style: textStyle12(context),),
                        5.width,
                        Text('value',style: textStyle12(context),),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Keys :', style: textStyle12(context),),
                        5.width,
                        Text('value',style: textStyle12(context),),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
              top: 0,right: 10,
              child: CustomFavoriteButton())
        ],
      ),
      _buildServiceCard(serviceTabs: serviceTabs),
    ],
  );
}

Widget _buildFranchiseSection({required List<String> serviceTabs}) {
  return Column(
    children: [
      CustomContainer(
        border: true,
        borderColor: CustomColor.greyColor,
        backgroundColor: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
      _buildFranchiseCard(serviceTabs: serviceTabs),
    ],
  );
}


Widget _buildServiceCard({required List<String> serviceTabs}){
  return  ListView.builder(
    itemCount: serviceTabs.length,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemBuilder: (context, index) {
      return
        CustomContainer(
        border: true,
        borderColor: CustomColor.greyColor,
        backgroundColor: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child:
        index == 4 ?
        _buildWCB(context):
        index == 2 ?
        _buildHighlight(context):
        index == 7 ?
        _buildFAQs(context):
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
Widget _buildFranchiseCard({required List<String> serviceTabs}){
  return  ListView.builder(
    itemCount: serviceTabs.length,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemBuilder: (context, index) {
      return
        CustomContainer(
          border: true,
          borderColor: CustomColor.greyColor,
          backgroundColor: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
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


/// WCB
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

/// Highlight Section
Widget _buildHighlight(BuildContext context){
  return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
    children: [
        Text('Highlight', style: textStyle14(context),),

       CustomContainer(
         height: 100,
         width: double.infinity,
         margin: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
         child: Center(child: Text('Log Banner')),
       )
    ],
  );
}

/// FAQs Section
Widget _buildFAQs(BuildContext context) {
  final List<Map<String, String>> faqData = [
    {
      'question': 'What is your return policy?',
      'answer': 'You can return items within 30 days of purchase.'*3
    },
    {
      'question': 'How can I track my order?',
      'answer': 'Use the tracking ID sent to your registered email.'*2
    },
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('FAQs', style: textStyle14(context)),
      ListView.builder(
        itemCount: faqData.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return ExpansionTile(
            shape: InputBorder.none,
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            title: Text(faqData[index]['question'] ?? '',
                style: textStyle14(context)),
            children: [
              Text(faqData[index]['answer'] ?? ''),
            ],
          );
        },
      ),
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

