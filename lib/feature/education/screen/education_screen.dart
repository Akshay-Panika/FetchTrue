import 'package:bizbooster2x/core/costants/custom_image.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/core/widgets/custom_headline.dart';
import 'package:bizbooster2x/feature/service_provider/widget/provider_services_list_widget.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_favorite_button.dart';
import '../../../core/widgets/custom_highlight_service.dart';
import '../../../core/widgets/custom_ratting_and_reviews.dart';
import '../../../core/widgets/custom_search_bar.dart';
import '../../../core/widgets/custom_service_list.dart';
import '../../banner/widget/category_banner_widget.dart';
import '../../category/widget/module_category_widget.dart';
import '../../search/screen/search_screen.dart';
import '../../service_provider/widget/service_provider_widget.dart';
import '../widget/education_category_widget.dart';
import 'education_playlist_screen.dart';

class EducationScreen extends StatelessWidget {
  final String? moduleName;
  final String moduleId;
  const EducationScreen({super.key, this.moduleName, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '$moduleName'?? 'Module name', showBackButton: true, showFavoriteIcon: true,),

      body: SafeArea(
        child: CustomScrollView(
          slivers: [

            SliverToBoxAdapter(
              child:  CategoryBannerWidget(),
            ),

            /// Search bar
            SliverAppBar(
              toolbarHeight: 60,
              floating: true,
              backgroundColor: CustomColor.canvasColor,
              automaticallyImplyLeading: false,
              flexibleSpace:  CustomSearchBar(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(),)),),
            ),

            SliverToBoxAdapter(child:  EducationCategoryWidget(moduleIndexId: moduleId),),

            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.height,

                  CustomHeadline(headline: 'New Courses',),
                  SizedBox(
                    height: 200,
                    child: GridView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1 / 1.5,
                      ),
                      itemBuilder: (context, index) {
                        return CustomContainer(
                          backgroundColor: CustomColor.whiteColor,
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: CustomContainer(
                                assetsImg: CustomImage.thumbnailImage,
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomFavoriteButton(),
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                          color: CustomColor.blackColor.withOpacity(0.3),
                                        ),
                                        child: CustomRattingAndReviews(color: CustomColor.whiteColor,),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Name', style: textStyle14(context),),
                                    Text('Description', style: textStyle14(context,fontWeight: FontWeight.w400),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EducationSubcategoryScreen(headline: 'Name',),)),
                        );
                      },
                    ),
                  ),
                  10.height,
                  CustomHighlightService(),
                  10.height,

                  CustomHeadline(headline: 'Up Courses',),
                  SizedBox(
                    height: 200,
                    child: GridView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1 / 1.5,
                      ),
                      itemBuilder: (context, index) {
                        return CustomContainer(
                          backgroundColor: CustomColor.whiteColor,
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: CustomContainer(
                                assetsImg: CustomImage.thumbnailImage,
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomFavoriteButton(),
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                          color: CustomColor.blackColor.withOpacity(0.3),
                                        ),
                                        child: CustomRattingAndReviews(color: CustomColor.whiteColor,),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Name', style: textStyle14(context),),
                                    Text('Description', style: textStyle14(context,fontWeight: FontWeight.w400),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EducationSubcategoryScreen(headline: 'Name',),)),
                        );
                      },
                    ),
                  ),

                  ///  Service Provider
                  ServiceProviderWidget(),
                  20.height

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
