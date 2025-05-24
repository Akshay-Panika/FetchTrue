import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/custom_image.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_amount_text.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_button.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/core/widgets/custom_favorite_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import '../bloc/module_service/module_service_bloc.dart';
import '../bloc/module_service/module_service_event.dart';
import '../bloc/module_service/module_service_state.dart';
import '../model/service_model.dart';
import '../repository/api_service.dart';
import '../widget/franchise_details_section_widget.dart';
import '../widget/self_add_widget.dart';
import '../widget/service_banner_widget.dart';
import '../widget/service_details_section_widget.dart';
import '../widget/service_review_widget.dart';


class ServiceDetailsScreen extends StatefulWidget {
  final String serviceId;
  ServiceDetailsScreen({super.key, required this.serviceId});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen>
    with SingleTickerProviderStateMixin {


  final  List<String>  franchiseTabs =  [
    'Overview','How it work','T&C',];

  int _indexTap = 0;
  int _current = 0;
  late TabController _tabController;

  final ApiService apiService = ApiService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Service Details',
        showBackButton: true,
        showFavoriteIcon: true,
      ),


      body:  BlocProvider(
        create: (_) => ModuleServiceBloc(ApiService())..add(GetModuleService()),
        child:  BlocBuilder<ModuleServiceBloc, ModuleServiceState>(
          builder: (context, state) {
            if (state is ModuleServiceLoading) {
              return LinearProgressIndicator(backgroundColor: CustomColor.appColor, color: CustomColor.whiteColor ,minHeight: 2.5,);
            }

            else if(state is ModuleServiceLoaded){

              // final services = state.serviceModel;
              final services = state.serviceModel.where((moduleService) =>
              moduleService.id == widget.serviceId
              ).toList();

              if (services.isEmpty) {
                return const Center(child: Text('No Service found.'));
              }

              return SafeArea(
                child: DefaultTabController(
                  length: 2,
                  child: CustomScrollView(
                    slivers: [

                      /// Banner
                      SliverToBoxAdapter(
                       child: ServiceBannerWidget(services: services,),
                      ),


                      SliverPersistentHeader(
                        pinned: true,
                        floating: true,
                        delegate: _StickyHeaderDelegate(
                          child: SizedBox(height: 50,
                            child: TabBar(
                              tabs: [
                                Tab(text: 'Service Details',),
                                Tab(text: 'Franchise Details',),
                              ],
                              dividerColor: CustomColor.greyColor,
                              dividerHeight: 0.2,
                              labelStyle: textStyle14(context, color: CustomColor.appColor),
                              indicatorColor: CustomColor.appColor,
                              unselectedLabelColor: CustomColor.descriptionColor,
                              onTap: (value) {
                                setState(() {
                                  _indexTap = value;
                                });
                              },
                            ),
                          ),),
                      ),

                      SliverToBoxAdapter(child: SizedBox(height: 5,),),

                      SliverToBoxAdapter(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _indexTap == 0
                              ? ServiceDetailsSectionWidget(services: services)
                              : FranchiseDetailsSectionWidget(services: services),
                        ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 50,),)

                    ],
                  ),
                ),
              );

            }

            else if (state is ModuleServiceError) {
              return Center(child: Text(state.errorMessage));
            }
            return const SizedBox.shrink();
          },
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: CustomColor.appColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    showCustomBottomSheet(context,Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(radius: 40,
                                backgroundImage: AssetImage(CustomImage.nullImage),),
                              10.height,
                              Text('Available Providers', style: textStyle14(context),),
                              Text('0 Provider available ', style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),),
                            ],
                          ),
                          10.height,

                          CustomContainer(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(backgroundImage: AssetImage(CustomImage.nullImage),),
                                    20.width,
                                    Text('Let Bizbooster choose for you', style: textStyle14(context, color: CustomColor.appColor),),
                                  ],
                                ),

                                Icon(CupertinoIcons.check_mark_circled, color: CustomColor.greenColor,)
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomButton(text: 'Proceed To Checkout',
                            onTap: () {
                              Navigator.pop(context);
                            },),
                          ),

                        ],
                      ),
                    ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.person_crop_circle_badge_checkmark,
                          color: CustomColor.appColor),
                      SizedBox(width: 6),
                      Text(
                        'Self Add',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: CustomColor.appColor),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: CustomColor.appColor,
                  height: double.infinity,
                  child: InkWell(
                    onTap: () {
                      print('Shared to customer');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.share, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          'Share To Customer',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sticky TabBar Delegate
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: Colors.white,
        child: child);
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

