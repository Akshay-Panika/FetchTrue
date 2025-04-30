import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/banner_widget.dart';
import '../widget/leads_widget.dart';
import '../widget/popular_services_widget.dart';
import '../widget/services_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          /// banner
          BannerWidget(),
          SizedBox(height: 10,),

          /// Leads
          LeadsWidget(),
          SizedBox(height: 20,),

          /// Services
          ServicesWidget(),
          SizedBox(height: 20,),

          /// Popular Services
          PopularServicesWidget(),
          SizedBox(height: 20,),
        ],
      ),
    );
  }
}
