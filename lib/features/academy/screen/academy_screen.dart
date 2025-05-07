import 'package:bizbooster2x/core/widgets/custom_banner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_headline.dart';

class AcademyScreen extends StatelessWidget {
  const AcademyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List _services = ['Certificate', '2 Min. Gyan', 'Live Webinars', 'Recorded Webinars', 'Documents',];

    return Scaffold(
      appBar: CustomAppBar(title: 'Academy', showNotificationIcon: true,),
      body: Column(
        children: [

          CustomBanner(),
          SizedBox(height: 20,),


          /// Services
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeadline(headline: 'Tutorials',viewSeeAll: false,),

              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: _services.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.11 / 1,
                  // mainAxisExtent: 100,
                ),
                itemBuilder: (context, index) {
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
                            margin: EdgeInsets.all(0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(_services[index].toString(), style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
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
