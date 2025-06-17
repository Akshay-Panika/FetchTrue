import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../bloc/module_subcategory/module_subcategory_bloc.dart';
import '../bloc/module_subcategory/module_subcategory_event.dart';
import '../bloc/module_subcategory/module_subcategory_state.dart';
import '../repository/module_subcategory_service.dart';


class ModuleSubcategoryWidget extends StatefulWidget {
  final String categoryId;
  final String subcategoryId;
  final ValueChanged<String>? onChanged;
  const ModuleSubcategoryWidget({super.key, required this.categoryId, required this.subcategoryId, this.onChanged,});

  @override
  State<ModuleSubcategoryWidget> createState() => _ModuleSubcategoryWidgetState();
}

class _ModuleSubcategoryWidgetState extends State<ModuleSubcategoryWidget> {

  late String _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.subcategoryId;
  }


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
            subcategory.category.id == widget.categoryId).toList();

            if (modulesSubCategory.isEmpty) {
              return const Center(child: Text('No subcategory found.'));
            }

            ///  Default subcategory selection (first one)
            if (_selectedId.isEmpty && modulesSubCategory.isNotEmpty) {
              _selectedId = modulesSubCategory.first.id;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                widget.onChanged?.call(_selectedId);
                setState(() {});
              });
            }
            return  Container(
                height: 160,
                child: ListView.builder(
                  itemCount: modulesSubCategory.length,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  itemBuilder: (context, index) {
                    final sub = modulesSubCategory[index];
                    final isSelected = sub.id == _selectedId;
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        setState(() => _selectedId = sub.id);
                        widget.onChanged?.call(_selectedId);
                      },
                      child: Column(
                        children: [
                          CustomContainer(
                            border: true,
                            height: 80,width: 80,
                            backgroundColor: CustomColor.whiteColor,
                            networkImg: sub.image,
                            margin: EdgeInsets.all(5),
                            borderColor: isSelected ? CustomColor.appColor : null,
                          ),

                          SizedBox(width: 80,
                              child: Text(sub.name, style: textStyle12(context, color: isSelected ? CustomColor.appColor : Colors.black, fontWeight: FontWeight.w400),textAlign: TextAlign.center, maxLines: 3, overflow: TextOverflow.ellipsis,)),
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
      height: 130,
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            children: [
              CustomContainer(
                height: 80,width: 80,
                backgroundColor: CustomColor.whiteColor,
              ),

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
        ),
      ),
    );
  }
}
