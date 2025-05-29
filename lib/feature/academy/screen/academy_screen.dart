import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/widgets/custom_banner.dart';
import 'package:bizbooster2x/feature/academy/screen/recorded_webinar_screen.dart';
import 'package:bizbooster2x/feature/academy/screen/two_min_gyan_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_headline.dart';
import '../widget/academy_banner_widget.dart';
import 'certificate_screen.dart';
import 'document_screen.dart';
import 'live_webinar_screen.dart';

class AcademyScreen extends StatelessWidget {
  const AcademyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dimensions helper (optional, if you use it for responsive spacing)
    final Dimensions dimensions = Dimensions(context);

    final List<Map<String, dynamic>> _services = [
      {
        'title': 'Certificate',
        'icon': Icons.verified,
        'screenBuilder': () => CertificateScreen(),
      },
      {
        'title': '2 Min. Gyan',
        'icon': Icons.lightbulb_outline,
        'screenBuilder': () => TwoMinGyanScreen(),
      },
      {
        'title': 'Live Webinar',
        'icon': Icons.wifi,
        'screenBuilder': () => LiveWebinarScreen(),
      },
      {
        'title': 'Recorded Webinar',
        'icon': Icons.video_library,
        'screenBuilder': () => RecordedWebinarScreen(),
      },
      {
        'title': 'Documents',
        'icon': Icons.insert_drive_file,
        'screenBuilder': () => DocumentScreen(),
      },
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Academy',
        showNotificationIcon: true,
      ),
      body: Column(
        children: [
          /// Banner Section
          const AcademyBannerWidget(),

          /// Tutorials Headline and Grid
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeadline(
                headline: 'Tutorials',
                viewSeeAll: false,
              ),


              /// Grid of services
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _services.length,
                padding: EdgeInsets.symmetric(horizontal: 15),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.11 / 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final item = _services[index];

                  return CustomContainer(
                    border: true,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    onTap: () {
                      final screenBuilder = item['screenBuilder'] as Widget Function();
                      if (screenBuilder != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => screenBuilder()),
                        );
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomContainer(
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              item['icon'] as IconData,
                              size: 30,
                              color: CustomColor.appColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: Text(
                            item['title'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// Flexible empty container (can be used for footer or other content)
          const Expanded(
            child: CustomContainer(
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
