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
import '../widget/finance_category_widget.dart';
import '../widget/finance_all_service_widget.dart';
import '../widget/finance_recommended_service_widget.dart';


class FinanceServiceScreen extends StatelessWidget {
  final String moduleId;
  const FinanceServiceScreen({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Finance Service', showBackButton: true,),

      body: SafeArea(
        child: CustomScrollView(
          slivers: [



            SliverToBoxAdapter(child: CategoryBannerWidget(),),

            SliverAppBar(
              toolbarHeight: 60,
              floating: true,
              backgroundColor: CustomColor.canvasColor,
              automaticallyImplyLeading: false,
              flexibleSpace:  CustomSearchBar(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(),)),),
            ),

            SliverToBoxAdapter(
              child: FinanceCategoryWidget(moduleIndexId: moduleId),
            ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  10.height,

                  /// Recommended Service
                  FinanceRecommendedServiceWidget(headline: 'Recommended Service',moduleIndexId: moduleId,),

                  /// Highlight service
                  HighlightServiceWidget(),
                  ///  Service Provider
                  ServiceProviderWidget(),

                  /// Popular Services
                  Container(
                      color: CustomColor.appColor.withOpacity(0.1),
                      child: FinanceAllServiceWidget(headline: 'All Services',moduleIndexId: moduleId,)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
