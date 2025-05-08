import 'package:bizbooster2x/core/costants/custom_color.dart';
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
              floating: true,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background:CustomContainer(
                  margin: EdgeInsets.zero,backgroundColor: Colors.grey.shade200,),
              ),
            ),

            SliverToBoxAdapter(child:  _ProfileCard(),),

            SliverToBoxAdapter(child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelPadding: const EdgeInsets.symmetric(horizontal: 16),
              labelColor: Colors.blueAccent,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.blueAccent,
              tabAlignment: TabAlignment.start,
              tabs: myTabs,
            ),),


            SliverToBoxAdapter(
              child:  SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: TabBarView(
                controller: _tabController,
                children: [
                  ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      CustomServiceList(headline: 'Best Service'),
                      CustomServiceList(headline: 'Popular Service'),
                      CustomServiceList(headline: 'Service'),
                      CustomServiceList(headline: 'All Service'),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text('Headline', style: TextStyle(fontSize: 16, color: CustomColor.appColor),),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 100,
                          width: 200,
                          child: ReviewBarGraph(
                            ratings: {
                              1: 2,
                              2: 4,
                              3: 5,
                              4: 3,
                              5: 6,
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

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
                      return CustomContainer(backgroundColor: Colors.white,);
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
      border: true,
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
