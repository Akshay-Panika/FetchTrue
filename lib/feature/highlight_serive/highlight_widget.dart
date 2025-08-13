import 'package:carousel_slider/carousel_slider.dart';
import 'package:fetchtrue/feature/highlight_serive/repository.dart';
import 'package:fetchtrue/feature/service/screen/service_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../ads/model/add_model.dart';
import '../ads/repository/ads_repsitory.dart';
import 'bloc/ads_bloc.dart';
import 'bloc/ads_event.dart';
import 'bloc/ads_state.dart';



class HighlightServiceWidget extends StatefulWidget {
  const HighlightServiceWidget({super.key});

  @override
  State<HighlightServiceWidget> createState() => _HighlightServiceWidgetState();
}

class _HighlightServiceWidgetState extends State<HighlightServiceWidget> {
  int _current = 0;


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdsBloc(AdsRepository())..add(LoadAdsEvent()),
      child: BlocBuilder<AdsBloc, AdsState>(
        builder: (context, state) {
          if (state is AdsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AdsLoaded) {
            final adsList = state.ads.data;
            return Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Highlight For You', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  Column(
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
                        itemCount: adsList.length,
                        itemBuilder: (context, index, realIndex) {
                          final ads = adsList[index];
                          return CustomContainer(
                            border: true,
                            padding: EdgeInsets.zero,
                            color: CustomColor.whiteColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: CustomContainer(
                                    width: double.infinity,
                                    padding: EdgeInsets.zero,
                                    margin: EdgeInsets.zero,
                                    networkImg: ads.fileUrl,
                                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailsScreen(serviceId: ads.service.id),)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ads.title,
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        ads.description,
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
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: List.generate(ads.length, (index) {
                      //     return AnimatedContainer(
                      //       duration: const Duration(milliseconds: 300),
                      //       margin: const EdgeInsets.symmetric(horizontal: 3),
                      //       height: 5,
                      //       width: _current == index ? 24 : 10,
                      //       decoration: BoxDecoration(
                      //         color: _current == index ? Colors.blueAccent : Colors.grey,
                      //         borderRadius: BorderRadius.circular(2),
                      //       ),
                      //     );
                      //   }),
                      // ),
                    ],
                  )
                ],
              ),
            );
          } else if (state is AdsError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Center(child: Text('Press button to load ads'));
        },
      ),
    );
  }
}
