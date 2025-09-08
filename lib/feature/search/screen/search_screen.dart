import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_favorite_button.dart';
import '../../../core/widgets/custom_search_icon.dart';
import '../../../core/widgets/formate_price.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../favorite/widget/favorite_service_button_widget.dart';
import '../../service/bloc/service/service_bloc.dart';
import '../../service/bloc/service/service_state.dart';
import '../../service/screen/service_details_screen.dart';

class SearchScreen extends StatefulWidget {
  final String moduleId;
  const SearchScreen({super.key, required this.moduleId});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      appBar: AppBar(toolbarHeight: 10,),
      body: Column(
        children: [
          // 🔍 Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Hero(
                    tag: "searchBarHero",
                    child: Material(
                      color: Colors.transparent,
                      child: CustomContainer(
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.symmetric(
                          horizontal: dimensions.screenWidth * 0.030,
                          vertical: dimensions.screenHeight * 0.01,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: 'Search here...',
                                  hintStyle: textStyle14(context, fontWeight: FontWeight.w400),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    searchQuery = value.toLowerCase();
                                  });
                                },
                              ),
                            ),
                            CustomSearchIcon(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                10.width,
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))
              ],
            ),
          ),

          BlocBuilder<ServiceBloc, ServiceState>(
            builder: (context, state) {
              if (state is ServiceLoading) {
                return _ShimmerList();
              } else if (state is ServiceLoaded) {

                final filteredByModule = (widget.moduleId.isEmpty)
                    ? state.services
                    : state.services.where((service) =>
                service.category?.module == widget.moduleId).toList();

                final services = filteredByModule.where((service) {
                  return service.serviceName.toLowerCase().contains(searchQuery);
                }).toList();



                if (services.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(CustomImage.emptyCart, height: 80),
                      const Text('No Service')
                    ],
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final data = services[index];

                      String formatCommission(dynamic rawCommission, {bool half = false}) {
                        if (rawCommission == null) return '0';
                        final commissionStr = rawCommission.toString();
                        final numericStr = commissionStr.replaceAll(RegExp(r'[^0-9.]'), '');
                        final numeric = double.tryParse(numericStr) ?? 0;
                        final symbol = RegExp(r'[^\d.]').firstMatch(commissionStr)?.group(0) ?? '';
                        final value = half ? (numeric / 2).round() : numeric.round();
                        return symbol == '%' ? '$value%' : '$symbol$value';
                      }

                      return CustomContainer(
                        border: false,
                        color: Colors.white,
                        padding: EdgeInsets.zero,
                        margin: const EdgeInsets.only(top: 10),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceDetailsScreen(serviceId: data.id),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomContainer(
                              height: dimensions.screenHeight * 0.16,
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
                                     Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: FavoriteServiceButtonWidget(serviceId: data.id,),
                                     ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: dimensions.screenHeight * 0.01),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        color: CustomColor.blackColor.withOpacity(0.3),
                                      ),
                                      child: Text(
                                        '⭐ ${data.averageRating} (${data.totalReviews} Reviews)',
                                        style:  TextStyle(fontSize: 12, color: CustomColor.whiteColor),
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
                                          Text(data.serviceName, style: textStyle12(context)),
                                          Row(
                                            children: [
                                              CustomAmountText(
                                                amount: data.price.toString(),
                                                color: CustomColor.descriptionColor,
                                                isLineThrough: true,
                                                fontSize: 14,
                                              ),
                                              10.width,
                                              CustomAmountText(
                                                amount: formatPrice(data.discountedPrice!),
                                                color: CustomColor.descriptionColor,
                                                fontSize: 14,
                                              ),
                                              10.width,
                                              Text(
                                                '${data.discount} % Off',
                                                style: textStyle14(
                                                    context,
                                                    color: CustomColor.greenColor,
                                                    fontWeight: FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Earn up to ',
                                            style: textStyle14(
                                                context,
                                                color: CustomColor.appColor,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            formatCommission(data.franchiseDetails.commission, half: true),
                                            style: textStyle14(context, color: CustomColor.greenColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  5.height,
                                  if (data.keyValues.isNotEmpty)
                                    ...data.keyValues.map((entry) => Padding(
                                      padding: const EdgeInsets.only(bottom: 6.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${entry.key} :',
                                            style: textStyle12(context, color: CustomColor.descriptionColor),
                                          ),
                                          5.width,
                                          Expanded(
                                            child: Text(
                                              entry.value,
                                              style: textStyle12(context,
                                                  fontWeight: FontWeight.w400,
                                                  color: CustomColor.descriptionColor),
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
                    },
                  ),
                );
              } else if (state is ServiceError) {
                return const Expanded(child: Center(child: Text('No Service')));
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
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