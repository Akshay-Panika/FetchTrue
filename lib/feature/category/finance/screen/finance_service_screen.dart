import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../auth/user_notifier/user_notifier.dart';
import '../../../banner/widget/finance_banner_widget.dart';
import '../../../favorite/screen/favorite_screen.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../search/screen/search_screen.dart';
import '../widget/finance_category_widget.dart';


class FinanceServiceScreen extends StatelessWidget {
  final String moduleId;
  final String imageUrl;
  const FinanceServiceScreen({super.key, required this.moduleId, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);
    return Scaffold(
      appBar: CustomAppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Hero(
            tag: moduleId,
            child: Material(
              color: Colors.transparent,
              child: CircleAvatar(radius: 18,
                backgroundColor: CustomColor.appColor,
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: CustomColor.whiteColor,
                  backgroundImage: NetworkImage(imageUrl),
                ),
              ),
            ),
          ),
        ),
        // titleSpacing: 15,
        leadingWidth: 50,
        titleWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Finance Service', style: textStyle16(context,color: CustomColor.appColor),),
            Text('Pune 411028, Maharashtra', style: textStyle12(context,color: CustomColor.descriptionColor),),
          ],
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [

            SliverToBoxAdapter(child: FinanceBannerWidget(moduleId: moduleId,),),

            SliverAppBar(
              toolbarHeight: 60,
              floating: true,
              backgroundColor: Colors.grey[100],
              automaticallyImplyLeading: false,
              flexibleSpace:  CustomSearchBar(),
            ),

            SliverToBoxAdapter(
              child: FinanceCategoryWidget(moduleId: moduleId),
            ),
          ],
        ),
      ),
    );
  }
}
