import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/custom_image.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/core/widgets/custom_favorite_button.dart';
import 'package:bizbooster2x/core/widgets/custom_service_list.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: Colors.white,
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
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: _ProfileCard()),
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
                    ),
                  )),
            ),


            SliverToBoxAdapter(
              child:  SizedBox(
                height: MediaQuery.of(context).size.height,
                child: TabBarView(
                controller: _tabController,
                children: [
                  ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: 10,),
                      CustomServiceList(headline: 'Best Service'),
                      CustomServiceList(headline: 'Popular Service'),
                      CustomServiceList(headline: 'Service'),
                      CustomServiceList(headline: 'All Service'),
                    ],
                  ),

                  Reviews(),

                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('''Where does it come from?
                        Contrary to popular belief, Lorem Ipsvrbj j  xiuefcuig4g buobe2h0hqr  g3ribr3oi biwehgih3gn   brnbri um is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.'''),
                      )
                    ],
                  ),

                  GridView.builder(
                    itemCount: 5,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return CustomContainer(border: true,
                        backgroundColor: Colors.white,
                      );
                    },)
                ],
                            ),
              ),)


          ],
        ),
      ),
    );
  }

  Widget _ProfileCard() {
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
                  child: const Icon(Icons.person, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Provider Name',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '4.2',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 10),
                          Text(
                            'Reviews',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
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



class ReviewBarGraph extends StatelessWidget {
  final Map<int, int> ratings; // Example: {1: 2, 2: 4, 3: 5, 4: 3, 5: 6}

  const ReviewBarGraph({super.key, required this.ratings});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: CustomPaint(
        painter: _BarGraphPainter(ratings),
      ),
    );
  }
}

class _BarGraphPainter extends CustomPainter {
  final Map<int, int> ratings;
  _BarGraphPainter(this.ratings);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final barWidth = size.width / (ratings.length * 2); // spacing

    final maxValue = ratings.values.reduce((a, b) => a > b ? a : b);

    int index = 0;
    ratings.forEach((star, value) {
      final x = barWidth + index * 2 * barWidth;
      final barHeight = (value / maxValue) * size.height;
      final y = size.height - barHeight;

      paint.color = Colors.blueAccent;

      // Draw bar
      canvas.drawRect(Rect.fromLTWH(x, y, barWidth, barHeight), paint);

      // Draw label
      final textPainter = TextPainter(
        text: TextSpan(
          text: '$star⭐',
          style: const TextStyle(color: Colors.black, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(x + barWidth / 2 - textPainter.width / 2, size.height + 5));

      index++;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


class Reviews extends StatelessWidget {
  final List<Map<String, dynamic>> reviews = [
    {
      "name": "Anika Srishty",
      "rating": 5.0,
      "comment": "Your service is excellent",
      "date": "23 Jan, 2023",
    },
    {
      "name": "Anika Srishty",
      "rating": 5.0,
      "comment": "Great job",
      "date": "23 Jan, 2023",
    },
    {
      "name": "Anika Srishty",
      "rating": 5.0,
      "comment": "Great services",
      "date": "23 Jan, 2023",
    },
    {
      "name": "Anika Srishty",
      "rating": 4.0,
      "comment": "Excellent service",
      "date": "23 Jan, 2023",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ratingSummary(),
        SizedBox(height: 20),
        Padding(
         padding: EdgeInsets.only(left: 15),
          child: Text("4 Reviews", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ),
        SizedBox(height: 10),
        ...reviews.map((review) => reviewCard(review)).toList(),
      ],
    );
  }

  Widget ratingSummary() {
    return CustomContainer(
      backgroundColor: Colors.transparent,
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 16,),
              SizedBox(width: 4),
              Text("4.75 / 5", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              Spacer(),
              Text("4 Ratings", style: TextStyle(color: Colors.grey.shade700)),
            ],
          ),
          SizedBox(height: 10),
          ratingBar("Excellent", 3),
          ratingBar("Good", 1),
          ratingBar("Average", 0),
          ratingBar("Below Average", 0),
          ratingBar("Poor", 0),
        ],
      ),
    );
  }

  Widget ratingBar(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: TextStyle(fontSize: 14),)),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 3,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
              minHeight: 6,
            ),
          ),
          SizedBox(width: 10),
          Text(value.toString()),
        ],
      ),
    );
  }

  Widget reviewCard(Map<String, dynamic> review) {
    return CustomContainer(
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.symmetric(vertical: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(CustomImage.nullImage), // Replace with your own image or use NetworkImage
            radius: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(review['name'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                    Spacer(),
                    Text(review['date'], style: TextStyle(color: Colors.grey.shade700,fontSize: 14)),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Row(
                      children: List.generate(5,
                            (index) => Icon(
                               index < review['rating'].round()
                              ? Icons.star
                              : Icons.star_border, size: 14, color: Colors.blue,),
                      ),
                    ),
                    SizedBox(width: 5,),
                    Text('4.0')
                  ],
                ),
                SizedBox(height: 4),
                Text(review['comment'], style: TextStyle(fontSize: 12),),
              ],
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