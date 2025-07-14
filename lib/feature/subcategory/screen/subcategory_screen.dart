import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_favorite_button.dart';
import '../../ratting_and_reviews/ratting_and_reviews_widget.dart';
import '../../service/bloc/module_service/module_service_bloc.dart';
import '../../service/bloc/module_service/module_service_event.dart';
import '../../service/bloc/module_service/module_service_state.dart';
import '../../service/model/service_model.dart';
import '../../service/repository/api_service.dart';
import '../../service/screen/service_details_screen.dart';
import '../widget/filter_widget.dart';
import '../widget/module_subcategory_widget.dart';

class SubcategoryScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const SubcategoryScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  State<SubcategoryScreen> createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {

  String selectedSubcategoryId = '';

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      appBar: CustomAppBar(title: widget.categoryName, showBackButton: true, showFavoriteIcon: true,),

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
        
            /// Subcategory
            SliverToBoxAdapter(child: ModuleSubcategoryWidget(
              categoryId: widget.categoryId.toString(),
              subcategoryId: selectedSubcategoryId,
              onChanged: (id) {
                setState(() {
                  selectedSubcategoryId = id;
                });
                print('Selected Subcategory ID: $id');
              },
            ),),
        
            /// Filter
            SliverPersistentHeader(
              pinned: true,
                delegate: _StickyHeaderDelegate(child:  FilterWidget(dimensions: dimensions))),
        
        
            /// Service
            SliverToBoxAdapter(child:  BlocProvider(
              create: (_) => ModuleServiceBloc(ApiService())..add(GetModuleService()),
              child:  BlocBuilder<ModuleServiceBloc, ModuleServiceState>(
                builder: (context, state) {
                  if (state is ModuleServiceLoading) {
                    return Center(child: LinearProgressIndicator(backgroundColor: CustomColor.appColor, color: CustomColor.whiteColor ,minHeight: 2.5,),);
                  }
        
                  else if(state is ModuleServiceLoaded){
        
                    // final services = state.serviceModel;
                    // final services = state.serviceModel.where((moduleService) =>
                    // moduleService.subcategory!.id == selectedSubcategoryId
                    // ).toList();
                    List<ServiceModel> services = state.serviceModel.where((service) {
                      if (selectedSubcategoryId.isNotEmpty) {
                        // ✅ Subcategory selected — Match subcategory ID only if it's present
                        return service.subcategory?.id == selectedSubcategoryId;
                      } else {
                        // ✅ No subcategory selected — Show services matching category ID
                        return service.category.id == widget.categoryId;
                      }
                    }).toList();

                    if (services.isEmpty) {
                      return Column(
                        children: [
                          300.height,
                          Text('No Service found.'),
                        ],
                      );
                    }
        
                    return  Column(
                      children: List.generate(services.length, (index) {
                        final data = services[index];
                        return CustomContainer(
                          border: false,
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          margin: EdgeInsets.only(top: 15, left: 10,right: 10),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailsScreen(
                            serviceId: data.id,
                          ),
                          )),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomContainer(
                                height: 180,
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                networkImg: data.thumbnailImage,
                                backgroundColor: CustomColor.whiteColor,
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
                                        child: RattingAndReviewsWidget(serviceId: data.id,color: CustomColor.whiteColor,),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              10.height,
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data.serviceName, style: textStyle12(context),),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CustomAmountText(amount: data.price.toString(), color: CustomColor.descriptionColor,isLineThrough: true,fontSize: 14),
                                            10.width,
                                            CustomAmountText(amount: data.discountedPrice.toString(), color: CustomColor.descriptionColor, fontSize: 14),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('Earn up to ', style: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                                            Text('${data.franchiseDetails.commission}', style: textStyle14(context, color: CustomColor.greenColor, fontWeight: FontWeight.w400),),
                                          ],
                                        ),
                                      ],
                                    ),
                                    5.height,
                                    if (data.keyValues.isNotEmpty)
                                      ...data.keyValues.map((entry) => Padding(
                                        padding: const EdgeInsets.only(bottom: 6.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${entry.key} :', style: textStyle12(context, color: CustomColor.descriptionColor)),
                                            5.width,
                                            Expanded(
                                              child: Text(
                                                entry.value,
                                                style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),

                                    10.height,
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },),
                    );
        
                  }
        
                  else if (state is ModuleServiceError) {
                    return Center(child: Text(state.errorMessage));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),),
        
          ],
        ),
      ),
    );
  }
}

/// _StickyHeaderDelegate
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: 40,
      child: Material( // Optional: for background color
        color: Colors.white,
        child: child,
      ),
    );
  }

  @override
  double get maxExtent => 40.0;

  @override
  double get minExtent => 40.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}