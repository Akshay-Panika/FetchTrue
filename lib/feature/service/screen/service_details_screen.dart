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
import '../widget/self_add_widget.dart';
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
                        child: Container(
                          color: CustomColor.whiteColor,
                          child: Column(
                            children: [
                              CarouselSlider.builder(
                                itemCount: services.first.bannerImages.length,
                                itemBuilder:(context, index, realIndex) {
                                  final bannerCount = services.first.bannerImages[index];
                                  return CustomContainer(
                                    width: double.infinity,
                                    networkImg: services.first.bannerImages[index],
                                    borderRadius: false,
                                    margin: EdgeInsets.zero,
                                  );
                                } ,
                                options: CarouselOptions(
                                  height: 200,
                                  scrollPhysics:services.first.bannerImages.length > 1? AlwaysScrollableScrollPhysics() :NeverScrollableScrollPhysics(),
                                  autoPlay: services.first.bannerImages.length > 1? true :false,
                                  enlargeCenterPage: true,
                                  viewportFraction: 1,
                                  autoPlayInterval: const Duration(seconds: 4),
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  },
                                ),
                              ),

                              if(services.first.bannerImages.length >1)
                              Column(
                                children: [
                                  10.height,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(services.first.bannerImages.length, (index) {
                                      return AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        margin: const EdgeInsets.symmetric(horizontal: 3),
                                        height: 5,
                                        width: _current == index ? 24 : 10,
                                        decoration: BoxDecoration(
                                          color: _current == index ? Colors.blueAccent : Colors.grey,
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                              10.height,
                            ],
                          ),
                        ),
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
                              ? _buildServiceSection(context,services: services)
                              : _buildFranchiseSection(serviceTabs: franchiseTabs),
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

Widget _buildServiceSection(BuildContext context,{
  required List<ServiceModel> services,
}) {
  final ServiceModel data = services.first;
  return Column(
    children: [
      Stack(
        children: [
          CustomContainer(
            border: true,
            borderColor: CustomColor.greyColor,
            backgroundColor: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(data.serviceName, style: textStyle16(context,)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomAmountText(
                          amount: data.price.toString(),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          isLineThrough: true
                        ),
                        SizedBox(width: 10),
                        CustomAmountText(
                          amount: data.price.toString(),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceReviewWidget(),));
                        },
                        child: Text('⭐ 4.8 (120 Reviews)', style: TextStyle(fontSize: 14))),
                  ],
                ),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('Keys :', style: textStyle12(context),),
                        5.width,
                        Text('value',style: textStyle12(context),),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Keys :', style: textStyle12(context),),
                        5.width,
                        Text('value',style: textStyle12(context),),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
              top: 0,right: 10,
              child: CustomFavoriteButton())
        ],
      ),
      _buildServiceCard(services: services),
    ],
  );
}

Widget _buildFranchiseSection({required List<String> serviceTabs}) {
  return Column(
    children: [
      CustomContainer(
        border: true,
        borderColor: CustomColor.greyColor,
        backgroundColor: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        // padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'You will earn commission',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: CustomColor.appColor,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Up To',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomAmountText(
                      amount: '00.00',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ],
                ),
              ],
            ),
            Container(
              height: 100,width: 150,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                image: DecorationImage(image: AssetImage('assets/package/packageBuyImg.png'), fit: BoxFit.cover)
              ),
            )
          ],
        ),
      ),
      _buildFranchiseCard(serviceTabs: serviceTabs),
    ],
  );
}


Widget _buildServiceCard({required List<ServiceModel> services}) {
  final index = services.first.serviceDetails;

  final sections = [
    _Section('Benefits', index.benefits),
    _Section('Overview', index.overview),
    _Section('Highlight', index.highlight),
    _Section('Document', index.document),
    _Section('Why Choose BizBooster', null, whyChoose: index.whyChoose),
    _Section('How it work', index.howItWorks),
    _Section('T&C', index.termsAndConditions),
    _Section('FAQs', null, faqs: index.faq),
  ];

  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: sections.length,
    itemBuilder: (context, i) {
      final section = sections[i];

      if (section.whyChoose != null) return _buildWhyChoose(context, section.whyChoose!);
      if (section.faqs != null)      return _buildFAQs(context, section.faqs!);

      return CustomContainer(
        border: true,
        borderColor: CustomColor.greyColor,
        backgroundColor: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(section.title, style: textStyle14(context)),

            Html(
              data: section.html ?? '',
              style: {
                "body": Style(
                  fontSize: FontSize(14),
                  color: CustomColor.descriptionColor,
                ),
              },
            ),
          ],
        ),
      );
    },
  );
}

class _Section {
  final String title;
  final String? html;
  final List<WhyChoose>? whyChoose;
  final List<Faq>? faqs;
  _Section(this.title, this.html, {this.whyChoose, this.faqs});
}


Widget _buildWhyChoose(BuildContext context, List<WhyChoose> list) {
  return CustomContainer(
    border: true,
    borderColor: CustomColor.greyColor,
    backgroundColor: Colors.white,
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Why Choose BizBooster', style: textStyle14(context)),
        10.height,
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top:2.0, right: 5),
                child: Icon(Icons.circle_outlined, size: 14, color: CustomColor.greyColor),
              ),
              5.width,
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(list.first.title, style: textStyle12(context)),
                  Text(list.first.description, style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400)),
                ],
              )),
            ],
          );
        },)
      ],
    ),
  );
}

Widget _buildFAQs(BuildContext context, List<Faq> list) {
  return CustomContainer(
    border: true,
    borderColor: CustomColor.greyColor,
    backgroundColor: Colors.white,
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('FAQs', style: textStyle14(context)),
        ListView.builder(
          itemCount: list.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ExpansionTile(
              shape: InputBorder.none,
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              title: Text(list.first.question, style: textStyle14(context)),
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(list.first.answer)),
              ],
            );
          },
        ),
      ],
    ),
  );
}

Widget _buildFranchiseCard({required List<String> serviceTabs}){
  return  ListView.builder(
    itemCount: serviceTabs.length,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemBuilder: (context, index) {
      return
        CustomContainer(
          border: true,
          borderColor: CustomColor.greyColor,
          backgroundColor: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              0.height,
              Text(serviceTabs[index],style: textStyle14(context),),

              Text(
                'This is HTML Paragraph',
                style: TextStyle(fontSize: 14,color: CustomColor.descriptionColor),
              ),

            ],
          ),
        );
    },
  );
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

