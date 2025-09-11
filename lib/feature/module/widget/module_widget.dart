import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_network_mage.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../category/business/screen/business_screen.dart';
import '../../category/education/screen/education_screen.dart';
import '../../category/finance/screen/finance_service_screen.dart';
import '../../category/franchise/screen/franchise_screen.dart';
import '../../category/it_service/screen/it_service_screen.dart';
import '../../category/legal_service/screen/legal_service_screen.dart';
import '../../category/marketing/screen/marketing_screen.dart';
import '../../category/onboarding/screen/onboarding_screen.dart';
import '../../category/ondemand/screen/ondemand_screen.dart';
import '../bloc/module_bloc.dart';
import '../bloc/module_state.dart';

class ModuleWidget extends StatelessWidget {
  const ModuleWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Column(
      children: [
        15.height,

        Padding(
          padding:  EdgeInsets.symmetric(horizontal: dimensions.screenHeight*0.015),
          child: Row(
            children: [
              Text('Modules', style: textStyle12(context, color: CustomColor.appColor),),
              10.width,
              Expanded(child: Divider(color: CustomColor.appColor,))
            ],
          ),
        ),
        10.height,
        BlocBuilder<ModuleBloc, ModuleState>(
          builder: (context, state) {
            if (state is ModuleLoading) {
              return ModuleShimmer();
            } else if (state is ModuleLoaded) {
              final modules = state.modules;
              // final modules = state.modules.where((module) => module.categoryCount != 0).toList();
              return  GridView.builder(
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
                    border: false,
                    margin: EdgeInsets.zero,
                    color: Colors.white,
                    padding: EdgeInsets.zero,
                    // padding: EdgeInsets.zero,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Hero(
                          tag: module.id,
                          child: Material(
                            color: Colors.transparent,
                            child: CustomContainer(
                              color: Colors.transparent,
                              margin: EdgeInsets.zero,
                              networkImg: module.image,
                              // fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: dimensions.screenHeight*0.008,vertical: dimensions.screenHeight*0.010),
                          child: Text(module.name, style: textStyle12(context),overflow: TextOverflow.clip,textAlign: TextAlign.center,),
                        ),
                      ],
                    ),
                    // onTap: () {
                    //   final Map<String, Widget> categoryWidgets = {
                    //     'Franchise': FranchiseScreen(moduleId: module.id, imageUrl: module.image,),
                    //     'Business': BusinessScreen(moduleId: module.id, imageUrl: module.image),
                    //     'Marketing': MarketingScreen(moduleId: module.id, imageUrl: module.image, ),
                    //     'Legal Services': LegalServiceScreen(moduleId: module.id, imageUrl: module.image,),
                    //     'Finance': FinanceServiceScreen(moduleId: module.id, imageUrl: module.image,),
                    //     'It Services': ItServiceScreen(moduleId: module.id,imageUrl: module.image,),
                    //     'Education': EducationScreen(moduleId: module.id, imageUrl: module.image),
                    //     'On-Demand Services': OnDemandScreen(moduleId: module.id, imageUrl: module.image),
                    //     'Onboarding': OnboardingScreen(moduleId: module.id, imageUrl: module.image),
                    //   };
                    //
                    //   final screen = categoryWidgets[module.name];
                    //
                    //   if (screen != null) {
                    //     Navigator.push(context, MaterialPageRoute(builder: (context) => screen),);
                    //   }
                    //   else {
                    //     showCustomToast('Module "${module.name}" not found');
                    //   }
                    // },
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
                        'On-Demand Services': '/ondemand',
                        'Onboarding': '/onboarding',
                      };

                      final route = moduleRoutes[module.name];

                      if (route != null) {
                        // go_router navigation with moduleId as path parameter and image as query param
                        context.push('$route/${module.id}?image=${Uri.encodeComponent(module.image)}');
                      } else {
                        showCustomToast('Module "${module.name}" not found');
                      }
                    },

                  );
                },
              );
            } else if (state is ModuleError) {
              print("Modules : ${state.message}");
            }
            return Container();
          },
        )
      ],
    );
  }
}


/// Shimmer effect
class ModuleShimmer extends StatelessWidget {
  const ModuleShimmer({super.key});

  static const _itemCount = 9;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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
    );
  }
}