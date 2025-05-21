import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../costants/custom_color.dart';
import '../costants/text_style.dart';
import 'custom_container.dart';
import 'custom_favorite_button.dart';

class CustomHighlightService extends StatefulWidget {
  const CustomHighlightService({super.key});

  @override
  State<CustomHighlightService> createState() => _CustomHighlightServiceState();
}

class _CustomHighlightServiceState extends State<CustomHighlightService> {

  int _current = 0;

  final List<Map<String, String>> bannerData = [
    {
      'image' : 'assets/image/thumbnail1.png'
    },
    {
      'image' : 'assets/image/thumbnail2.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Highlight For You', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),

        Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 250,
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
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomContainer(
                            width: double.infinity,
                            assetsImg: data['image'],
                            padding: EdgeInsets.zero,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomFavoriteButton(),
                                  Container(
                                      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        color: CustomColor.blackColor.withOpacity(0.3),
                                      ),
                                      child: Text('⭐ 4.8 (120 Reviews)', style: textStyle12(context, color: CustomColor.whiteColor, fontWeight: FontWeight.w400))),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Service Name', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                            Text('Service Description', style: TextStyle(fontSize: 14, color: Colors.grey.shade700),),
                          ],
                        ),
                        SizedBox(height: 15,)
                      ],
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
        )
      ],
    ),);
  }
}
