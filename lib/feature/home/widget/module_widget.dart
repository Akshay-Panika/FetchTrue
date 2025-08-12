import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../category/business/screen/business_service_screen.dart';
import '../../category/education_service/screen/education_service_screen.dart';
import '../../category/finance/screen/finance_service_screen.dart';
import '../../category/franchise/screen/franchise_service_screen.dart';
import '../../category/home_service/screen/home_service_screen.dart';
import '../../category/it_service/screen/it_service_screen.dart';
import '../../category/legal_service/screen/legal_service_screen.dart';
import '../../category/marketing/screen/marketing_service_screen.dart';
import '../../category/onboarding/screen/onboarding_service_screen.dart';
import '../bloc/module/module_bloc.dart';
import '../bloc/module/module_event.dart';
import '../bloc/module/module_state.dart';
import '../repository/module_service.dart';

class ModuleWidget extends StatelessWidget {
  final Dimensions dimensions;
  const ModuleWidget({super.key, required this.dimensions});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            15.width,
            Text('🔷 Modules', style: textStyle14(context),),
            Expanded(child: CustomContainer(padding: EdgeInsets.zero,height: 1,color: CustomColor.appColor.withOpacity(0.8),))
          ],
        ),
        SizedBox(height: dimensions.screenHeight*0.01,),

        BlocProvider(
          create: (_) => ModuleBloc(ModuleService())..add(GetModule()),
          child:  BlocBuilder<ModuleBloc, ModuleState>(
            builder: (context, state) {
              if (state is ModuleLoading) {
                return ModuleShimmer();
              }
              else if(state is ModuleLoaded){
                // final modules = state.moduleModel;
                final modules = state.moduleModel .where((module) => module.categoryCount != 0)
                    .toList();

                if (modules.isEmpty) {
                  return const Center(child: Text('No modules found.'));
                }

                return  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.builder(
                    itemCount: modules.length,
                    shrinkWrap: true,
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
                        margin: EdgeInsets.zero,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomContainer(
                                networkImg: module.image,
                                margin: EdgeInsets.zero,
                                color: Colors.transparent,
                              ),
                            ),
                            Text(module.name, style: textStyle12(context),overflow: TextOverflow.clip,textAlign: TextAlign.center,),
                          ],
                        ),
                        onTap: () {
                          final Map<String, Widget> categoryWidgets = {
                            'Franchise': FranchiseServiceScreen(moduleId: module.id),
                            'Business': BusinessServiceScreen(moduleId: module.id),
                            'Marketing': MarketingServiceScreen(moduleId: module.id),
                            'Legal Services': LegalServiceScreen(moduleId: module.id),
                            'Finance': FinanceServiceScreen(moduleId: module.id),
                            'It Services': ItServiceScreen(moduleId: module.id),
                            'Education': EducationServiceScreen(moduleId: module.id),
                            'On-Demand Services': HomeServiceScreen(moduleId: module.id),
                            'Onboarding': OnboardingServiceScreen(moduleId:module.id),
                          };

                          final screen = categoryWidgets[module.name];

                          if (screen != null) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => screen),);
                          } else {
                            showCustomSnackBar(context, 'Module "${module.name}" not found');
                          }
                        },
                      );
                    },
                  ),
                );
              }

              else if (state is ModuleError) {
                return Center(child: Text(state.errorMessage));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        itemCount: _itemCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.11 / 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              5.height,
              CustomContainer(
                height: 6,
                width: 80,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                color: CustomColor.whiteColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}