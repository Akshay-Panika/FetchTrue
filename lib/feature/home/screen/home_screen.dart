import 'package:fetchtrue/feature/home/widget/all_service_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_highlight_service.dart';
import '../../../core/widgets/custom_search_bar.dart';
import '../../../core/widgets/custom_service_list.dart';
import '../../advisers/screen/adviser_screen.dart';
import '../../more/model/user_model.dart';
import '../../more/repository/user_service.dart';
import '../../partner_review/widget/partner_review_widget.dart';
import '../../provider/widget/service_provider_widget.dart';
import '../../search/screen/search_screen.dart';
import '../../banner/widget/home_banner_widget.dart';
import '../../team_build/screen/team_build_screen.dart';
import '../../understandin_bizbooster/widget/understandin_bizbooster_widget.dart';
import '../widget/team_build_widget.dart';
import '../widget/module_widget.dart';
import '../widget/profile_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key,});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String? userId;
  String? token;
  UserModel? userData;

  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('userId');
    final tkn = prefs.getString('token');

    setState(() {
      userId = id;
      token = tkn;
    });

    if (id != null) {
      final user = await userService.fetchUserById(id);
      setState(() {
        userData = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0,),
      body: SafeArea(
        child: CustomScrollView(
            slivers: [

            /// Profile card
            SliverToBoxAdapter(child: ProfileAppWidget(userdata: userData,),),

            /// Search bar
            SliverAppBar(
              toolbarHeight: 60,
              floating: true,
              pinned: true,
              backgroundColor: CustomColor.canvasColor,
              flexibleSpace: CustomSearchBar(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen()),),
              ),
            ),

            /// Banner
            SliverToBoxAdapter(child: HomeBannerWidget(),),
            SliverToBoxAdapter(child: 10.height,),

            /// Futures
            SliverToBoxAdapter(child: LeadsWidget(),),
            SliverToBoxAdapter(child: 15.height,),

            /// Modules
            SliverToBoxAdapter(child: ModuleWidget(dimensions: dimensions,),),
            SliverToBoxAdapter(child: 15.height,),

            SliverToBoxAdapter(
              child: Column(
                children: [

                  /// Services for you
                  AllServiceWidget(headline: 'Services for you',),

                  /// Highlight service
                  CustomHighlightService(),

                  /// Popular Services
                  CustomServiceList(headline: 'Popular Services',),

                  CustomContainer(
                    height: 200,
                    border: true,
                    backgroundColor: Colors.green.shade50,
                    width: double.infinity,
                    networkImg: 'https://template.canva.com/EAGCux6YcJ8/1/0/1600w-pxaBUxBx9Cg.jpg',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AdviserScreen(),)),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, bottom: 15),
                        child: Container(
                            color: CustomColor.whiteColor,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text('Contact Us', style: textStyle16(context, color: CustomColor.appColor),)),
                      ),
                    ),
                  ),

                  /// Refer and earn
                  CustomContainer(
                    width: double.infinity,
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    backgroundColor: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: dimensions.screenHeight*0.02,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Your BizBooster',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: CustomColor.appColor),),
                            5.height,
                            Text('Your friend are going to love us tool', style: TextStyle(fontSize: 14),),
                            5.height,
                            Text('Refer And Win up to ____', style: TextStyle(fontSize: 16, color: CustomColor.iconColor, fontWeight: FontWeight.w600),),
                          ],
                        ),

                        Image.asset('assets/image/inviteFrnd.png',height: 200,width: double.infinity,)
                      ],
                    ),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamLeadScreen(),)),
                  ),
                  SizedBox(height: dimensions.screenHeight*0.01,),

                  CustomServiceList(headline: 'Recommended Services For You'),

                  ///  Service Provider
                  ServiceProviderWidget(),

                  CustomContainer(
                    height: 200,
                    borderRadius: false,
                    margin: EdgeInsets.zero,
                    backgroundColor: Colors.teal.shade50,
                    child: Container(
                      color: Colors.black.withOpacity(0.1),
                      child: Center(
                        child: Text('Explore Near By provider',
                          style: textStyle22(context, color: CustomColor.appColor, fontWeight: FontWeight.bold),),
                      ),),
                  ),

                  /// Understanding bizBooster
                  UnderstandingBizBoosterWidget(),

                  /// Partner review
                  PartnerReviewWidget(),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
