import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_log_emoji.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_network_mage.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../bloc/module_bloc.dart';
import '../bloc/module_event.dart';
import '../bloc/module_state.dart';
import '../repository/module_repository.dart';

class ModuleWidget extends StatelessWidget {
  const ModuleWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image/module_cover_img.jpg',),
          fit: BoxFit.cover,
        ),
      ),
      child: BlocProvider(
        create: (_) => ModuleBloc(ModuleRepository())..add(GetModules()),
        child: BlocBuilder<ModuleBloc, ModuleState>(
          builder: (context, state) {
            if (state is ModuleLoading) {
              return ModuleShimmer();
            } else if (state is ModuleLoaded) {
              final modules = state.modules;
              // final modules = state.modules.where((module) => module.categoryCount != 0).toList();
              return  Column(
                children: [
                  10.height,
                  /// Stylish Title
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth * 0.02),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${CustomLogEmoji.thunderbolt}   Our Services   ${CustomLogEmoji.thunderbolt}',
                        style: textStyle14(
                          context,
                          color: CustomColor.appColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  10.height,
                  Center(
                    child: GridView.builder(
                      itemCount: modules.length,
                      shrinkWrap: true,
                      padding: EdgeInsetsGeometry.symmetric(horizontal: dimensions.screenHeight*0.010),
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.11 / 1,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10
                      ),
                      itemBuilder: (context, index) {
                        final module = modules[index];
                        return CustomContainer(
                          border: true,
                          borderRadius: true,
                          borderColor: CustomColor.appColor,
                          margin: EdgeInsets.zero,
                          color: Colors.white,
                          padding: EdgeInsets.zero,

                          // padding: EdgeInsets.zero,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              Hero(
                                tag: module.id.toString(),
                                child: Material(
                                  color: Colors.transparent,
                                  child: CustomNetworkImage(
                                     imageUrl: module.image.toString(),
                                     borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:  EdgeInsets.symmetric(horizontal: dimensions.screenHeight*0.008,vertical: dimensions.screenHeight*0.010),
                                child: Text(module.name.toString(), style: textStyle12(context),overflow: TextOverflow.clip,textAlign: TextAlign.center,),
                              ),
                            ],
                          ),
                          onTap: () {
                            // module name → route mapping
                            final Map<String, String> moduleRoutes = {
                              'Franchise': '/franchise',
                              'Business': '/business',
                              'Marketing': '/marketing',
                              'Legal Services': '/legal',
                              'Finance': '/finance',
                              'It Services': '/it',
                              'Education': '/education',
                              'On-Demand': '/ondemand',
                              'AI Hub': '/ai-hub',
                            };

                            final route = moduleRoutes[module.name];

                            if (route != null) {
                              // go_router navigation with moduleId as path parameter and image as query param
                              context.push('$route/${module.id}?image=${Uri.encodeComponent(module.image.toString())}');
                            } else {
                              showCustomToast('Module "${module.name}" not found');
                            }
                          },

                        );
                      },
                    ),
                  ),
                  10.height
                ],
              );
            } else if (state is ModuleError) {
              print("Modules : ${state.message}");
            }
            return Container();
          },
        ),
      ),
    );
  }
}


/// Shimmer effect
class ModuleShimmer extends StatelessWidget {
  const ModuleShimmer({super.key});

  static const _itemCount = 9;

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Column(
      children: [

        10.height,
        /// Stylish Title
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: ShimmerBox(height: 25, width: 100,),
        ),
        15.height,
        Center(
          child: GridView.builder(
            itemCount: _itemCount,
            shrinkWrap: true,
            padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.11 / 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (_, __) => CustomContainer(
              margin: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: ShimmerBox(height: 10, width: 80,),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}