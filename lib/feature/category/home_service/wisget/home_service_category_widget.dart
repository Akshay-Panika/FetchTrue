import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/custom_image.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_headline.dart';
import '../../../subcategory/screen/subcategory_screen.dart';
import '../../bloc/module_category/module_category_bloc.dart';
import '../../bloc/module_category/module_category_event.dart';
import '../../bloc/module_category/module_category_state.dart';
import '../../repository/module_category_service.dart';

class HomeServiceCategoryWidget extends StatelessWidget {
  final String? moduleIndexId;
   HomeServiceCategoryWidget({super.key, this.moduleIndexId});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ModuleCategoryBloc(ModuleCategoryService())..add(GetModuleCategory()),
      child:  BlocBuilder<ModuleCategoryBloc, ModuleCategoryState>(
        builder: (context, state) {
          if (state is ModuleCategoryLoading) {
            return SubcategoryShimmerList();
          }

          else if(state is ModuleCategoryLoaded){

            // final modules = state.moduleCategoryModel;
            final modules = state.moduleCategoryModel.where((moduleCategory) =>
            moduleCategory.module.id == moduleIndexId
              //&& moduleCategory.subcategoryCount !=0
            ).toList();

            if (modules.isEmpty) {
              return const Center(child: Text('No Category found.'));
            }

            int serviceCount = modules.length;

            return  Column(
              children: [
                CustomHeadline(headline: 'Service',),
                SizedBox(
                  height: serviceCount > 5 ? 250 : 125,
                  child: GridView.builder(
                    itemCount: serviceCount,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: serviceCount > 5 ?2 :1,
                        childAspectRatio: 1 / 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10
                    ),
                    itemBuilder: (context, index) {
                      final category = modules[index];
                      serviceCount = modules.length;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomContainer(
                            height: 80,
                            // width:80,
                             networkImg: category.image,
                             margin: EdgeInsets.zero,
                             backgroundColor: CustomColor.whiteColor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SubcategoryScreen(
                                    categoryName: category.name,
                                    categoryId: category.id,
                                  ),
                                ),
                              );
                            },
                          ),
                          5.height,
                          Text(category.name, style: textStyle12(context),overflow: TextOverflow.ellipsis,maxLines: 2,textAlign: TextAlign.center,),
                        ],
                      );
                    },),
                ),
              ],
            );

          }

          else if (state is ModuleCategoryError) {
            return Center(child: Text(state.errorMessage));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}




class SubcategoryShimmerList extends StatelessWidget {
  const SubcategoryShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomContainer(width: 80,backgroundColor: Colors.white,padding: EdgeInsets.zero,height: 8,),
              CustomContainer(width: 50, backgroundColor: Colors.white,padding: EdgeInsets.zero,height: 5,),
            ],
          ),
        ),
        Container(
          height: 250,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
               crossAxisCount: 2,
               childAspectRatio: 1 / 0.7,
               crossAxisSpacing: 10,
               mainAxisSpacing: 10
           ),
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  children: [
                    CustomContainer(
                      height: 80,
                      // width: 80,
                      margin: EdgeInsets.zero,
                      backgroundColor: CustomColor.whiteColor,
                    ),
                    5.height,

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomContainer(
                          height: 6,
                          width: 50,
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                          backgroundColor: CustomColor.whiteColor,
                        ),
                        5.height,
                        CustomContainer(
                          height: 6,
                          width: 80,
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                          backgroundColor: CustomColor.whiteColor,
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
