import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/custom_logo.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/feature/education/screen/education_screen.dart';
import 'package:bizbooster2x/feature/home/bloc/module/module_state.dart';
import 'package:bizbooster2x/feature/home/model/module_model.dart';
import 'package:flutter/material.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/core/widgets/custom_headline.dart';
import 'package:bizbooster2x/core/widgets/custom_search_bar.dart';
import 'package:bizbooster2x/core/widgets/custom_service_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_highlight_service.dart';
import '../../business_idea/screen/business_idea_screen.dart';
import '../../category/screen/module_category_screen.dart';
import '../../module/onboarding/screen/onboarding_screen.dart';
import '../../partner_review/widget/partner_review_widget.dart';
import '../../provider/widget/service_provider_widget.dart';
import '../../search/screen/search_screen.dart';
import '../../team_lead/screen/team_lead_screen.dart';
import '../../understandin_bizbooster/widget/understandin_bizbooster_widget.dart';
import '../bloc/module/module_bloc.dart';
import '../bloc/module/module_event.dart';
import '../repository/module_service.dart';
import '../../banner/widget/home_banner_widget.dart';
import '../widget/leads_widget.dart';
import '../widget/module_shimmer_grid_widget.dart';
import '../widget/profile_card_widget.dart';

class HomeScreen extends StatefulWidget {
  final String moduleName;
  final String moduleId;
  final Function(bool, String,String ) onToggle;
  const HomeScreen({super.key, required this.onToggle, required this.moduleName, required this.moduleId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      // appBar: CustomAppBar(
      //   showNotificationIcon: true,
      //   titleWidget: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text('BizBooster2x', style: textStyle16(context, color: CustomColor.appColor),),
      //       Text("Waidhan Singrauli Madhya Pradesh Pin- 486886",
      //         style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
      //     ],
      //   ),
      // ),
      appBar: AppBar(toolbarHeight: 0,),

      body: SafeArea(
        child: CustomScrollView(
            slivers: [
        
            /// Profile card
            SliverToBoxAdapter(child: ProfileCardWidget(),),
        
            /// Search bar
            SliverAppBar(
              toolbarHeight: 60,
              floating: true,
              backgroundColor: CustomColor.canvasColor,
              flexibleSpace: CustomSearchBar(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                ),
              ),
            ),
        
            /// Data
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
        
                  /// Banner
                  HomeBannerWidget(),
                  SizedBox(height: dimensions.screenHeight*0.01,),
        
                  /// Leads
                  LeadsWidget(),
                  SizedBox(height: dimensions.screenHeight*0.02,),
        
                  /// module list
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      15.width,
                      Text('🔷 Modules', style: textStyle14(context),),
                      Expanded(child: CustomContainer(padding: EdgeInsets.zero,height: 1,backgroundColor: CustomColor.appColor.withOpacity(0.8),))
                    ],
                  ),
                  SizedBox(height: dimensions.screenHeight*0.01,),
        
                  BlocProvider(
                    create: (_) => ModuleBloc(ModuleService())..add(GetModule()),
                   child:  BlocBuilder<ModuleBloc, ModuleState>(
                     builder: (context, state) {
                       if (state is ModuleLoading) {
                         return ModuleShimmerGrid();
                       }
                       else if(state is ModuleLoaded){
                         // final modules = state.moduleModel;
                         final modules = state.moduleModel .where((module) => module.categoryCount != 0)
                             .toList();
        
                         if (modules.isEmpty) {
                           return const Center(child: Text('No modules found.'));
                         }
        
                         return  Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 10),
                           child: GridView.builder(
                             itemCount: modules.length,
                             shrinkWrap: true,
                             physics: const NeverScrollableScrollPhysics(),
                             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                 crossAxisCount: 3,
                                 childAspectRatio: 1.11 / 1,
                                 crossAxisSpacing: 10,
                                 mainAxisSpacing: 10
                             ),
                             itemBuilder: (context, index) {
                               final module = modules[index];
                               return CustomContainer(
                                 onTap: () {
                                   if( module.name == 'Education'){
                                     Navigator.push(context, MaterialPageRoute(builder: (context) => EducationScreen(
                                       moduleId: module.id,
                                       moduleName: module.name,
                                     ),));
                                   }
                                   else{
                                     Navigator.push(context, MaterialPageRoute(builder: (context) => OnboardingScreen(
                                       moduleId: module.id,
                                       moduleName: module.name,
                                     ),));
                                   }

                                   // setState(() {
                                   //   widget.onToggle(false, module.name, module.id);
                                   // });
                                 },
                                 // padding: EdgeInsets.zero,
                                 margin: EdgeInsets.zero,
                                 backgroundColor: Colors.white,
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: [
                                    Expanded(
                                       child: CustomContainer(
                                           networkImg: module.image,
                                         margin: EdgeInsets.zero,
                                         backgroundColor: Colors.transparent,
                                       ),
                                     ),
                                     Text(module.name, style: textStyle12(context),overflow: TextOverflow.clip,textAlign: TextAlign.center,),
                                   ],
                                 ),
                               );
                             },
                           ),
                         );
                       }
        
                       else if (state is ModuleError) {
                         return Center(child: Text(state.errorMessage));
                       }
                       return const SizedBox.shrink();
                     },
                   ),
                  ),
                  SizedBox(height: dimensions.screenHeight*0.01,),
        
                  /// Services for you
                  CustomServiceList(headline: 'Services for you',),
                  SizedBox(height: dimensions.screenHeight*0.01,),
        
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
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BusinessIdeaScreen(),)),
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
            ),
          ],
        ),
      ),
    );
  }
}
