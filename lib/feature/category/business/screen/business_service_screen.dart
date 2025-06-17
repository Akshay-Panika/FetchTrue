import 'package:flutter/material.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/dimension.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_highlight_service.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../../core/widgets/custom_service_list.dart';
import '../../../banner/widget/category_banner_widget.dart';
import '../../../provider/widget/service_provider_widget.dart';
import '../../../search/screen/search_screen.dart';
import '../wisget/business_category_widget.dart';

class BusinessServiceScreen extends StatelessWidget {
  final String moduleId;
  const BusinessServiceScreen({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions =  Dimensions(context);
    return Scaffold(
      appBar: CustomAppBar(title: 'Business Service', showBackButton: true,),

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
        
            SliverAppBar(
              toolbarHeight: 60,
              floating: true,
              backgroundColor: CustomColor.canvasColor,
              automaticallyImplyLeading: false,
              flexibleSpace:  CustomSearchBar(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(),)),),
            ),
        
        
            SliverToBoxAdapter(child: CategoryBannerWidget(),),
        
            SliverToBoxAdapter(
              child: BusinessCategoryWidget(moduleIndexId: moduleId,),
            ),
        
            SliverToBoxAdapter(
              child: Column(
                children: [
                  10.height,
        
                  /// Services for you
                  CustomServiceList(headline: 'Services for you',),
        
                  /// Highlight service
                  CustomHighlightService(),
        
                  /// Popular Services
                  CustomServiceList(headline: 'Popular Services',),
        
                  ///  Service Provider
                  ServiceProviderWidget(),
        
                  /// Popular Services
                  Container(
                      color: CustomColor.appColor.withOpacity(0.1),
                      child: CustomServiceList(headline: 'All Services',)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
