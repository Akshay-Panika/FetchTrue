import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/custom_logo.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/model/module_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/core/widgets/custom_headline.dart';
import 'package:bizbooster2x/core/widgets/custom_search_bar.dart';
import 'package:bizbooster2x/core/widgets/custom_banner.dart';
import 'package:bizbooster2x/core/widgets/custom_service_list.dart';

import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_highlight_service.dart';
import '../../../helper/api_helper.dart';
import '../../module/screen/module_category_screen.dart';
import '../../partner_review/widget/partner_review_widget.dart';
import '../../search/screen/search_screen.dart';
import '../../service_provider/widget/service_provider_widget.dart';
import '../../team_lead/screen/team_lead_screen.dart';
import '../../understandin_bizbooster/widget/understandin_bizbooster_widget.dart';
import '../widget/home_banner_widget.dart';
import '../widget/leads_widget.dart';
import '../widget/profile_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showServicePage = false;
  int _selectedServiceIndex = 0;
  ModuleModel? _selectedModule;

  final ModuleService moduleService = ModuleService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(
          leading: _showServicePage ? Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _showServicePage = false;
                  _selectedServiceIndex = 0;
                });
              },
              child:  Icon(Icons.dashboard, size: 25, color: CustomColor.appColor,),),
          ) : null,
        leadingWidth: !_showServicePage ?0:40,

          titleWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              _showServicePage ?
            Text(
            _selectedModule!.name ,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ):
              Image.asset(CustomLogo.bizBooster,height: 35,),
              // Text(_showServicePage ? '':"BizBooster2x", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),),
              SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.location_on_outlined,size: 14, color: CustomColor.appColor,),
                  Text("Waidhan Singrauli Madhya Pradesh Pin- 486886",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        showNotificationIcon: true,
        //showFavoriteIcon: true,
      ),

      body: _showServicePage
          ? ModuleCategoryScreen(moduleId: _selectedModule!.id??'',)
          : CustomScrollView(
          slivers: [

          /// Profile card
          SliverToBoxAdapter(child: ProfileCardWidget(),),

          /// Search bar
          SliverAppBar(
            toolbarHeight: 60,
            floating: true,
            backgroundColor: Colors.grey.shade100,
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
                HomeBannerWidget(),
                // CustomBanner(),
                const SizedBox(height: 5),

                /// Leads
                LeadsWidget(),
                const SizedBox(height: 10),

                /// Services
                CustomHeadline(headline: 'Services', viewSeeAll: false,),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 10),
                //   child: GridView.builder(
                //     shrinkWrap: true,
                //     physics: const NeverScrollableScrollPhysics(),
                //     itemCount: _services.length,
                //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //       crossAxisCount: 3,
                //       childAspectRatio: 1.11 / 1,
                //       crossAxisSpacing: 10,
                //       mainAxisSpacing: 10
                //     ),
                //     itemBuilder: (context, index) {
                //       return CustomContainer(
                //         onTap: () {
                //           setState(() {
                //             _selectedServiceIndex = index;
                //             _showServicePage = true;
                //           });
                //         },
                //         padding: EdgeInsets.zero,
                //         margin: EdgeInsets.zero,
                //         backgroundColor: Colors.white,
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: [
                //              Expanded(child: CustomContainer(
                //                backgroundColor: Colors.transparent,
                //               child: Icon(_servicesIcon[index], size: 30, color: CustomColor.appColor,),
                //             )),
                //             Padding(
                //               padding: const EdgeInsets.all(10.0),
                //               child: Text(
                //                 _services[index],
                //                 style: const TextStyle(
                //                   fontSize: 12,
                //                   fontWeight: FontWeight.w500,
                //                 ),
                //                 textAlign: TextAlign.center,
                //               ),
                //             ),
                //           ],
                //         ),
                //       );
                //     },
                //   ),
                // ),

                FutureBuilder(
                    future: moduleService.fetchModules(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No modules found.'));
                      }
                      else{
                        final modules = snapshot.data!;
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
                                  setState(() {
                                    _selectedServiceIndex = index;
                                    _selectedModule = module;
                                    _showServicePage = true;
                                  });
                                },
                                // padding: EdgeInsets.zero,
                                margin: EdgeInsets.zero,
                                backgroundColor: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(child: CustomContainer(
                                      backgroundColor: Colors.transparent,
                                      networkImg: module.image,
                                      padding: EdgeInsets.zero,
                                      margin: EdgeInsets.zero,
                                    )),
                                    Text(module.name, style: textStyle12(context),overflow: TextOverflow.clip,textAlign: TextAlign.center,),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },),

                const SizedBox(height: 20),

                CustomServiceList(headline: 'Services for you',),

                /// Custom Highlight Service
                CustomHighlightService(),

                CustomServiceList(headline: 'Popular Services',),


                CustomContainer(
                  width: double.infinity,
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  backgroundColor: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Your BizBooster',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: CustomColor.appColor),),
                          SizedBox(height: 5,),
                          Text('Your friend are going to love us tool', style: TextStyle(fontSize: 14),),
                          SizedBox(height: 5,),
                          Text('Refer And Win up to ____', style: TextStyle(fontSize: 16, color: CustomColor.iconColor, fontWeight: FontWeight.w600),),
                        ],
                      ),

                      Image.asset('assets/image/inviteFrnd.png',height: 200,width: double.infinity,)
                    ],
                  ),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamLeadScreen(),)),
                ),

                ///  Service Provider
                ServiceProviderWidget(),

                UnderstandingBizBoosterWidget(),

                PartnerReviewWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
