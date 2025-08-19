import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../auth/user_notifier/user_notifier.dart';
import '../../../banner/widget/education_banner_widget.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../favorite/screen/favorite_screen.dart';
import '../wisget/education_category_widget.dart';
import '../../../search/screen/search_screen.dart';

class EducationServiceScreen extends StatelessWidget {
  final String moduleId;
  const EducationServiceScreen({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);

    return Scaffold(
      appBar: CustomAppBar(title: 'Education Service', showBackButton: true,),

      body: SafeArea(
        child: CustomScrollView(
          slivers: [

            SliverAppBar(
              toolbarHeight: 60,
              floating: true,
              backgroundColor: Colors.grey[100],
              automaticallyImplyLeading: false,
              flexibleSpace: Row(
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
              // flexibleSpace:  CustomSearchBar(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(),)),),
            ),
        
            SliverToBoxAdapter(child: EducationBannerWidget(moduleId: moduleId,),),
        
            SliverToBoxAdapter(child: EducationCategoryWidget(moduleId: moduleId),),

          ],
        ),
      ),
    );
  }
}
