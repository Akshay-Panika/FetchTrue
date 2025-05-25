import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_headline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/widgets/custom_container.dart';
import '../bloc/module_category/module_category_bloc.dart';
import '../bloc/module_category/module_category_event.dart';
import '../bloc/module_category/module_category_state.dart';
import '../repository/module_category_service.dart';
import '../screen/module_subcategory_screen.dart';

class ModuleCategoryWidget extends StatefulWidget {
  final String moduleIndexId;
  ModuleCategoryWidget({super.key,  required this.moduleIndexId});

  @override
  State<ModuleCategoryWidget> createState() => _ModuleCategoryWidgetState();
}

class _ModuleCategoryWidgetState extends State<ModuleCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocProvider(
      create: (_) => ModuleCategoryBloc(ModuleCategoryService())..add(GetModuleCategory()),
      child:  BlocBuilder<ModuleCategoryBloc, ModuleCategoryState>(
        builder: (context, state) {
          if (state is ModuleCategoryLoading) {
            return CategoryShimmerGrid();
          }

          else if(state is ModuleCategoryLoaded){

            // final modules = state.moduleCategoryModel;
            final modules = state.moduleCategoryModel.where((moduleCategory) =>
            moduleCategory.module.id == widget.moduleIndexId
                && moduleCategory.subcategoryCount !=0
            ).toList();

            if (modules.isEmpty) {
              return const Center(child: Text('No modules found.'));
            }

            int serviceCount = modules.length;
            return Container(
              color: CustomColor.appColor.withOpacity(0.05),
              child: Column(
                children: [
                  /// Headline
                  CustomHeadline(headline: "Services"),

                  /// Category
                  Container(
                    height: serviceCount > 3 ? 150 : 70,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: serviceCount,
                      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: serviceCount > 3 ? 2 :1,
                        childAspectRatio: 1 / 2.5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final category = modules[index];
                        serviceCount = modules.length;
                        return CustomContainer(
                          padding: EdgeInsets.zero,
                          margin: EdgeInsets.zero,
                          backgroundColor: Colors.white,
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
                          child: Row(
                            children: [
                              CustomContainer(
                                width: 80,
                                networkImg: category.image ?? '',margin: EdgeInsets.zero,),

                              Expanded(
                                child: Text(
                                  category.name ?? '',
                                  style: textStyle12(context),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              10.width,
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: dimensions.screenHeight*0.02,),
                ],
              ),
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

class CategoryShimmerGrid extends StatelessWidget {
  const CategoryShimmerGrid({super.key});

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
          height: 140,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 2.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (_, __) => CustomContainer(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomContainer(
                      width: 80,
                      backgroundColor: Colors.white,
                      margin: EdgeInsets.zero,),

                     10.width,
                     Expanded(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         mainAxisAlignment: MainAxisAlignment.end,
                         children: [
                           CustomContainer(width: 50,height: 5,
                               margin: EdgeInsets.zero,
                               padding: EdgeInsets.zero,
                             backgroundColor: Colors.white,
                           ),
                           5.height,
                           CustomContainer(width: 80,height: 5,
                             margin: EdgeInsets.zero,
                             padding: EdgeInsets.zero,
                             backgroundColor: Colors.white,
                           ),
                           15.height,
                         ],
                       ),
                     )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
