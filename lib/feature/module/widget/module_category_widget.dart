import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_headline.dart';
import 'package:bizbooster2x/model/module_category_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../helper/api_helper.dart';
import '../screen/module_subcategory_screen.dart';

class ModuleCategoryWidget extends StatefulWidget {
  final String moduleIndexId;
  ModuleCategoryWidget({super.key,  required this.moduleIndexId});

  @override
  State<ModuleCategoryWidget> createState() => _ModuleCategoryWidgetState();
}

class _ModuleCategoryWidgetState extends State<ModuleCategoryWidget> {
  final CategoryService _categoryService = CategoryService();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Headline
        CustomHeadline(headline: "Services"),

        /// Services list
        FutureBuilder<List<ModuleCategoryModel>>(
          future: _categoryService.fetchCategories(),
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CategoryShimmerGrid();
            }

            else if (!snapshot.hasData && snapshot.data!.isEmpty) {
              return const Center(child: Text('No categories'));
            }

            else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final allCategories = snapshot.data!;
            final filteredCategories = allCategories.where((category) {
              final moduleId = category.module?.id;
              return moduleId == widget.moduleIndexId;
            }).toList();
            if (filteredCategories.isEmpty) {
              return const Center(child: Text('No categories'));
            }
            return Container(
              height: 150,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filteredCategories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 2.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final category = filteredCategories[index];

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
            );
          },
        ),
      ],
    );
  }
}


class CategoryShimmerGrid extends StatelessWidget {
  const CategoryShimmerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
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
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: CustomContainer(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
