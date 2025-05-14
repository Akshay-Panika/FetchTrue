import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/helper/api_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../model/module_subcategory_model.dart';
import '../../service/screen/service_details_screen.dart';

class ModuleSubcategoryScreen extends StatelessWidget {
  final String headline;
  final String categoryId;
  ModuleSubcategoryScreen({super.key, required this.headline, required this.categoryId});


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '$headline',showBackButton: true,showSearchIcon: true,),

      body: SafeArea(
        child: FutureBuilder<List<ModuleSubCategoryModel>>(
            future: _subCategoryService.fetchSubCategories(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              }
        
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No subcategories'));
              }

              final allSubCategories = snapshot.data!;
              final filteredCategories = allSubCategories.where((element) {
                final subCategoryId = element.category.id;
                print('SubCategory Id: $subCategoryId');
                print(' SubCategory ID: $categoryId');
                return subCategoryId == categoryId;
              }).toList();

              if (filteredCategories.isEmpty) {
                return Center(child: Text('No subcategories'));
              }

              return Column(
                children: [

                  10.height,
                  /// Subcategory
                  Container(
                      height: 110,
                      // color: Colors.green,
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: filteredCategories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
        
                          final sub = filteredCategories[index];

                          return Container(
                            width: 110,

                            // padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                // CircleAvatar(
                                //   radius: 35,
                                //   backgroundColor: CustomColor.whiteColor,
                                //   backgroundImage: NetworkImage(sub.image),
                                // ),
                                Expanded(child: CustomContainer(
                                  networkImg: sub.image,
                                  backgroundColor: CustomColor.whiteColor,
                                )),

                                Text(sub.name, style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                              ],
                            ),
                          );
                        },)),
                  10.height,


                  /// Filter
                  Row(
                    children: [
                      Expanded(
                        child: CustomContainer(
                          height: 40,
                          borderRadius: false,
                          backgroundColor: Colors.white,
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                          child: ListView.builder(
                            itemCount: 5,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return CustomContainer(
                                border: true,
                                backgroundColor: Colors.white,
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(5),
                                width: 100,child: Center(child: Text("Headline")),);
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
              );
        
            },
        ),
      ),

    );
  }
}
