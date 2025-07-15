import 'package:fetchtrue/feature/academy/screen/recorded_webinar_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_headline.dart';
import '../../advisers/screen/adviser_screen.dart';
import '../widget/academy_banner_widget.dart';
import 'training_tutorial_screen.dart';
import 'document_screen.dart';
import 'live_webinar_screen.dart';

class AcademyScreen extends StatelessWidget {
  const AcademyScreen({super.key});

  final String channelId = 'UCKpwgpO9-c_ISAJzNxgHkUw';

  Future<void> _openShorts() async {
    final Uri youtubeAppUrl = Uri.parse('youtube://www.youtube.com/channel/$channelId/shorts');
    final Uri youtubeWebUrl = Uri.parse('https://www.youtube.com/channel/$channelId/shorts');

    if (await canLaunchUrl(youtubeAppUrl)) {
      await launchUrl(youtubeAppUrl);
    } else if (await canLaunchUrl(youtubeWebUrl)) {
      await launchUrl(youtubeWebUrl);
    } else {
      throw 'Could not launch YouTube Shorts';
    }
  }


  @override
  Widget build(BuildContext context) {
    final Dimensions dimensions = Dimensions(context);

    final List<Map<String, dynamic>> _services = [
      {
        'title': 'Training Tutorial',
        'icon': Icons.verified,
        'screenBuilder': () => TrainingTutorialScreen(),
      },
      {
        'title': '2 Min. Gyan',
        'icon': Icons.lightbulb_outline,
        'screenBuilder': _openShorts,
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
                    onTap: () async {
                      final screenBuilder = item['screenBuilder'];

                      if (screenBuilder is Widget Function()) {
                        // Navigate normally
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => screenBuilder()),
                        );
                      } else if (screenBuilder is Function) {
                        // Call function (like _openShorts)
                        await screenBuilder();
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

           SizedBox(height: dimensions.screenHeight*0.02),

          /// Flexible empty container (can be used for footer or other content)
          CustomContainer(
            height: 200,
            border: true,
            backgroundColor: Colors.green.shade50,
            width: double.infinity,
            networkImg: 'https://template.canva.com/EAGCux6YcJ8/1/0/1600w-pxaBUxBx9Cg.jpg',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AdviserScreen(),)),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 15),
                child: Container(
                    color: CustomColor.whiteColor,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('Contact Us', style: textStyle16(context, color: CustomColor.appColor),)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
