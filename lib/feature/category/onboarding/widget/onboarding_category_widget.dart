import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/dimension.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../../subcategory/screen/subcategory_screen.dart';
import '../../bloc/category_bloc.dart';
import '../../bloc/category_state.dart';


class OnboardingCategoryWidget extends StatelessWidget {
  final String moduleId;
  OnboardingCategoryWidget({super.key,  required this.moduleId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return _ShimmerGrid();
        } else if (state is CategoryLoaded) {
          // final categories = state.categories;
          final categories = state.categories.where((moduleCategory) =>
          moduleCategory.module.id == moduleId).toList();

          return  Column(
            children: [
              10.height,
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Category', style: textStyle12(context, color: CustomColor.appColor),),
                    10.width,
                    Expanded(child: Divider(color: CustomColor.appColor,))
                  ],
                ),
              ),
              15.height,
              Container(
                height: 150,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1 / 2.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return CustomContainer(
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.zero,
                      color: Colors.white,
                      onTap: () {
                        context.push(
                          '/subcategory/${category.id}?name=${Uri.encodeComponent(category.name)}',
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
            ],
          );
        } else if (state is CategoryError) {
          print("Error: ${state.message}");
        }
        return const SizedBox();
      },
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
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ShimmerBox(width: 80,height: 10,),
              ],
            ),
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
            itemBuilder: (_, __) =>  CustomContainer(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              child:  Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ShimmerBox(width: 80, height: 80,),

                    10.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ShimmerBox(width: 50,height: 5,),
                          5.height,
                          ShimmerBox(width: 60,height: 5,),
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
