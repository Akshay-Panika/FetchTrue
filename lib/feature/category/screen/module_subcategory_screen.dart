import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_amount_text.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_ratting_and_reviews.dart';
import 'package:bizbooster2x/feature/service/bloc/module_service/module_service_event.dart';
import 'package:bizbooster2x/feature/service/bloc/module_service/module_service_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_favorite_button.dart';
import '../../service/bloc/module_service/module_service_bloc.dart';
import '../../service/repository/api_service.dart';
import '../../service/screen/service_details_screen.dart';
import '../model/module_category_model.dart';
import '../repository/module_category_service.dart';
import '../repository/module_subcategory_service.dart';
import '../widget/filter_widget.dart';
import '../widget/module_subcategory_widget.dart';

class ModuleSubcategoryScreen extends StatefulWidget {
  final String? categoryId;
  ModuleSubcategoryScreen({super.key, this.categoryId});

  @override
  State<ModuleSubcategoryScreen> createState() => _ModuleSubcategoryScreenState();
}

class _ModuleSubcategoryScreenState extends State<ModuleSubcategoryScreen> {
  final ModuleCategoryService _categoryService = ModuleCategoryService();
  final SubCategoryService _subCategoryService = SubCategoryService();
  final List<Map<String, String>> serviceData = [
    {
      'image' : 'assets/image/thumbnail1.png'
    },
    {
      'image' : 'assets/image/thumbnail2.png'
    },
    {
      'image' : 'assets/image/thumbnail1.png'
    },
    {
      'image' : 'assets/image/thumbnail2.png'
    },
    {
      'image' : 'assets/image/thumbnail1.png'
    },
    {
      'image' : 'assets/image/thumbnail2.png'
    },
  ];

  ModuleCategoryModel? _selectedCategory;
  bool _isLoading = true;
  String? _error;
  String selectedSubcategoryId = '';

  @override
  void initState() {
    super.initState();
    _fetchCategory();
  }

  Future<void> _fetchCategory() async {
    try {
      final categories = await _categoryService.fetchModuleCategory();
      final category = categories.firstWhere(
            (c) => c.id == widget.categoryId,
        orElse: () => categories.first,
      );
      setState(() {
        _selectedCategory = category;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
  final ApiService apiService = ApiService();


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(child: Text('Error: $_error')),
      );
    }

    Dimensions dimensions = Dimensions(context);
    return  Scaffold(
      appBar: CustomAppBar( title: _selectedCategory!.name, showBackButton: true, showFavoriteIcon: true,),

      body: SafeArea(
        child: Column(
          children: [

            ModuleSubcategoryWidget(
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
            FilterWidget(dimensions: dimensions,),
            SizedBox(height: dimensions.screenHeight*0.01,),

            /// Services
            BlocProvider(
              create: (_) => ModuleServiceBloc(ApiService())..add(GetModuleService()),
              child:  BlocBuilder<ModuleServiceBloc, ModuleServiceState>(
                builder: (context, state) {
                  if (state is ModuleServiceLoading) {
                    return Center(child: LinearProgressIndicator(backgroundColor: CustomColor.appColor, color: CustomColor.whiteColor ,minHeight: 2.5,),);
                  }

                  else if(state is ModuleServiceLoaded){

                    // final services = state.serviceModel;
                    final services = state.serviceModel.where((moduleService) =>
                    moduleService.subcategory.id == selectedSubcategoryId
                    ).toList();

                    if (services.isEmpty) {
                      return const Center(child: Text('No Service found.'));
                    }

                    return  Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: services.length,
                          itemBuilder: (context, index) {

                            final data = services[index];
                            return CustomContainer(
                              border: false,
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.zero,
                              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                                            child: CustomRattingAndReviews(color: CustomColor.whiteColor,),
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
                                        if (data.keyValues != null && data.keyValues!.isNotEmpty)
                                          ...data.keyValues!.entries.map((entry) => Padding(
                                            padding: const EdgeInsets.only(bottom: 6.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('${entry.key} :', style: textStyle12(context,color: CustomColor.descriptionColor)),
                                                5.width,
                                                Expanded(child: Text(entry.value,style: textStyle12(context, fontWeight: FontWeight.w400,color: CustomColor.descriptionColor),overflow: TextOverflow.clip,)),
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
                          },
                        ));

                  }

                  else if (state is ModuleServiceError) {
                    return Center(child: Text(state.errorMessage));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),

          ],
        ),
      ),

    );
  }
}
