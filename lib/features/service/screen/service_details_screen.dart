import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/widgets/custom_amount_text.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final String image;
   ServiceDetailsScreen({super.key, required this.image,});
  final List<String> labels = ['Overview', 'Pricing', 'Features', 'Reviews', 'FAQs'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Service Details', showBackButton: true, showFavoriteIcon: true,),

      body: SafeArea(
        child:CustomScrollView(
          slivers: [

            /// Banner
            SliverToBoxAdapter(child:  CustomContainer(
              height: 200,
              assetsImg: '$image',
            ),),


            /// Data
            SliverToBoxAdapter(child:_buildData(),),

            /// Index header
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyHeaderDelegate(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder:  (context, index) {
                      return CustomContainer(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          child: Center(child: Text(labels[index], style: TextStyle(fontSize: 12,),)));
                    },
                    itemCount: labels.length),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 10,),),

            SliverToBoxAdapter(
              child: ListView.builder(
              itemCount: 5,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
              return CustomContainer(
                height: 200,
              );
            },),)
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(height: 50,
         // padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: CustomColor.appColor,)
          ),
          child: Row(
            children: [
              Expanded(child: Container(
              child: InkWell(
                onTap: () {
                  print('______________________shared');
                },
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.person_crop_circle_badge_checkmark, color: CustomColor.appColor,),
                    Text('Self Add',style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14,color: CustomColor.appColor)),
                  ],
                ),
              ),)),
              Expanded(child: Container(
                color: CustomColor.appColor,
                height: double.infinity,
                child: InkWell(
                  onTap: () {
                    print('______________________shared');
                    // Share.share('Check out our new product: https://your-link.com');
                  },
                  child: Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.share, color: Colors.white,),
                      Text('Share To Customer',style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14,color: Colors.white)),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      )
    );
  }
}

/// Reusable feature item widget
Widget featureItem(IconData icon, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Icon(icon, color: Colors.green, size: 14,),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(fontSize: 14))),
      ],
    ),
  );
}

Widget _buildData(){
  return  Padding(
    padding: const EdgeInsets.all(15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('App Development', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
        /// Review & Price
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('⭐ 4.8 (120 Reviews)', style: TextStyle(fontSize: 14)),
            CustomAmountText(amount: '150.00',fontSize: 16,fontWeight: FontWeight.w600),
          ],
        ),

        const SizedBox(height: 16),

        /// Description
        Text(
          'Description',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          'This is a sample service description. It explains the benefits and features of the service in detail.',
          style: TextStyle(fontSize: 14),
        ),

        const SizedBox(height: 16),

        /// Features
        Text(
          'Features',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            featureItem(Icons.check, 'Fast delivery within 24 hours'),
            featureItem(Icons.check, 'Money-back guarantee'),
            featureItem(Icons.check, '24/7 Support'),
          ],
        ),
      ],
    ),
  );
}


/// _StickyHeaderDelegate
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: child,
    );
  }

  @override
  double get maxExtent => 40.0;

  @override
  double get minExtent => 40.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}