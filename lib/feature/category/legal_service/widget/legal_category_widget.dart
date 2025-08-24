import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../../subcategory/screen/subcategory_screen.dart';
import '../../bloc/category_bloc.dart';
import '../../bloc/category_state.dart';


class LegalCategoryWidget extends StatelessWidget {
  final String? moduleId;
   const LegalCategoryWidget({super.key, this.moduleId});

  @override
  Widget build(BuildContext context) {
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
                    Icon(Icons.apps, size: 19, color: Color(0xff264A7D)),5.width,
                    Text('Category', style: textStyle14(context, color: Color(0xff264A7D)),),
                    10.width,
                    Expanded(child: Divider(color: Color(0xff264A7D),))
                  ],
                ),
              ),
              15.height,
              SizedBox(
                height: 250,
                child: GridView.builder(
                  itemCount: categories.length,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 0.9,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return CustomContainer(
                      margin: EdgeInsets.zero,
                      color: CustomColor.whiteColor,
                      networkImg: category.image,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(category.name, style: textStyle12(context),overflow: TextOverflow.ellipsis,maxLines: 2,),
                        ],
                      ),
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
                    );
                  },),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerBox(width: 80,height: 10,),
                ShimmerBox(width: 20,height: 10,),
              ],
            ),
          ),
        ),


        SizedBox(
          height: 250,
          child: GridView.builder(
            itemCount: 15,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 0.9,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10
            ),
            itemBuilder: (context, index) {
              return CustomContainer(
                margin: EdgeInsets.zero,
                child:  Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ShimmerBox(height: 10,width: 50,)
                    ],
                  ),
                ),
              );
            },),
        ),
      ],
    );
  }
}