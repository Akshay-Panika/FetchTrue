import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/widgets/custom_favorite_button.dart';
import 'package:fetchtrue/core/widgets/formate_price.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../my_lead/screen/lead_screen.dart';
import '../../service/bloc/service/service_bloc.dart';
import '../../service/bloc/service/service_state.dart';
import '../../service/model/service_model.dart';
import '../../service/screen/service_details_screen.dart';
import '../widget/filter_widget.dart';
import '../widget/subcategory_widget.dart';

class SubcategoryScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const SubcategoryScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  State<SubcategoryScreen> createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {

  String selectedSubcategoryId = '';
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      appBar: CustomAppBar(title: widget.categoryName, showBackButton: true, showFavoriteIcon: true,),

      body: SafeArea(
        child: Column(
          children: [

            SubcategoryWidget(
              categoryId: widget.categoryId.toString(),
              subcategoryId: selectedSubcategoryId,
              onChanged: (id) {
                setState(() {
                  selectedSubcategoryId = id;
                });
                print('Selected Subcategory ID: $id');
              },
            ),


            /// Filter
            FilterWidget(
              dimensions: dimensions,
              onFilterSelected: (filter) {
                setState(() {
                  selectedFilter = filter;
                });
              },
            ),


            BlocBuilder<ServiceBloc, ServiceState>(
              builder: (context, state) {
                if (state is ServiceLoading) {
                  return _ShimmerList();
                }

                else if(state is ServiceLoaded){

                  // final services = state.services;
                  // final services = state.services.where((moduleService) =>
                  // moduleService.subcategory!.id == selectedSubcategoryId
                  // ).toList();
                  List<ServiceModel> services = state.services.where((service) {
                    if (selectedSubcategoryId.isNotEmpty) {
                      return service.subcategory?.id == selectedSubcategoryId;
                    } else {
                      return service.category.id == widget.categoryId;
                    }
                  }).toList();

                  services = _applyFilter(services);


                  if (services.isEmpty) {
                    return Column(
                      children: [
                        200.height,
                        Image.asset(CustomImage.emptyCart, height: 80,),
                        Text('No Service')
                      ],
                    );
                  }


                  return  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      children: List.generate(services.length, (index) {
                        final data = services[index];


                        String formatCommission(dynamic rawCommission, {bool half = false}) {
                          if (rawCommission == null) return '0';

                          final commissionStr = rawCommission.toString();

                          // Extract numeric value
                          final numericStr = commissionStr.replaceAll(RegExp(r'[^0-9.]'), '');
                          final numeric = double.tryParse(numericStr) ?? 0;

                          // Extract symbol (₹, %, etc.)
                          final symbol = RegExp(r'[^\d.]').firstMatch(commissionStr)?.group(0) ?? '';

                          final value = half ? (numeric / 2).round() : numeric.round();

                          // Format with symbol
                          if (symbol == '%') {
                            return '$value%';
                          } else {
                            return '$symbol$value';
                          }
                        }

                        return CustomContainer(
                          border: false,
                          color: Colors.white,
                          padding: EdgeInsets.zero,
                          margin: EdgeInsets.only(top: 10),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailsScreen(
                            serviceId: data.id,
                          ),
                          )),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomContainer(
                                height: 160,
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                networkImg: data.thumbnailImage,
                                color: CustomColor.whiteColor,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      CustomFavoriteButton(),

                                      Container(
                                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                          color: CustomColor.blackColor.withOpacity(0.3),
                                        ),
                                        child: Text('⭐ ${data.averageRating} (${data.totalReviews} ${'Reviews'})',
                                          style: TextStyle(fontSize: 12, color:CustomColor.whiteColor ),
                                        ),
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(data.serviceName, style: textStyle12(context),),
                                            Row(
                                              children: [
                                                CustomAmountText(amount: data.price.toString(), color: CustomColor.descriptionColor,isLineThrough: true,fontSize: 14),
                                                10.width,
                                                CustomAmountText(amount: formatPrice(data.discountedPrice!), color: CustomColor.descriptionColor, fontSize: 14),
                                                10.width,
                                                Text('${data.discount} % Off', style: textStyle14(context, color: CustomColor.greenColor, fontWeight: FontWeight.w400),),

                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text('Earn up to ', style: textStyle14(context, color: CustomColor.appColor, fontWeight: FontWeight.w400),),
                                            Text(formatCommission(data.franchiseDetails.commission, half: true), style: textStyle14(context, color: CustomColor.greenColor,),),
                                            // Text('${data.franchiseDetails.commission}', style: textStyle14(context, color: CustomColor.greenColor,),),
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },),
                    ),
                  );

                }

                else if (state is ServiceError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
        
          ],
        ),
      ),
    );
  }


  /// Filter logic
  List<ServiceModel> _applyFilter(List<ServiceModel> services) {
    final filtered = List<ServiceModel>.from(services);

    switch (selectedFilter) {
      case 'Low to High':
        filtered.sort((a, b) => (a.discountedPrice ?? 0).compareTo(b.discountedPrice ?? 0));
        break;
      case 'High to Low':
        filtered.sort((a, b) => (b.discountedPrice ?? 0).compareTo(a.discountedPrice ?? 0));
        break;
      case 'Most Popular':
        filtered.sort((a, b) => (b.totalReviews ?? 0).compareTo(a.totalReviews ?? 0));
        break;
      case 'Top Rated':
        filtered.sort((a, b) => (b.averageRating ?? 0).compareTo(a.averageRating ?? 0));
        break;
      case 'Best Seller':
      // rating × reviews = popularity score
        filtered.sort((a, b) {
          final scoreA = (a.averageRating ?? 0) * (a.totalReviews ?? 0);
          final scoreB = (b.averageRating ?? 0) * (b.totalReviews ?? 0);
          return scoreB.compareTo(scoreA);
        });
        break;
      case 'Recommended':  // filtered.retainWhere((s) => s.recommendedServices == true);
        filtered.sort((a, b) {
          if (a.recommendedServices == b.recommendedServices) return 0;
          return a.recommendedServices ? -1 : 1;
        });
        break;
      default:
        break;
    }

    return filtered;
  }
}


Widget _ShimmerList(){
  return Expanded(
    child: ListView(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
      children: List.generate(3, (index) => CustomContainer(
        height: 200,
        margin: EdgeInsetsGeometry.only(top: 10),
        child:  Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
             ShimmerBox(height: 10, width: 200),
             10.height,
             Row(
               children: [
                 ShimmerBox(height: 10, width:50),
                 10.width,
                 ShimmerBox(height: 10, width: 50),
               ],
             )
            ],
          ),
        ),
      ),),
    ),
  );
}