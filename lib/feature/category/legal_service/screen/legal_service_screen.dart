import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../auth/user_notifier/user_notifier.dart';
import '../../../banner/widget/legal_banner_widget.dart';
import '../../../favorite/screen/favorite_screen.dart';
import '../../../highlight_serive/highlight_widget.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../../core/widgets/custom_service_list.dart';
import '../../../banner/widget/category_banner_widget.dart';
import '../../../provider/widget/service_provider_widget.dart';
import '../../../search/screen/search_screen.dart';
import '../wisget/legal_all_service_widget.dart';
import '../wisget/legal_recommended_service_widget.dart';
import '../wisget/legal_service_category_widget.dart';

class LegalServiceScreen extends StatelessWidget {
  final String moduleId;
  const LegalServiceScreen({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);

    final double searchBarHeight = 10;

    return Scaffold(
      // appBar: CustomAppBar(title: 'Legal Service',showBackButton: true,),

      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            expandedHeight: 250 + searchBarHeight,
            leading: InkWell(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back_ios,color: CustomColor.whiteColor, size: 18,)),
            title: Text('Legal Service', style: textStyle16(context,color: CustomColor.whiteColor),),
            titleSpacing: 0,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xff264A7D),
                    Color(0xff4586E3),
                  ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    20.height,
                    CircleAvatar(radius: 30,
                      child: Image.asset('assets/image/legal_img.png', height: 50,),
                      backgroundColor: CustomColor.whiteColor,),
                    10.height,
                    Text('Your Trusted Leagal Partner', style: textStyle14(context, color: CustomColor.whiteColor),),
                    Text('One Stop for leagal & business soltuion', style: textStyle12(context, color: CustomColor.whiteColor),),
                  ],
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(searchBarHeight),
              child: Row(
                children: [
                  Expanded(
                    child: CustomSearchBar(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SearchScreen()),
                      ),
                    ),
                  ),

                  CustomContainer(
                    border: true,
                    borderColor: CustomColor.appColor,
                    color: CustomColor.whiteColor,
                    padding: EdgeInsets.all(8),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteScreen(userId: userSession.userId),)),
                    child: Icon(Icons.favorite, color: Colors.red,),)
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(child: LegalBannerWidget(moduleId: moduleId,),),

          SliverToBoxAdapter(child: LegalServiceWidget(moduleId: moduleId,),),

        ],
      ),
    );
  }
}
