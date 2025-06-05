import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_headline.dart';
import '../bloc/module_category/module_category_bloc.dart';
import '../bloc/module_category/module_category_event.dart';
import '../bloc/module_category/module_category_state.dart';
import '../repository/module_category_service.dart';
import '../screen/module_subcategory_screen.dart';

class MarketingCategoryWidget extends StatelessWidget {
  final String? moduleIndexId;
   MarketingCategoryWidget({super.key, this.moduleIndexId});
 

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
            return  Column(
              children: [
                CustomHeadline(headline: 'Service',),
                SizedBox(
                  height: serviceCount > 10 ? 230 : 115,
                  child: GridView.builder(
                    itemCount: serviceCount,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: serviceCount > 10 ? 2 :1,
                        childAspectRatio: 1 / 0.8,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0
                    ),
                    itemBuilder: (context, index) {
                      final category = modules[index];
                      serviceCount = modules.length;
                      return InkWell(//color: Colors.grey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(radius: 35,backgroundColor: CustomColor.whiteColor,
                             backgroundImage: NetworkImage(category.image),),
                            5.height,
                            Text(category.name, style: textStyle12(context),overflow: TextOverflow.ellipsis,maxLines: 2,textAlign: TextAlign.center,),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ModuleSubcategoryScreen(
                                // headline: category.name,
                                categoryId: category.id,
                              ),
                            ),
                          );
                        },
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
              CustomContainer(width: 80,backgroundColor: Colors.white,padding: EdgeInsets.zero,height: 8,),
              CustomContainer(width: 50, backgroundColor: Colors.white,padding: EdgeInsets.zero,height: 5,),
            ],
          ),
        ),

        SizedBox(
          height: 230,
          child: GridView.builder(
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10
            ),
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: CircleAvatar(radius: 35,backgroundColor: CustomColor.whiteColor,)),

                  Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: CustomContainer(
                        padding: EdgeInsets.zero,
                        height: 5,backgroundColor: CustomColor.whiteColor,))
                ],
              );
            },),
        ),
      ],
    );
  }
}