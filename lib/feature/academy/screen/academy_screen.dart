import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/widgets/custom_banner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_headline.dart';
import '../widget/academy_banner_widget.dart';

class AcademyScreen extends StatelessWidget {
  const AcademyScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> _services = [
      {'title': 'Certificate', 'icon': Icons.verified},
      {'title': '2 Min. Gyan', 'icon': Icons.lightbulb_outline},
      {'title': 'Live Webinars', 'icon': Icons.wifi},
      {'title': 'Recorded Webinars', 'icon': Icons.video_library},
      {'title': 'Documents', 'icon': Icons.insert_drive_file},
    ];
    Dimensions dimensions = Dimensions(context);

    return Scaffold(
      appBar: CustomAppBar(title: 'Academy', showNotificationIcon: true,),
      body: Column(
        children: [

          /// Banner
          AcademyBannerWidget(),

          /// Services
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeadline(headline: 'Tutorials',viewSeeAll: false,),

              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _services.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.11 / 1,
                ),
                itemBuilder: (context, index) {
                  final item = _services[index];

                  return CustomContainer(
                    border: true,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomContainer(
                            backgroundColor: Colors.transparent,
                            child: Icon(item['icon'], size: 30,color: CustomColor.appColor,),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            item['title'],
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
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
          SizedBox(height: 20,),


          Expanded(
            child: CustomContainer(
             backgroundColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
