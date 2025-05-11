import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../service_provider/widget/service_provider_widget.dart';
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
              CustomServiceList(headline: 'Popular Services',),
              SizedBox(height: 20,),

              /// ServiceProviderWidget
              ServiceProviderWidget(),
              SizedBox(height: 20,),

            ],
          ),
        )
      ],
    );
  }
}