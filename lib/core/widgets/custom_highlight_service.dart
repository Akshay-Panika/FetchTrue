import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';

import '../../feature/ads/model/add_model.dart';
import '../../feature/ads/repository/ads_repsitory.dart';



class CustomHighlightService extends StatefulWidget {
  const CustomHighlightService({super.key});

  @override
  State<CustomHighlightService> createState() => _CustomHighlightServiceState();
}

class _CustomHighlightServiceState extends State<CustomHighlightService> {
  int _current = 0;
  List<AdData> ads = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAds();
  }

  Future<void> loadAds() async {
    try {
      final data = await AdsService.getAds();
      setState(() {
        ads = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching ads: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Highlight For You',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ads.isEmpty
              ? const Text("No ads available.")
              : Column(
            children: [
              CarouselSlider.builder(
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
                itemCount: ads.length,
                itemBuilder: (context, index, realIndex) {
                  final ad = ads[index];
                  return CustomContainer(
                    border: true,
                    padding: EdgeInsets.zero,
                    backgroundColor: CustomColor.whiteColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomContainer(
                            width: double.infinity,
                            networkImg: ad.service.thumbnailImage,
                            padding: EdgeInsets.zero,
                            margin: EdgeInsets.zero,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ad.service.serviceName,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                ad.description,
                                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              5.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(ads.length, (index) {
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
        ],
      ),
    );
  }
}
