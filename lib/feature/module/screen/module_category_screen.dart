import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/feature/module/widget/module_category_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../service_provider/widget/service_provider_widget.dart';
import '../../../core/widgets/custom_search_bar.dart';
import '../../../core/widgets/custom_banner.dart';
import '../../../core/widgets/custom_service_list.dart';
import '../../search/screen/search_screen.dart';
import '../widget/category_banner_widget.dart';

class ModuleCategoryScreen extends StatefulWidget {
  final String? serviceName;
  final String moduleId;
  const ModuleCategoryScreen({super.key, this.serviceName, required this.moduleId});

  @override
  State<ModuleCategoryScreen> createState() => _ModuleCategoryScreenState();
}

class _ModuleCategoryScreenState extends State<ModuleCategoryScreen> {
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
              CategoryBannerWidget(),
             10.height,

              /// Services
              ModuleCategoryWidget(moduleIndexId: widget.moduleId,),
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