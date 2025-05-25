import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_highlight_service.dart';
import '../../service_provider/widget/service_provider_widget.dart';
import '../../../core/widgets/custom_search_bar.dart';
import '../../../core/widgets/custom_service_list.dart';
import '../../search/screen/search_screen.dart';
import '../../banner/widget/category_banner_widget.dart';
import '../widget/module_category_widget.dart';

class ModuleCategoryScreen extends StatefulWidget {
  final String? moduleName;
  final String moduleId;
  final Function(bool) onToggle;
  const ModuleCategoryScreen({super.key, this.moduleName, required this.moduleId, required this.onToggle});

  @override
  State<ModuleCategoryScreen> createState() => _ModuleCategoryScreenState();
}

class _ModuleCategoryScreenState extends State<ModuleCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return  Scaffold(
      appBar: CustomAppBar(
        showNotificationIcon: true,
        titleWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.moduleName ?? 'Module Name', style: textStyle16(context, color: CustomColor.appColor),),
            Text(
              "Waidhan Singrauli Madhya Pradesh Pin- 486886",
              style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: IconButton(onPressed: () {
            setState(() {
              widget.onToggle(true);
            });
          }, icon: Icon(Icons.dashboard, color: CustomColor.appColor,)),
        ),
        leadingWidth: 40,
      ),

      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            toolbarHeight: 60,
            floating: true,
            backgroundColor: CustomColor.canvasColor,
            flexibleSpace:  CustomSearchBar(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(),)),),
          ),

          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// banner
                CategoryBannerWidget(),
                // SizedBox(height: dimensions.screenHeight*0.02,),

                /// Module Category
                ModuleCategoryWidget(moduleIndexId: widget.moduleId,),


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
    );
  }
}