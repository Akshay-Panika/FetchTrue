import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_height_banner.dart';
import '../../../core/widgets/custom_search_bar.dart';
import '../../../core/widgets/custom_banner.dart';
import '../../../core/widgets/custom_service_list.dart';
import '../../search/screen/search_screen.dart';
import '../widget/service_category_widget.dart';

class ServiceScreen extends StatefulWidget {
  final String? serviceName;
  const ServiceScreen({super.key, this.serviceName});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  @override
  Widget build(BuildContext context) {
    return  CustomScrollView(
      slivers: [

        SliverAppBar(
          toolbarHeight: 60,
          floating: true,
          backgroundColor: Theme.of(context).cardColor,
          surfaceTintColor: Theme.of(context).cardColor,
          elevation: 0,
          flexibleSpace:  CustomSearchBar(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(),)),),
        ),

        SliverToBoxAdapter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// banner
              CustomBanner(),
              SizedBox(height: 10,),

              /// Services
              ServiceCategoryWidget(),
              SizedBox(height: 10,),

              /// Popular Services
              CustomServiceList(),
              SizedBox(height: 20,),

              /// Just for you
              CustomHeightBanner(),
              SizedBox(height: 20,),

            ],
          ),
        )
      ],
    );
  }
}