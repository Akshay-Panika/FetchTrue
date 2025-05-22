import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_container.dart';
import '../bloc/module_subcategory/module_subcategory_bloc.dart';
import '../bloc/module_subcategory/module_subcategory_event.dart';
import '../bloc/module_subcategory/module_subcategory_state.dart';
import '../model/module_subcategory_model.dart';
import '../../service/screen/service_details_screen.dart';
import '../model/module_category_model.dart';
import '../repository/module_category_service.dart';
import '../repository/module_subcategory_service.dart';
import '../widget/module_category_widget.dart';
import '../widget/module_subcategory_widget.dart';

class ModuleSubcategoryScreen extends StatefulWidget {
  final String categoryId;
  ModuleSubcategoryScreen({super.key, required this.categoryId});

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

            SizedBox(height: dimensions.screenHeight*0.01,),
            ModuleSubcategoryWidget(categoryId: widget.categoryId,),
            SizedBox(height: dimensions.screenHeight*0.02,),

            /// Filter
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    color: CustomColor.whiteColor,
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    child: ListView.builder(
                      itemCount: 10,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth*0.02),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth*0.03),
                          child: Center(child: Text("Filter $index")),
                        );
                      },),
                  ),
                ),
                CustomContainer(
                    height: 40,
                    border: true,
                    borderRadius: false,
                    backgroundColor: Colors.white,
                    margin: EdgeInsets.zero,
                    // padding: EdgeInsets.zero,
                    child: Center(child: Icon(Icons.menu))),
              ],
            ),
            SizedBox(height: dimensions.screenHeight*0.01,),

            /// Services
            Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: serviceData.length,
                  itemBuilder: (context, index) {
                    return CustomContainer(
                      height: 190,
                      border: true,
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.all(0),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailsScreen(image: serviceData[index]['image'].toString(),),)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomContainer(
                              margin: EdgeInsets.all(0),
                              assetsImg: serviceData[index]['image'],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Service Name', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Start from: ', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                        Text('10.00', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                        Icon(Icons.currency_rupee, size: 12,)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Start from: ', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                        Text('10.00', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                        Icon(Icons.currency_rupee, size: 12,)
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )),
          ],
        ),
      ),

    );
  }
}
