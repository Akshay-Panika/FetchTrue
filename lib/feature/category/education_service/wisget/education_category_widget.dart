import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_headline.dart';
import '../../../subcategory/screen/subcategory_screen.dart';
import '../../bloc/module_category/module_category_bloc.dart';
import '../../bloc/module_category/module_category_event.dart';
import '../../bloc/module_category/module_category_state.dart';
import '../../repository/module_category_service.dart';


class EducationCategoryWidget extends StatelessWidget {
  final String? moduleIndexId;
   EducationCategoryWidget({super.key, this.moduleIndexId});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ModuleCategoryBloc(ModuleCategoryService())..add(GetModuleCategory()),
      child:  BlocBuilder<ModuleCategoryBloc, ModuleCategoryState>(
        builder: (context, state) {
          if (state is ModuleCategoryLoading) {
            return _ShimmerGrid();
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

            return Column(
              children: [
                /// Category
                CustomHeadline(headline: 'Courses',),
                SizedBox(
                  height: serviceCount > 4? 300:150,
                  child: GridView.builder(
                    itemCount: serviceCount,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: serviceCount > 4? 2:1,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10
                    ),
                    itemBuilder: (context, index) {
                      final category = modules[index];
                      serviceCount = modules.length;
                      return CustomContainer(
                        color: CustomColor.whiteColor,
                        margin: EdgeInsets.zero,
                        networkImg: category.image,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(category.name, style: textStyle14(context),),
                          ],
                        ),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SubcategoryScreen(
                          categoryName: category.name,
                          categoryId: category.id,),)),
                      );
                    },
                  ),
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


class _ShimmerGrid extends StatelessWidget {
  const _ShimmerGrid({super.key});

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
              CustomContainer(width: 80,color: Colors.white,padding: EdgeInsets.zero,height: 8,),
              CustomContainer(width: 50, color: Colors.white,padding: EdgeInsets.zero,height: 5,),
            ],
          ),
        ),

        SizedBox(
          height: 300,
          child: GridView.builder(
            itemCount: 9,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10
            ),
            itemBuilder: (context, index) {

              return  Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: CustomContainer(
                  color: CustomColor.whiteColor,
                  margin: EdgeInsets.zero,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
