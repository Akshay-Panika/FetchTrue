

import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_container.dart';
import '../bloc/module_subcategory/module_subcategory_bloc.dart';
import '../bloc/module_subcategory/module_subcategory_event.dart';
import '../bloc/module_subcategory/module_subcategory_state.dart';
import '../repository/module_subcategory_service.dart';
import 'module_category_widget.dart';

class ModuleSubcategoryWidget extends StatelessWidget {
  final String categoryId;
  const ModuleSubcategoryWidget({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ModuleSubcategoryBloc(SubCategoryService())..add(GetModuleSubcategory()),
      child:  BlocBuilder<ModuleSubcategoryBloc, ModuleSubcategoryState>(
        builder: (context, state) {
          if (state is ModuleSubcategoryLoading) {
            return SubcategoryShimmerList();
          }

          else if(state is ModuleSubcategoryLoaded){

            // final modulesSubCategory = state.moduleSubcategoryModel;
            final modulesSubCategory = state.moduleSubcategoryModel.where((subcategory) =>
            subcategory.category.id == categoryId
            ).toList();

            if (modulesSubCategory.isEmpty) {
              return const Center(child: Text('No modules found.'));
            }

            return  SizedBox(
                height: 110,
                // color: Colors.green,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: modulesSubCategory.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {

                    final sub = modulesSubCategory[index];

                    return Container(
                      width: 110,
                      // padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Expanded(child: CustomContainer(
                            networkImg: sub.image,
                            backgroundColor: CustomColor.whiteColor,
                          )),

                          Text(sub.name, style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                        ],
                      ),
                    );
                  },));

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
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: 110,
            // padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(child: CustomContainer(
                  backgroundColor: CustomColor.whiteColor,
                )),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomContainer(
                      height: 5,
                      width: 80,
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      backgroundColor: CustomColor.whiteColor,
                    ),
                    5.height,
                    CustomContainer(
                      height: 5,
                      width: 80,
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      backgroundColor: CustomColor.whiteColor,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
