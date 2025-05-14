import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/custom_image.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/widgets/custom_favorite_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_headline.dart';
import '../screen/service_provider_screen.dart';

class ServiceProviderWidget extends StatefulWidget {
  const ServiceProviderWidget({super.key});

  @override
  State<ServiceProviderWidget> createState() => _ServiceProviderWidgetState();
}

class _ServiceProviderWidgetState extends State<ServiceProviderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColor.appColor.withOpacity(0.08),
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomHeadline(headline: 'Service Provider'),

          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 20),
            child: CarouselSlider.builder(
              itemCount: 3,
              itemBuilder: (context, index, realIndex) {
                return CustomContainer(
                  width: double.infinity,
                  backgroundColor: Colors.white,
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceProviderScreen(),)),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                               CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xFFF2F2F2),
                                backgroundImage: AssetImage(CustomImage.nullImage),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Provider Name',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        '4.5 (1)',
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                          10.height,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on_outlined, size: 16),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Address: Waidhan, Singrauli, Madhya Pradesh - 486886',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Positioned(
                        top: 0,
                        right: 0,
                        child: CustomFavoriteButton(),
                      ),
                    ],
                  ),
                );
              },
              options: CarouselOptions(
                height: 150,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.80,
                padEnds: true,
                // pageSnapping: false,
                autoPlayInterval: const Duration(seconds: 5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
