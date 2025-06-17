import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_highlight_service.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../../core/widgets/custom_service_list.dart';
import '../../../banner/widget/category_banner_widget.dart';
import '../../../provider/widget/service_provider_widget.dart';
import '../../../search/screen/search_screen.dart';
import '../../franchise/wisget/franchise_category_widget.dart';
import '../wisget/marketing_category_widget.dart';

class MarketingServiceScreen extends StatelessWidget {
  final String moduleId;
  const MarketingServiceScreen({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Marketing Service',showBackButton: true,),

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
              child: MarketingCategoryWidget(moduleIndexId: moduleId,),
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
