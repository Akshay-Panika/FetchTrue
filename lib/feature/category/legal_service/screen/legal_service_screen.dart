import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';

import '../../../../core/costants/custom_color.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../highlight_serive/highlight_widget.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../../core/widgets/custom_service_list.dart';
import '../../../banner/widget/category_banner_widget.dart';
import '../../../provider/widget/service_provider_widget.dart';
import '../../../search/screen/search_screen.dart';
import '../../franchise/wisget/franchise_category_widget.dart';
import '../wisget/legal_all_service_widget.dart';
import '../wisget/legal_recommended_service_widget.dart';
import '../wisget/legal_service_category_widget.dart';

class LegalServiceScreen extends StatelessWidget {
  final String moduleId;
  const LegalServiceScreen({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Legal Service',showBackButton: true,),

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
              child: LegalServiceWidget(moduleIndexId: moduleId,),
            ),
        
            SliverToBoxAdapter(
              child: Column(
                children: [
                  10.height,
        
                  /// Services for you
                  LegalRecommendedServiceWidget(headline: 'Recommended Service', moduleIndexId: moduleId,),
        
                  /// Highlight service
                  HighlightServiceWidget(),

                  ///  Service Provider
                  ServiceProviderWidget(),
        
                  /// Popular Services
                  Container(
                      color: CustomColor.appColor.withOpacity(0.1),
                      child: LegalAllServiceWidget(headline: 'All Services', moduleIndexId: moduleId,)),
                ],
              ),
            )
        
          ],
        ),
      ),
    );
  }
}
